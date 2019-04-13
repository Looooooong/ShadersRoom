Shader "ShadersRoom/SurfaceShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)

		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_AlphaTest("AlphaTest",Range(0,1)) = 0

		_MetallicTex("Metallic",2D) = "white"{}
		_Metallic ("Metallic", Range(0,1)) = 0.0

		_SmoothnessTex("Smoothness",2D) = "white"{}
		_Smoothness("Intensity",Range(0,1)) = 0

		_NormalTex("Normal",2D) = "white"{}
		_Normal("Intensity",float) = 1

		_Speed("Speed",float) = 1
		_Frequency("Frequency",float) = 1
		_Amplitude("Amplitude",float) = 1
	}
	SubShader {
		Tags { 
				"RenderType"="Opaque" 
				"Queue" = "AlphaTest" 
			 }
		LOD 200
		Cull off

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert addshadow alphatest:_AlphaTest

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _MetallicTex;
		sampler2D _SmoothnessTex;
		sampler2D _NormalTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Smoothness;
		half _Metallic;
		float _Normal;

		half _Speed;
		half _Frequency;
		half _Amplitude;


		fixed4 _Color;


		void vert(inout appdata_full v)
		{
			float time = _Time.y * _Speed;
			float offset = (sin(time + v.vertex.z * _Frequency)) * _Amplitude;
			

			v.vertex.y += offset;
		}

		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			// Metallic and smoothness come from slider variables
			o.Metallic = tex2D(_MetallicTex,IN.uv_MainTex) * _Metallic;
			o.Smoothness = tex2D(_SmoothnessTex,IN.uv_MainTex) * _Smoothness;
			

			fixed3 n = UnpackNormal(tex2D(_NormalTex,IN.uv_MainTex)).rgb;
			n.x *= _Normal;
			n.y *= _Normal;
			o.Normal = n;

		}
		ENDCG
	}
	FallBack "Diffuse"
}
