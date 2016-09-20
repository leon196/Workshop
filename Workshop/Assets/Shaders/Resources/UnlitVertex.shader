Shader "Unlit/UnlitVertex"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float3 viewDir : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float3 _Target;

			float3 rotateY (float3 v, float t)
			{
			  float cost = cos(t);
			  float sint = sin(t);
			  return float3(v.x * cost + v.z * sint, v.y, -v.x * sint + v.z * cost);
			}
			
			v2f vert (appdata_full v)
			{
				v2f o;
				//v.vertex.y += sin(v.vertex.x * 10. + _Time.y * 4.) * 0.1;
				//o.viewDir = WorldSpaceViewDir(v.vertex);
				//float shade = dot(normalize(v.normal), -normalize(o.viewDir));
				// v.vertex.xyz += v.normal * sin(_Time.y) * 0.1 * shade;
				v.vertex.xyz += normalize(v.vertex - _Target);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.normal = v.normal;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				// col.rgb = i.normal * 0.5 + 0.5;
				// col.rgb *= dot(normalize(i.normal), normalize(i.viewDir)) * 0.5 + 0.5;
				return col;
			}
			ENDCG
		}
	}
}
