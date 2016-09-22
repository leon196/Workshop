Shader "Filter/VertexTexturePass"
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
			#include "Utils.cginc"
			
			sampler2D _MainTex;
			sampler2D _VertexTexture;
			float3 _TransformPosition;
			float4x4 _RendererMatrix;
			float4x4 _InverseMatrix;

			fixed4 frag (v2f_img i) : SV_Target
			{
				float2 uv = i.uv;

				// target
				fixed4 morph = tex2D(_VertexTexture, uv);

				// current position
				fixed4 col = tex2D(_MainTex, uv);

				float3 random = float3(noiseIQ(col + float3(_Time.y, 0, 0)), noiseIQ(col * 4.), noiseIQ(col * 8.));

				random = 0.01 * normalize(random);

				col.xyz = lerp(col.xyz + random, morph.xyz, sin(_Time.y) * 0.5 + 0.5);

				// col.rgb = mul(_RendererMatrix, col) + _TransformPosition;

				// col.rgb = mul(_InverseMatrix, col.rgb - _TransformPosition);

				return col;
			}
			ENDCG
		}
	}
}
