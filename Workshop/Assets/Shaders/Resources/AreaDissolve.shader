// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/AreaDissolve"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Dissolution ("Dissolution", 2D) = "white" {}
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
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 vertexLocal : TEXCOORD1;
			};

			sampler2D _MainTex;
			sampler2D _Dissolution;
			float4 _MainTex_ST;
			float3 _BoundsMin;
			float3 _BoundsMax;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertexLocal = v.vertex;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				float ratio = smoothstep(_BoundsMin.y, _BoundsMax.y, i.vertexLocal.y);

				float lum = Luminance(tex2D(_Dissolution, i.uv * 5.));
				col.a = smoothstep(0, lum, ratio);

				return col;
			}
			ENDCG
		}
	}
}
