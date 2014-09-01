
Shader "_MyShaders/GLSL Functions"
{
	Properties
	{
		_AmbientColor("Ambient Color", Color) = (0.2, 0.3, 0.7, 1.0)
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			
			#pragma vertex 		vertexCode
			#pragma fragment 	fragmentCode

			uniform float4		_AmbientColor;

			struct vertInput
			{
				float4 vPos		: POSITION;
				float4 uv0	 	: TEXCOORD0;
			};

			struct fragInput
			{
				float4 fPos	 	: SV_POSITION;
				float4 uv 		: TEXCOORD0;
				float4 color 	: COLOR0;
			};

			fragInput vertexCode(vertInput vertIn)
			{
				fragInput output;
				output.fPos = mul(UNITY_MATRIX_MVP, vertIn.vPos);
				output.uv = vertIn.uv0;
				return output;
			}

			float4 fragmentCode(fragInput fragIn) : COLOR0
			{

				float uvOut = fmod(fragIn.uv.xy, 1.0) > 0.5;

				fragIn.color = float4(uvOut, uvOut, 0.0, 1.0);

				return fragIn.color;
			}


			ENDCG
		}
	}
}