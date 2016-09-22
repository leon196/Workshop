
Shader "Hidden/Filter"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;

			fixed4 frag (v2f_img i) : SV_Target
			{
				float2 uv = i.uv;
				fixed4 col = tex2D(_MainTex, uv);
				/*
				col = 1. - col;
				*/
				return col;
			}
			ENDCG
		}
	}
}

// hologram
// multi pass, glow
// buffer, motion blur, volumetric light, fluid
// v2f surf shader
// obduction particles