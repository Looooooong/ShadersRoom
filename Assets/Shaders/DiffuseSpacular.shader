// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "MG/DiffuseSpacular" {
	Properties
	{
		_MainTexture("Main Texture",2D) = "white"{}
		_Diffuse("Diffuse Color",Color) = (1,1,1,1)
		_Specular("Specular Color",Color) = (1,1,1,1)
		_Gloss("Gloss",range(10,20)) = 20
	}
	SubShader
	{
	
		Pass
		{
			Tags{"LightMode" = "ForwardBase"}
			CGPROGRAM
			#include "Lighting.cginc"
			#pragma vertex vert
			#pragma fragment frag

			struct a2v
			{
				float4 vertex : POSITION;
				fixed3 normal : NORMAL;
				float4 uvTexcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 svPos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float4 worldVertex : TEXCOORD1;

				float2 uv : TEXCOORD2;
			};

			sampler2D _MainTexture;
			float4 _MainTexture_ST;
			//fixed4 _Diffuse;
			fixed4 _Specular;
			half _Gloss;

			v2f vert(a2v v)
			{
				v2f f;
				f.svPos = UnityObjectToClipPos(v.vertex);
				f.worldNormal = UnityObjectToWorldNormal(v.normal);
				f.worldVertex = mul(v.vertex, unity_WorldToObject);
				f.uv = v.uvTexcoord.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;

				return f;
			}

			fixed4 frag(v2f f) :SV_Target
			{
				fixed3 normalDir = normalize(f.worldNormal);

				fixed3 lightDir = normalize(WorldSpaceLightDir(f.worldVertex));

				fixed3 texColor = tex2D(_MainTexture,f.uv.xy) * UNITY_LIGHTMODEL_AMBIENT.rgb;

				fixed3 diffuse = _LightColor0.rgb * texColor * max(dot(normalDir,lightDir) * 0.5 + 0.5,0);
				
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(f.worldVertex));

				fixed3 halfDir = normalize(lightDir + viewDir);

				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(dot(normalDir,halfDir),0),_Gloss);

				fixed3 color = diffuse + specular;

				return fixed4(color,1);


			}


			ENDCG
		}
	}

	Fallback "Specular"
}
