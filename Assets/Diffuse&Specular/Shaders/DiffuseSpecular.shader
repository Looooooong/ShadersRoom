Shader "ShadersRoom/DiffuseSpecular" {
	Properties
	{
		_MainColor("Main Color",Color) = (1,1,1,1)
		_MainTexture("Main Texture",2D) = "white"{}
		_Specular("Specular Color",Color) = (1,1,1,1)
		_Gloss("Gloss",range(10,100)) = 20
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

			
			sampler2D _MainTexture;
			fixed4 _Specular;
			half _Gloss;
			fixed4 _MainColor;


			struct a2v
			{
				float4 vert : POSITION;				//取得模型空间下的顶点坐标
				fixed3 normal : NORMAL;				//取得模型空间下的法线
				float2 texcoord : TEXCOORD0;		//取得的uv坐标
			};

			struct v2f
			{
				float4 sv_vert : SV_POSITION;		//传递剪裁空间中的顶点坐标
				float2 uv : TEXCOORD0;				//通过TEXCOORD0通道传递uv
				fixed3 worldNormal : TEXCOORD1;		//通过TEXCOORD1传递世界空间下的法线坐标
				float4 worldVertex : TEXCOORD2;		//通过TEXCOORD2传递世界空间下的顶点坐标
			};
			
			v2f vert(a2v v)
			{
				v2f f;
				f.sv_vert = UnityObjectToClipPos(v.vert);			//将顶点的坐标从模型空间转化成剪裁空间
				f.uv = v.texcoord;									//传递顶点空间下的UV
				f.worldNormal = UnityObjectToWorldNormal(v.normal);	//将法线从模型空间转化成世界空间
				f.worldVertex = mul(v.vert,unity_WorldToObject);	//将顶点的坐标从模型空间转化成世界空间
				return f;

			}


			fixed4 frag(v2f f) : SV_Target
			{
			
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;		//UNITY_LIGHTMODEL_AMBIENT 取得系统的环境光
				
				fixed3 texcolor = tex2D(_MainTexture,f.uv) * _MainColor + ambient; 	//取得图片的纹理贴图颜色同时融合主颜色

				fixed3 normalDir = normalize(f.worldNormal);	//归一化法线向量

				fixed3 lightDir = WorldSpaceLightDir(f.worldVertex);	//取得顶点的光照方向

				//计算漫反射光照 Diffuse = 直射光颜色 * max(0,cos夹角(光和法线的夹角) )  cosθ = 光方向· 法线方向
				fixed3 diffuse = _LightColor0.rgb * texcolor * max(dot(normalDir,lightDir) * 0.5 + 0.5,0);	 //半兰伯特光照模： 比兰伯特模型的亮度要大一些,被光面不至于全黑

				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(f.worldVertex));	//视野方向

				fixed3 halfDir = normalize(viewDir + lightDir);		//视野和光照方向的平分线

				//计算高光反射Blinn Phong模型 Specular = 直射光  * pow( max(cosθ,0),10)  θ:是法线和x的夹角  x 是平行光和视野方向的平分线
				fixed3 specular = _LightColor0.rgb * _Specular * pow(max(dot(normalDir,halfDir),0),_Gloss);

				fixed3 tempColor = diffuse + specular  ;//漫反射和高光叠加成最终颜色返回

				return fixed4(tempColor,1);
			}

			ENDCG

		}
	}
	Fallback off


}
