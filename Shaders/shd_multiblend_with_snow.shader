
Shader "MyShaders/MultiBlend with Snow"
{
	Properties
	{
		_DiffuseMap1	("Diffuse Map 1", 	2D) 	= "white" {}
		_NormalMap1		("Normal Map 1", 	2D) 	= "white" {}
		_SpecGlossMap1	("SpecGloss Map 1", 2D)		= "white" {}

		_DiffuseMap2	("Diffuse Map 2", 	2D) 	= "white" {}
		_NormalMap2		("Normal Map 2", 	2D) 	= "white" {}
		_SpecGlossMap2	("SpecGloss Map 2", 2D)		= "white" {}

		_SnowColor 		("Snow Color", 		Color)	= (1.0, 1.0, 1.0, 1.0)
		_SnowNormalMap	("Snow Normal Map", 2D)		= "white" {}

	}
	SubShader
	{
		Pass
		{
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#include "UnityCG.cginc"

			uniform sampler2D	_DiffuseMap1;
			uniform sampler2D 	_NormalMap1;
			uniform sampler2D 	_SpecGlossMap1;

			uniform sampler2D 	_DiffuseMap2;
			uniform sampler2D 	_NormalMap2;
			uniform sampler2D 	_SpecGlossMap2;

			uniform float4 		_SnowColor;
			uniform sampler2D 	_SnowNormalMap;

			#pragma vertex 		vertexProgram
			#pragma fragment 	fragmentProgram

			struct app2vertex
			{
				float4 vPos			: POSITION;
				float3 vNorm		: NORMAL;
				float2 UV 			: TEXCOORD0;
				float4 vColor		: COLOR;

			};

			struct vertex2Fragment
			{
				float4 fPos 		: SV_POSITION;
				float3 fNorm		: NORMAL;
				float2 UV 			: TEXCOORD0;
				float4 vColor		: COLOR;
			};

			vertex2Fragment vertexProgram(app2vertex input)
			{
				vertex2Fragment output;
				
				// Transform vertex inputs
				output.fPos 	= mul(UNITY_MATRIX_MVP, input.vPos);
				output.fNorm 	= mul(_Object2World, input.vNorm);
				output.UV 		= input.UV;
				output.vColor 	= input.vColor;

				return output;
			}

			float4 fragmentProgram(vertex2Fragment input)	: COLOR0
			{
				float4 fColor;
				float2 uv = input.UV;
				fColor = float4(0., 0.6, 0.8, 1.0);

				// Sample texture maps
				float4 diffuse1 = tex2D(_DiffuseMap1, uv);
				float4 diffuse2 = tex2D(_DiffuseMap2, uv);

				// Blending of Textures based on vertex alpha and blending mask in Diffuse1 Alpha
				float blendFactor = input.vColor.a * diffuse1.g;
				float4 diffuse = lerp(diffuse1, diffuse2, blendFactor);

				// Snow contribution
				float3 upVector = float3(0, 1, 0);
				float snowFactor = max(0, dot(input.fNorm, upVector));
				snowFactor = pow(snowFactor, 0.5);
				float4 diffuseWithSnow = lerp(diffuse, _SnowColor, snowFactor);

				// Light Contribution
				float4 lightPos = _WorldSpaceLightPos0;
				float d = max(0, dot(input.fNorm, lightPos));
				float3 lightContrib = float3(d, d, d);
				

				fColor = diffuseWithSnow;
				fColor *= float4(lightContrib, 1.0);

				//fColor = float4(input.vColor.a, input.vColor.a, input.vColor.a,input.vColor.a );

				return fColor;

			}


			ENDCG
			
		}
	}
	FallBack "Diffuse"
}