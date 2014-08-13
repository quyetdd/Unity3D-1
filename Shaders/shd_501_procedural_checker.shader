//---------------------------------------------------------
// Procedural Checker
// Unity3D Shader
// Vishang Shah
//---------------------------------------------------------
Shader "MyShaders/Procedural - Checker"
{
	Properties
	{

	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			
			#pragma vertex 		vertexCode
			#pragma fragment	fragmentCode

			struct vertIn
			{
				float4 vertPos	: POSITION;
				float2 uv		: TEXCOORD0;
			};
			struct fragIn
			{
				float4 fragPos	: SV_POSITION;
				float4 color	: COLOR0;
				float2 uv		: TEXCOORD0;
			};

			fragIn vertexCode(vertIn v)
			{
				fragIn f;
				f.fragPos = mul(UNITY_MATRIX_MVP, v.vertPos);
				f.uv = v.uv;
				return f;
			}

			float4 fragmentCode(fragIn f) : COLOR0
			{

				float4 white = float4(1.0,1.0,1.0,1.0);
				float4 black = float4(0.0,0.0,0.0,1.0);

				if(fmod(f.uv.x * 8, 2) > 1)
				{
					if(fmod(f.uv.y * 8, 2) > 1)
						f.color = white;
					else
						f.color = black;
				}
				else
				{
					if(fmod(f.uv.y * 8, 2) < 1)
						f.color = white;
					else
						f.color = black;
				}

				return f.color;
			}

			ENDCG
		}
	}
}
