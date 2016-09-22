Shader "Unlit/UnlitVertex"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Dissolution ("Dissolution", 2D) = "white" {}
		_Tornado ("Tornado", Range(0, 10)) = 0
		_Didi ("Didi", Range(0, 1)) = 0
	}
	SubShader
	{
    Tags {
    	"Queue"="Transparent"
	    "IgnoreProjector"="True"
	    "RenderType"="Transparent"
	  }
		LOD 100

		Pass
		{
      Blend SrcAlpha OneMinusSrcAlpha
      Cull Off

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
				float3 vertexWorld : TEXCOORD2;
				float4 screenUV : TEXCOORD3;
			};

			sampler2D _MainTex;
			sampler2D _Dissolution;
			float4 _MainTex_ST;
			float3 _Target;
			float _Tornado;
			float _Didi;

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
				o.viewDir = WorldSpaceViewDir(v.vertex);
				//float shade = dot(normalize(v.normal), -normalize(o.viewDir));
				// v.vertex.xyz += v.normal * sin(_Time.y) * 0.1 * shade;
				// v.vertex.xyz += normalize(v.vertex - _Target);

				// _Object2World 5.3
				// unity_ObjectToWorld 5.4
				float4 vertex = mul(unity_ObjectToWorld, v.vertex);
				float angle = vertex.y * _Tornado;
				
				v.vertex.xyz = rotateY(v.vertex.xyz, angle);
				v.normal.xyz = rotateY(v.normal.xyz, angle);
				o.vertexWorld = mul(unity_ObjectToWorld, v.vertex);

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.screenUV = ComputeScreenPos(o.vertex);

				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.normal = v.normal;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;
				uv = ceil(uv * 128.) / 128.;
				fixed4 col = tex2D(_MainTex, uv);
				// col.rgb = i.normal * 0.5 + 0.5;
				col.rgb *= dot(normalize(i.normal), normalize(i.viewDir)) * 0.5 + 0.5;
				float2 screenUV = i.screenUV.xy / i.screenUV.w;
				float lum = Luminance(tex2D(_Dissolution, i.vertexWorld.xy));
				float di = clamp(i.vertexWorld.y * 0.8, 0, 1);
				col.rgb = lerp(col.rgb, float3(1,0,0), step(_Didi - 0.1, lum));

				// lum = fmod(lum + i.vertexWorld.y * 10., 1.0);
				col.a *= lerp(1, 0, step(_Didi, lum));

				return col;
			}
			ENDCG
		}
	}
}
