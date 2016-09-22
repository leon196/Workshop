Shader "Custom/Multipass" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Main Color", Color) = (1,1,1,1)
	}
	SubShader{
		Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
		Blend One One

		Pass
		{
			Name "GrabTest"
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			half4 _Color;

			struct v2f 
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert (appdata_full v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			half4 frag( v2f i ) : COLOR
			{
				half4 image = tex2D(_MainTex, i.uv);
				return image;
			}
			ENDCG
		}

		GrabPass 
		{
			Name "GrabTest"
		}

		Pass
		{
			Name "PassTest"
			Blend Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f 
			{
				float4 pos : POSITION;

				float2 uv : TEXCOORD0;
				float4 uvgrab : TEXCOORD1;
			};

			sampler2D _GrabTexture;
			float4 _GrabTexture_ST;
			float4 _GrabTexture_TexelSize;

			v2f vert (appdata_full v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);   
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif
				o.uvgrab.xy = (float2(o.pos.x, o.pos.y * scale) + o.pos.w) * 0.5;
				o.uvgrab.zw = o.pos.zw;
				o.uv = TRANSFORM_TEX(v.texcoord, _GrabTexture);
				return o;

			}

			half4 frag( v2f i ) : COLOR
			{
				half4 color = half4(tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab)).rgb, 1);
				return color;
			}
			ENDCG
		}
	}
	Fallback "Unlit/Color"
}