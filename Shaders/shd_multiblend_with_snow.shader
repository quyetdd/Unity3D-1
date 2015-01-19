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



			ENDCG
			
		}
	}
	FallBack "Diffuse"
}