Shader "Hidden/GameOfLife"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			float2 _Resolution;

			float HowManyAround (sampler2D bitmap, float2 p, float2 resolution)
			{
				int count = 0;
				for (int x = -1; x <= 1; ++x) {
					for (int y = -1; y <= 1; ++y) {
						if ((x == 0 && y == 0) == false) {
							count += step(0.5, tex2D(_MainTex, p + float2(x, y) / resolution).r);
						}
					}
				}
				return count;
			}

			fixed4 frag (v2f_img i) : SV_Target
			{
				float2 uv = i.uv;

				float2 p = uv - float2(0.5, sin(_Time.y) * 0.5 + 0.5);

				float shouldCircle = smoothstep(0.0, 0.1, length(p));
				float4 circleColor = float4(1,0,0,1);

				// uv.y += 1. / _Resolution.x;
				// uv = fmod(abs(uv), 1);
				fixed4 col = tex2D(_MainTex, uv);
				col *= 0.99;
				// fixed4 col = fixed4(0,0,0,1);

				//
				col = lerp(col, circleColor, 1. - shouldCircle);

				return col;
			}
			ENDCG
		}
	}
}