
// Shader 		: 	Ambient Lighting
// Author 		: 	Vishang Shah (vishangshah.com)
// Description 	: 	This shader does no lighting calculation and simply returns a flat color based on user 	//				  	input.
//					Vertex shader transforms vertices from model to projection space.
//					Fragment shader returns a color.

// Defining category and name of the shader
Shader "MyShaders/BRDF_Lighting/001 Ambient Lighting"
{
	// Here we define properties exposed in the material for user to control
	// We also provide default values in the definition
	Properties
	{
		// Defining ambient color property as a float4
		_AmbientColor ("Ambient Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	// There can be multiple shaders based on platform? GPU? Deployment?
	// Each of those are divided into SubShaders
	SubShader
	{
		// There can be multiple passes of calculation
		Pass
		{
			// This is where CG shader code starts in Unity3D
			CGPROGRAM
			
			// Providing names of vertex and fragment functions for each shader
			#pragma vertex 		vertexCode
			#pragma fragment 	fragmentCode

			// User defined variables (mostly from Propeties above)
			uniform float4 _AmbientColor;

			// Variables to move data to and from both shaders

			// vertex position with semantic POSITION (application to vertex shader)
			// A note of Semantics :
			// They are basically keywords telling application and GPU about what "kind of" data is being
			// passed.
			// As we will see later, we don't really need to use, say NORMAL semantic for normals
			// This way we can pass whatever in whichever semantic type, provided the type and
			// dimensions match
			//
			float4 vertPos 	: POSITION;
			// fragment position as a result of transformation in vertex shader
			float4 fragPos 	: SV_POSITION;
		

			// Vertex Shader
			float4 vertexCode(float4 vertPos : POSITION) : SV_POSITION
			{
				// Multiplying vertex position with ModelViewProjection matrix in Unity3D
				return mul(UNITY_MATRIX_MVP, vertPos);
				
				// Remember that matrix multiplication is not commutative.
				// So the code below will give weird results due to vertices not being transformed propertly
				// return mul(vertPos, UNITY_MATRIX_MVP);
			}

			// Fragment Shader
			float4 fragmentCode(float4 fragPos)	: COLOR
			{
				// Just returning user-defined color
				return _AmbientColor;
			}

			// End of CG code
			ENDCG
		}
	}
}
