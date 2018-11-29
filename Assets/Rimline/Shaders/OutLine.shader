Shader "ShadersRoom/OutLine" {
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_EdgeColor("Edge Color", Color) = (1,1,1,1)
		_OutRange("OutRange",range(.5,2)) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{

			Name "Edge pass"
			ZTest Greater
			Blend One One

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;

				float3 normal : NORMAL;

			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;

				float3 normal : NORMAL;
				float3 viewDir : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _EdgeColor;
			float _OutRange;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				o.normal = UnityObjectToWorldNormal(v.normal);   //将法线坐标转化到世界坐标
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);  //计算视野的方向

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float OneMinusNdotV = 1 - saturate(dot(i.normal, i.viewDir)) * _OutRange;  //计算边缘光,_OutRange越大靠近边缘
				return _EdgeColor * OneMinusNdotV;
			}
			ENDCG
		}

		Pass
		{
		
			Name "Model pass"
			ZTest Less 

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
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
