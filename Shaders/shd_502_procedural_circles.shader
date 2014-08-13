//---------------------------------------------------------
// Procedural Checker
// Unity3D Shader
// Vishang Shah
//---------------------------------------------------------
Shader "MyShaders/Procedural - Circles"
{
	Properties
	{
		_CirclesGrid("Circles Grid", Float)							= 8.0
		_CircleSize ("Circle Size", Float) 							= 0.8
		_CirclePositioning ("Circle Positioning", Float) 			= 1.0
		_TileSpacing ("Tile Spacing", Float) 						= 2.0
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			
			#pragma vertex 		vertexCode
			#pragma fragment	fragmentCode

			uniform float 	_CirclesGrid;
			uniform float 	_CircleSize;
			uniform float 	_TileSpacing;
			uniform float 	_CirclePositioning;

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

				float2 xy = float2(0.0,0.0);

				xy = length(fmod(f.uv.xy * _CirclesGrid, _TileSpacing) - _CirclePositioning) > _CircleSize;

				//xy = xy - float2(0.5,0.5);
				
				f.color = float4(xy,0.8,1.0);

				return f.color;
			}

			ENDCG
		}
	}
}
