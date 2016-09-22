Shader "Unlit/Glass"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{    Tags {
    	"Queue"="Transparent"
	    "IgnoreProjector"="True"
	    "RenderType"="Transparent"
	  }
		LOD 100

		GrabPass { "_GrabTexture" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 uvgrab : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
				float3 normal : NORMAL;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _GrabTexture;
			float4 _GrabTexture_ST; 
			
			v2f vert (appdata_full v)
			{
				v2f o;

				o.viewDir = WorldSpaceViewDir(v.vertex);
				o.normal = v.normal;

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);

				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				o.uvgrab.xy += sin(o.vertex.y * 4.) * 0.5;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 background = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));

				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);

				float reflection = dot(normalize(i.viewDir), normalize(i.normal));

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return lerp(col, background, reflection);
			}
			ENDCG
		}
	}
}
