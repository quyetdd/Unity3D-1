Shader "MyShaders/Vertex Techniques/301 Wave Animation"
{
	Properties
	{
		WaveFrequency("Wave Frequency", Range(0.0,5.0)) = 1.0
		WaveAmplitude("Wave Amplitude", Range(0.0,5.0)) = 1.0
	}
	SubShader
	{
		Pass
		{
			Cull Off
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			
			#pragma vertex 		vertexCode
			#pragma fragment 	fragmentCode

			uniform float WaveFrequency;
			uniform	float WaveAmplitude;

			struct vertexIn
			{
				float4 vertPos		: POSITION;
				float4 vertNorm		: NORMAL;
				float4 texcoord		: TEXCOORD0;
			};

			struct fragmentIn
			{
				float4 fragPos		: SV_POSITION;
				float4 fragNorm		: TEXCOORD3;
				float4 posWorld		: TEXCOORD4;
				float4 fragColor	: COLOR;
			};

			fragmentIn vertexCode(vertexIn vertIn)
			{
				fragmentIn fragIn;

				vertIn.vertPos.y += sin(vertIn.vertPos.x * WaveFrequency) * WaveAmplitude;

				fragIn.fragPos = mul(UNITY_MATRIX_MVP, vertIn.vertPos);
				fragIn.posWorld = mul(_Object2World, vertIn.vertPos);
				return fragIn;
			}

			float4 fragmentCode(fragmentIn fragIn) : COLOR
			{

				fragIn.fragColor = float4(0.5,0.5,0.5,1);
				fragIn.fragColor.y = fragIn.posWorld.y;
				return fragIn.fragColor;
			}

			ENDCG
		}
	}
}