// © 2015 Mario Lelas
Shader "Custom/LightBeamColor" 
{
		Properties 
		{
			_Color ("Color", Color) = (1,1,1,1)
			_FadeDist("Fade Distance", Float ) = 12
			_LerpStart("Lerp start", Float) = -0.5
			_LerpEnd("Lerp end", Float ) = 4.5
		}

		SubShader 
		{
			Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "DisableBatching"="True" }
			LOD 3000


			Pass
			{
				Name "FORWARD" 
				Tags { "LightMode" = "ForwardBase" }

				Blend SrcAlpha OneMinusSrcAlpha
				ZWrite Off    

				CGPROGRAM

				#pragma vertex vert
				#pragma fragment frag

				fixed4 _Color;
				float _FadeDist;
				float _LerpStart;
				float _LerpEnd;
				


				struct Input
				{
					float4 pos : POSITION;
					float3 normal : NORMAL;
				};

				struct v2f 
				{
					float4 pos : SV_POSITION;
					float4 posWS : TEXCOORD0;
					float3 modelPos : TEXCOORD1;
					float3 normalWS : TEXCOORD2;
				};

				v2f vert(Input In)
				{
					v2f o;
					o.pos = mul(UNITY_MATRIX_MVP, In.pos);

					float4 posWS = mul( _Object2World, In.pos);
					o.posWS = posWS;

					float3 f;
					f.x = _Object2World[0].w;
					f.y = _Object2World[1].w;
					f.z = _Object2World[2].w;
					o.modelPos = f;

					o.normalWS = mul((float3x3)_Object2World, In.normal);

					return o;
				}

				void frag(v2f In,out fixed4 OUT : SV_Target)
				{
					float fadeStart = 0;
					float fadeEnd = _FadeDist;

					float d = length(In.posWS.xyz - In.modelPos);
					float fade = 1 - saturate((d - fadeStart) / (fadeEnd - fadeStart));
					// exponential
					fade *= fade;

					float3 dir2Cam =  _WorldSpaceCameraPos.xyz - In.posWS.xyz;
					dir2Cam = normalize(dir2Cam);

					float3 normal = In.normalWS;

					float dotVal = max(0.0, dot(normalize(normal), dir2Cam));
					fade *= max(0.0f,lerp(_LerpStart, _LerpEnd, dotVal));

					OUT = fixed4(_Color.rgb, _Color.a * fade);
				}

				ENDCG
			}
	}
	Fallback "Transparent/VertexLit"
}
