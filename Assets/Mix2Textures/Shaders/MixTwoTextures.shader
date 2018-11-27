Shader "ShadersRoom/MixTwoTextures"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SecondTex ("SecondTex", 2D) = "white" {}
		_TextureMix("TextureMix",range(-0.2,1.2)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv1 : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
				float4 vertex : SV_POSITION;
				float2 localPos : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _SecondTex;
			float4 _SecondTex_ST;
			half _TextureMix;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.localPos = v.vertex.xy + float2(0.5,0.5);  //i.vertex 范围在（-0.5，0.5）之间,加上0.5取值到0-1
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv1 = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv2= TRANSFORM_TEX(v.uv, _SecondTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed distanceFrontMixPoint = _TextureMix - i.localPos.x;

				if(abs(distanceFrontMixPoint) < 0.2)
				{
					fixed mixFactor = 1 - (distanceFrontMixPoint + 0.2)/0.4;
					return lerp(tex2D(_MainTex, i.uv1),tex2D(_SecondTex,i.uv2),mixFactor);
				}

				if(i.localPos.x < _TextureMix)
				{
					return tex2D(_MainTex, i.uv1);
				}
				else
				{
					return tex2D(_SecondTex,i.uv2);
				}
			}
			ENDCG
		}
	}
}
