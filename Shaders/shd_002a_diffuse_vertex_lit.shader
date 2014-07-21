
// Shader 		: 	Diffuse Lighting (Vertex Lit)
// Author 		: 	Vishang Shah (vishangshah.com)
// Description 	: 	This shader performs N.L lighting calculation based on Lambertian model.
//					http://en.wikipedia.org/wiki/Lambertian_reflectance
//
//					Vertex shader transforms vertices from model to projection space.
//					It also transform vertex normals and passed to fragment shader.
//					In this shader vertex shader also calculatesreflectance from dot product of
//					 normal and light vectors.
//

// Defining category and name of the shader
Shader "Demo/002a Diffuse Lighting - Vertex Lit"
{
	// Here we define properties exposed in the material for user to control
	Properties
	{
		// Ambient color
		_AmbientColor ("Ambient Color", Color) = (1.0, 1.0, 1.0, 1.0)
		// Defining Diffuse color property as a float4
		_DiffuseColor ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	// There can be multiple shaders based on platform? GPU? Deployment?
	SubShader
	{
		// There can be multiple passes of calculation
		Pass
		{
			// Tags to tell shader the lighting model
			// It's important to include this otherwise the dynamic lights will not be considered
			//
			Tags { "LightMode" = "ForwardBase" }
			// This is where CG shader code starts in Unity3D shader
			CGPROGRAM
			
			// Providing names of vertex and fragment functions for each shader
			#pragma vertex 		vertexCode
			#pragma fragment 	fragmentCode

			// User defined variables (mostly from Propeties above)
			uniform float4 _DiffuseColor;
			uniform float4 _AmbientColor;

			// Variables to move data to and from both shaders

			// Structs
			// As we are going to deal with more properties of vertices than just position,
			// It's better to use structures (a la C/C++), to package per-vertex properties
			//
			// Structure to pass data from application to vertex shader
			struct vertexIn
			{
				// vertex position with semantic POSITION
				//
				float4 vertPos 	: POSITION;
				// vertex normals - semantic normal
				float3 vertNorm	: NORMAL;
			};
			//
			// Structure to pass data from vertex shader to fragment shader
			struct fragmentIn
			{
				// fragment position as a result of transformation in vertex shader
				float4 fragPos 	: SV_POSITION;
				float4 fragCol  : COLOR;
			};
			//
	
			// Vertex Shader
			// In this shader, we are going to calculate lighting in vertex shader
			// It will be cheaper to run on GPUs, due to less no. of vertices than pixel
			// But it will be of lower quality and may show some artifacts
			//
			fragmentIn vertexCode(vertexIn vertIn)
			{
				fragmentIn fragIn;
				// To get fragment position,
				// Multiplying vertex position with ModelViewProjection matrix in Unity3D
				fragIn.fragPos = mul(UNITY_MATRIX_MVP, vertIn.vertPos);
				
				// Calculating Normal Direction
				float3 normalDirection = normalize(mul(float4(vertIn.vertNorm,0.0), _World2Object).xyz);

				// Calculating Light Direction
				float3 lightDirection = normalize(_WorldSpaceLightPos0).xyz;

				fragIn.fragCol = _AmbientColor + _DiffuseColor * max(dot(normalDirection, lightDirection),0.0);

				return fragIn;

			}

			// Fragment Shader
			float4 fragmentCode(fragmentIn fragIn) : COLOR
			{
				// Returning fragment color calculated in vertex shader
				return fragIn.fragCol;
			}

			// End of CG code
			ENDCG
		}
	}
}
