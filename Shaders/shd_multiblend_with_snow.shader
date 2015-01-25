/*

// Shader 		: 	MultiBlend with Snow
// Author 		: 	Vishang Shah (vishangshah.com)
// Description 	: 	This shader blends two diffuse and normal maps based on vertex alpha
					and first diffuse map's alpha channel.
					Snow is applied on surface normals facing up.
					Specular maps are encoded in alpha channel of Normal maps.
//

*/
Shader "MyShaders/MultiBlend with Snow"
{
	Properties
	{
		_AmbientFactor 	("Ambient Factor", 	Range(0.0, 1.0))	= 0.3

		_DiffuseMap1	("Diffuse Map 1", 	2D) 				= "white" {}
		_NormalMap1		("Normal Map 1", 	2D) 				= "white" {}

		_DiffuseMap2	("Diffuse Map 2", 	2D) 				= "white" {}
		_NormalMap2		("Normal Map 2", 	2D) 				= "white" {}

		_SpecularColor 	("Specular Color", 	Color)				= (1.0, 1.0, 1.0, 1.0)
		_Glossiness 	("Glossiness", 		Range(0.0, 10.0))	= 5.0

		_SnowColor 		("Snow Color", 		Color)				= (1.0, 1.0, 1.0, 1.0)
		_SnowNormalMap	("Snow Normal Map", 2D)					= "white" {}

	}
	SubShader
	{
		Pass
		{
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM
			#include "UnityCG.cginc"

			uniform float 		_AmbientFactor;

			uniform sampler2D	_DiffuseMap1;
			uniform sampler2D 	_NormalMap1;

			uniform sampler2D 	_DiffuseMap2;
			uniform sampler2D 	_NormalMap2;

			uniform float4 		_SpecularColor;
			uniform float 		_Glossiness;

			uniform float4 		_SnowColor;
			uniform sampler2D 	_SnowNormalMap;

			#pragma vertex 		vertexProgram
			#pragma fragment 	fragmentProgram

			struct app2vertex
			{
				float4 vPos			: POSITION;
				float3 vNorm		: NORMAL;
				float4 vTangent		: TANGENT;
				float2 UV 			: TEXCOORD0;
				float4 vColor		: COLOR;

			};

			struct vertex2Fragment
			{
				float4 fPos 		: SV_POSITION;
				float3 fNorm		: NORMAL;
				float3 fTangent		: TEXCOORD3;
				float3 fBinormal	: TEXCOORD4;
				float2 UV 			: TEXCOORD0;
				float4 vColor		: COLOR;
				float4 fWorldPos	: TEXCOORD5;
			};

			vertex2Fragment vertexProgram(app2vertex input)
			{
				vertex2Fragment output;
				
				// Transform vertex inputs
				output.fPos 		= mul(UNITY_MATRIX_MVP, input.vPos);
				output.fNorm 		= normalize(mul(_Object2World, input.vNorm));
				output.fTangent 	= normalize(mul(_Object2World, input.vTangent));
				output.fBinormal	= normalize(cross(output.fNorm, output.fTangent)) * input.vTangent.w;
				output.UV 			= input.UV;
				output.vColor 		= input.vColor;
				output.fWorldPos 	= mul(_Object2World, input.vPos);

				return output;
			}

			float4 fragmentProgram(vertex2Fragment input)	: COLOR0
			{
				float4 fColor;
				float2 uv = input.UV;

				// Sample texture maps and unpack normal maps
				float4 diffuse1 = tex2D(_DiffuseMap1, uv);
				float4 diffuse2 = tex2D(_DiffuseMap2, uv);

				float4 normal1 	= tex2D(_NormalMap1, uv);
				float4 normal2 	= tex2D(_NormalMap2, uv);

				float spec1 = normal1.a;
				float spec2 = normal2.a;

				float3 unpackedNormal1 	= 2.0 * normal1.rgb - float3(1,1,1);
				float3 unpackedNormal2 	= 2.0 * normal2.rgb - float3(1,1,1);

				unpackedNormal1.z = 0.5;
				unpackedNormal2.z = 0.5;

				float4 snowNormal = tex2D(_SnowNormalMap, uv * 10);
				float3 unpackedSnowNormal 	= 2.0 * snowNormal.rgb - float3(1,1,1);
				float snowSpec = snowNormal.a;
				unpackedSnowNormal.z = 0.5;

				// Normal calculation in tangent space
				float3x3 tangetSpaceXform = float3x3(input.fTangent, input.fBinormal, input.fNorm);
				float3 normalDir1 = normalize(mul(unpackedNormal1, tangetSpaceXform));
				float3 normalDir2 = normalize(mul(unpackedNormal2, tangetSpaceXform));

				// Blending of Textures based on vertex alpha and blending mask in Diffuse1 Alpha
				float blendFactor = input.vColor.a * diffuse1.a;
				float4 fDiffuse = lerp(diffuse1, diffuse2, blendFactor);
				//fDiffuse = diffuse1;
				float3 fNormal = lerp(normalDir1, normalDir2, blendFactor);
				float fSpec = lerp(spec1, spec2, blendFactor);


				// Snow contribution
				float3 upVector = float3(0, 1, 0);
				float snowFactor = max(0, dot(fNormal, upVector));
				snowFactor = pow(snowFactor, 0.3);

				float3 normalWithSnow = lerp(fNormal, normalize(fNormal * 0.8 + unpackedSnowNormal), snowFactor);

				// Light Contribution
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float lightContrib = max(_AmbientFactor, dot(normalWithSnow, lightDir));

				// Specular Contribution
				float3 viewDir = normalize(_WorldSpaceCameraPos - input.fWorldPos);
				float3 lightReflectDir = reflect(-lightDir, normalWithSnow);
				float specularTerm = pow(max(0, dot(lightReflectDir, viewDir)), _Glossiness) * max(0, dot(fNormal, lightDir));
				float specWithSnow = lerp(specularTerm, snowSpec, snowFactor);

				float4 specularContrib = _SpecularColor * specularTerm;
				float4 specularWithSnow = _SpecularColor * specWithSnow;

				float4 diffuseWithSnow = lerp(fDiffuse, _SnowColor, snowFactor);
				
				fColor = diffuseWithSnow * lightContrib + specularWithSnow;

				return fColor;

			}


			ENDCG
			
		}
	}
	FallBack "Diffuse"
}