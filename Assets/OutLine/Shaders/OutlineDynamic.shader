// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShadersRoom/OutlineDynamic" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _Outline ("_Outline", Range(0,0.1)) = 0
        _OutlineColor ("Color", Color) = (1, 1, 1, 1)
		_OutLineControl("_OutLineControl",Range(-.6,.6)) = 0


		
    }
    SubShader {
        Pass {
            Tags { "RenderType"="Opaque" }
            Cull Front
 
            CGPROGRAM
 
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
 
		
		struct appdata{
			float4 vertex :POSITION;
			float3 normal: NORMAL;
		};

			
		struct v2f {
			float4 pos:SV_POSITION;
			float3 modelPos : TEXCOORD0;
		};

 
            float _Outline;
            float4 _OutlineColor;
			float _OutLineControl;


			
            v2f vert(appdata v){
                v2f o;
				
				o.modelPos = v.vertex.xyz;
                o.pos = UnityObjectToClipPos(v.vertex);
                float3 normal = mul((float3x3) UNITY_MATRIX_MV, v.normal);
                normal.x *= UNITY_MATRIX_P[0][0];
                normal.y *= UNITY_MATRIX_P[1][1];
                o.pos.xy += normal.xy * _Outline;
				return o;

				/*
				o.modelPos = v.vertex.xyz;
				v.vertex.xyz *= (1+_Outline);
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
				*/
            }
 
            half4 frag(v2f i) : COLOR {
				
				if(i.modelPos.x < _OutLineControl) discard;
				return _OutlineColor;

			}
            ENDCG
        }
 
        CGPROGRAM
        #pragma surface surf Lambert
 
        sampler2D _MainTex;
 
        struct Input {
            float2 uv_MainTex;
        };
 
        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
        }
 
        ENDCG
    }
    FallBack "Diffuse"
}