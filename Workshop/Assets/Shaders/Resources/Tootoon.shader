		Shader "Custom/Tootoon" {
			Properties {
				_MainTex ("Texture", 2D) = "white" {}
				_ShadeCount ("Shade Count", Float) = 8
			}
			SubShader {
				Tags { "RenderType" = "Opaque" }
				CGPROGRAM
				#pragma surface surf SimpleLambert

				float _ShadeCount;

				half4 LightingSimpleLambert (SurfaceOutput s, half3 lightDir, half atten) {
					half NdotL = dot (s.Normal, lightDir);
					half4 c;
					float shade = (NdotL);

					// TOON effect
					shade = ceil(shade * _ShadeCount) / _ShadeCount;
					
					c.rgb = s.Albedo * _LightColor0.rgb * shade;
					c.a = s.Alpha;
					return c;
				}

				struct Input {
					float2 uv_MainTex;
				};
				
				sampler2D _MainTex;
				
				void surf (Input IN, inout SurfaceOutput o) {
					o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
				}
				ENDCG
			}
			Fallback "Diffuse"
		}