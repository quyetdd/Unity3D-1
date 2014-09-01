
Shader "_MyShaders/GLSL Functions"
{
	Properties
	{
		_AmbientColor("Ambient Color", Color) 	= (0.2, 0.3, 0.7, 1.0)
		_Parm1 ("Parm1", Range(0.0, 0.5)) 		= 0.0
		_Parm2 ("Parm2", Range(0.0, 0.5)) 		= 0.0
		_Parm3 ("Parm3", Range(1.0, 10.0)) 		= 2.0
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			
			#pragma vertex 		vertexCode
			#pragma fragment 	fragmentCode

			uniform float4		_AmbientColor;
			uniform float 		_Parm1;
			uniform float 		_Parm2;
			uniform float 		_Parm3;

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

				float uvOut = length(fmod(fragIn.uv.xy * _Parm3, 1.0) - _Parm1) > _Parm2;

				fragIn.color = float4(uvOut, uvOut, 1.0, 1.0);

				return fragIn.color;
			}


			ENDCG
		}
	}
}