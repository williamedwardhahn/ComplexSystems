// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Malbers/Color3x3"
{
	Properties
	{
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		[Header(Albedo)]_Color1("Color 1", Color) = (1,0.1544118,0.1544118,1)
		_Color2("Color 2", Color) = (1,0.1544118,0.8017241,1)
		_Color3("Color 3", Color) = (0.2535501,0.1544118,1,1)
		[Space(10)]_Color4("Color 4", Color) = (0.9533468,1,0.1544118,1)
		_Color5("Color 5", Color) = (0.2669384,0.3207547,0.0226949,1)
		_Color6("Color 6", Color) = (1,0.4519259,0.1529412,1)
		[Space(10)]_Color7("Color 7", Color) = (0.9099331,0.9264706,0.6267301,1)
		_Color8("Color 8", Color) = (0.1544118,0.1602434,1,1)
		_Color9("Color 9", Color) = (0.1529412,0.9929401,1,1)
		[Header(Metallic(R) Rough(G) Emmission(B))]_MRE1("MRE 1", Color) = (0,1,0,0)
		_MRE2("MRE 2", Color) = (0,1,0,0)
		_MRE3("MRE 3", Color) = (0,1,0,0)
		[Space(10)]_MRE4("MRE 4", Color) = (0,1,0,0)
		_MRE5("MRE 5", Color) = (0,1,0,0)
		_MRE6("MRE 6", Color) = (0,1,0,0)
		[Space()]_MRE7("MRE 7", Color) = (0,1,0,0)
		_MRE8("MRE 8", Color) = (0,1,0,0)
		_MRE9("MRE 9", Color) = (0,1,0,0)
		[Header(Emmision)]_EmissionPower("Emission Power", Float) = 1
		[SingleLineTexture][Header(Gradient)]_Gradient("Gradient", 2D) = "white" {}
		_GradientIntensity("Gradient Intensity", Range( 0 , 1)) = 0.75
		_GradientColor("Gradient Color", Color) = (0,0,0,0)
		_GradientScale("Gradient Scale", Float) = 1
		_GradientOffset("Gradient Offset", Float) = 0
		_GradientPower("Gradient Power", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustom keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		struct SurfaceOutputStandardCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			half3 Translucency;
		};

		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float4 _Color3;
		uniform float4 _Color4;
		uniform float4 _Color5;
		uniform float4 _Color6;
		uniform float4 _Color7;
		uniform float4 _Color8;
		uniform float4 _Color9;
		uniform sampler2D _Gradient;
		uniform float4 _GradientColor;
		uniform float _GradientIntensity;
		uniform float _GradientScale;
		uniform float _GradientOffset;
		uniform float _GradientPower;
		uniform float _EmissionPower;
		uniform float4 _MRE1;
		uniform float4 _MRE2;
		uniform float4 _MRE3;
		uniform float4 _MRE4;
		uniform float4 _MRE5;
		uniform float4 _MRE6;
		uniform float4 _MRE7;
		uniform float4 _MRE8;
		uniform float4 _MRE9;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;

		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			#if !DIRECTIONAL
			float3 lightAtten = gi.light.color;
			#else
			float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, _TransShadow );
			#endif
			half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
			half transVdotL = pow( saturate( dot( viewDir, -lightDir ) ), _TransScattering );
			half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
			half4 c = half4( s.Albedo * translucency * _Translucency, 0 );

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + c;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			float temp_output_3_0_g337 = 1.0;
			float temp_output_7_0_g337 = 3.0;
			float temp_output_9_0_g337 = 3.0;
			float temp_output_8_0_g337 = 3.0;
			float temp_output_3_0_g334 = 2.0;
			float temp_output_7_0_g334 = 3.0;
			float temp_output_9_0_g334 = 3.0;
			float temp_output_8_0_g334 = 3.0;
			float temp_output_3_0_g338 = 3.0;
			float temp_output_7_0_g338 = 3.0;
			float temp_output_9_0_g338 = 3.0;
			float temp_output_8_0_g338 = 3.0;
			float temp_output_3_0_g331 = 1.0;
			float temp_output_7_0_g331 = 3.0;
			float temp_output_9_0_g331 = 2.0;
			float temp_output_8_0_g331 = 3.0;
			float temp_output_3_0_g336 = 2.0;
			float temp_output_7_0_g336 = 3.0;
			float temp_output_9_0_g336 = 2.0;
			float temp_output_8_0_g336 = 3.0;
			float temp_output_3_0_g335 = 3.0;
			float temp_output_7_0_g335 = 3.0;
			float temp_output_9_0_g335 = 2.0;
			float temp_output_8_0_g335 = 3.0;
			float temp_output_3_0_g332 = 1.0;
			float temp_output_7_0_g332 = 3.0;
			float temp_output_9_0_g332 = 1.0;
			float temp_output_8_0_g332 = 3.0;
			float temp_output_3_0_g330 = 2.0;
			float temp_output_7_0_g330 = 3.0;
			float temp_output_9_0_g330 = 1.0;
			float temp_output_8_0_g330 = 3.0;
			float temp_output_3_0_g333 = 3.0;
			float temp_output_7_0_g333 = 3.0;
			float temp_output_9_0_g333 = 1.0;
			float temp_output_8_0_g333 = 3.0;
			float4 temp_output_155_0 = ( ( ( _Color1 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g337 - 1.0 ) / temp_output_7_0_g337 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g337 / temp_output_7_0_g337 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g337 - 1.0 ) / temp_output_8_0_g337 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g337 / temp_output_8_0_g337 ) ) * 1.0 ) ) ) ) + ( _Color2 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g334 - 1.0 ) / temp_output_7_0_g334 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g334 / temp_output_7_0_g334 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g334 - 1.0 ) / temp_output_8_0_g334 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g334 / temp_output_8_0_g334 ) ) * 1.0 ) ) ) ) + ( _Color3 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g338 - 1.0 ) / temp_output_7_0_g338 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g338 / temp_output_7_0_g338 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g338 - 1.0 ) / temp_output_8_0_g338 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g338 / temp_output_8_0_g338 ) ) * 1.0 ) ) ) ) ) + ( ( _Color4 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g331 - 1.0 ) / temp_output_7_0_g331 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g331 / temp_output_7_0_g331 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g331 - 1.0 ) / temp_output_8_0_g331 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g331 / temp_output_8_0_g331 ) ) * 1.0 ) ) ) ) + ( _Color5 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g336 - 1.0 ) / temp_output_7_0_g336 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g336 / temp_output_7_0_g336 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g336 - 1.0 ) / temp_output_8_0_g336 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g336 / temp_output_8_0_g336 ) ) * 1.0 ) ) ) ) + ( _Color6 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g335 - 1.0 ) / temp_output_7_0_g335 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g335 / temp_output_7_0_g335 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g335 - 1.0 ) / temp_output_8_0_g335 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g335 / temp_output_8_0_g335 ) ) * 1.0 ) ) ) ) ) + ( ( _Color7 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g332 - 1.0 ) / temp_output_7_0_g332 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g332 / temp_output_7_0_g332 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g332 - 1.0 ) / temp_output_8_0_g332 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g332 / temp_output_8_0_g332 ) ) * 1.0 ) ) ) ) + ( _Color8 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g330 - 1.0 ) / temp_output_7_0_g330 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g330 / temp_output_7_0_g330 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g330 - 1.0 ) / temp_output_8_0_g330 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g330 / temp_output_8_0_g330 ) ) * 1.0 ) ) ) ) + ( _Color9 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g333 - 1.0 ) / temp_output_7_0_g333 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g333 / temp_output_7_0_g333 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g333 - 1.0 ) / temp_output_8_0_g333 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g333 / temp_output_8_0_g333 ) ) * 1.0 ) ) ) ) ) );
			float2 uv_TexCoord258 = i.uv_texcoord * float2( 3,3 );
			float4 clampResult206 = clamp( ( ( tex2D( _Gradient, uv_TexCoord258 ) + _GradientColor ) + ( 1.0 - _GradientIntensity ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 temp_cast_0 = (_GradientPower).xxxx;
			float4 clampResult255 = clamp( pow( (clampResult206*_GradientScale + _GradientOffset) , temp_cast_0 ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			o.Albedo = ( temp_output_155_0 * clampResult255 ).rgb;
			float temp_output_3_0_g327 = 1.0;
			float temp_output_7_0_g327 = 3.0;
			float temp_output_9_0_g327 = 3.0;
			float temp_output_8_0_g327 = 3.0;
			float temp_output_3_0_g325 = 2.0;
			float temp_output_7_0_g325 = 3.0;
			float temp_output_9_0_g325 = 3.0;
			float temp_output_8_0_g325 = 3.0;
			float temp_output_3_0_g329 = 3.0;
			float temp_output_7_0_g329 = 3.0;
			float temp_output_9_0_g329 = 3.0;
			float temp_output_8_0_g329 = 3.0;
			float temp_output_3_0_g326 = 1.0;
			float temp_output_7_0_g326 = 3.0;
			float temp_output_9_0_g326 = 2.0;
			float temp_output_8_0_g326 = 3.0;
			float temp_output_3_0_g320 = 2.0;
			float temp_output_7_0_g320 = 3.0;
			float temp_output_9_0_g320 = 2.0;
			float temp_output_8_0_g320 = 3.0;
			float temp_output_3_0_g328 = 3.0;
			float temp_output_7_0_g328 = 3.0;
			float temp_output_9_0_g328 = 2.0;
			float temp_output_8_0_g328 = 3.0;
			float temp_output_3_0_g323 = 1.0;
			float temp_output_7_0_g323 = 3.0;
			float temp_output_9_0_g323 = 1.0;
			float temp_output_8_0_g323 = 3.0;
			float temp_output_3_0_g321 = 2.0;
			float temp_output_7_0_g321 = 3.0;
			float temp_output_9_0_g321 = 1.0;
			float temp_output_8_0_g321 = 3.0;
			float temp_output_3_0_g322 = 3.0;
			float temp_output_7_0_g322 = 3.0;
			float temp_output_9_0_g322 = 1.0;
			float temp_output_8_0_g322 = 3.0;
			float4 temp_output_263_0 = ( ( ( _MRE1 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g327 - 1.0 ) / temp_output_7_0_g327 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g327 / temp_output_7_0_g327 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g327 - 1.0 ) / temp_output_8_0_g327 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g327 / temp_output_8_0_g327 ) ) * 1.0 ) ) ) ) + ( _MRE2 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g325 - 1.0 ) / temp_output_7_0_g325 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g325 / temp_output_7_0_g325 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g325 - 1.0 ) / temp_output_8_0_g325 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g325 / temp_output_8_0_g325 ) ) * 1.0 ) ) ) ) + ( _MRE3 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g329 - 1.0 ) / temp_output_7_0_g329 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g329 / temp_output_7_0_g329 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g329 - 1.0 ) / temp_output_8_0_g329 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g329 / temp_output_8_0_g329 ) ) * 1.0 ) ) ) ) ) + ( ( _MRE4 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g326 - 1.0 ) / temp_output_7_0_g326 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g326 / temp_output_7_0_g326 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g326 - 1.0 ) / temp_output_8_0_g326 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g326 / temp_output_8_0_g326 ) ) * 1.0 ) ) ) ) + ( _MRE5 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g320 - 1.0 ) / temp_output_7_0_g320 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g320 / temp_output_7_0_g320 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g320 - 1.0 ) / temp_output_8_0_g320 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g320 / temp_output_8_0_g320 ) ) * 1.0 ) ) ) ) + ( _MRE6 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g328 - 1.0 ) / temp_output_7_0_g328 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g328 / temp_output_7_0_g328 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g328 - 1.0 ) / temp_output_8_0_g328 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g328 / temp_output_8_0_g328 ) ) * 1.0 ) ) ) ) ) + ( ( _MRE7 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g323 - 1.0 ) / temp_output_7_0_g323 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g323 / temp_output_7_0_g323 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g323 - 1.0 ) / temp_output_8_0_g323 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g323 / temp_output_8_0_g323 ) ) * 1.0 ) ) ) ) + ( _MRE8 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g321 - 1.0 ) / temp_output_7_0_g321 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g321 / temp_output_7_0_g321 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g321 - 1.0 ) / temp_output_8_0_g321 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g321 / temp_output_8_0_g321 ) ) * 1.0 ) ) ) ) + ( _MRE9 * ( ( ( 1.0 - step( i.uv_texcoord.x , ( ( temp_output_3_0_g322 - 1.0 ) / temp_output_7_0_g322 ) ) ) * ( step( i.uv_texcoord.x , ( temp_output_3_0_g322 / temp_output_7_0_g322 ) ) * 1.0 ) ) * ( ( 1.0 - step( i.uv_texcoord.y , ( ( temp_output_9_0_g322 - 1.0 ) / temp_output_8_0_g322 ) ) ) * ( step( i.uv_texcoord.y , ( temp_output_9_0_g322 / temp_output_8_0_g322 ) ) * 1.0 ) ) ) ) ) );
			o.Emission = ( temp_output_155_0 * ( _EmissionPower * (temp_output_263_0).b ) ).rgb;
			o.Metallic = (temp_output_263_0).r;
			o.Smoothness = ( 1.0 - (temp_output_263_0).g );
			float3 temp_cast_3 = ((temp_output_263_0).a).xxx;
			o.Translucency = temp_cast_3;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
6;153;1182;875;-918.7481;220.7188;1.737791;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;258;-298.1482,-1133.502;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;200;-5.396437,-926.7093;Float;False;Property;_GradientColor;Gradient Color;29;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;202;-41.02644,-1165.228;Inherit;True;Property;_Gradient;Gradient;26;1;[SingleLineTexture];Create;True;0;0;False;1;Header(Gradient);False;-1;0f424a347039ef447a763d3d4b4782b0;0f424a347039ef447a763d3d4b4782b0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;201;-43.05084,-721.7265;Float;False;Property;_GradientIntensity;Gradient Intensity;28;0;Create;True;0;0;False;0;False;0.75;0.579;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;267;797.8815,1892.403;Float;False;Property;_MRE4;MRE 4;19;0;Create;True;0;0;False;1;Space(10);False;0,1,0,0;0,1,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;268;792.0692,1258.979;Float;False;Property;_MRE1;MRE 1;16;0;Create;True;0;0;False;1;Header(Metallic(R) Rough(G) Emmission(B));False;0,1,0,0;0.5803922,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;270;762.3789,2542.473;Float;False;Property;_MRE7;MRE 7;22;0;Create;True;0;0;False;1;Space();False;0,1,0,0;0,1,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;269;794.9661,1683.904;Float;False;Property;_MRE3;MRE 3;18;0;Create;True;0;0;False;0;False;0,1,0,0;0,1,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;266;764.9778,2103.387;Float;False;Property;_MRE5;MRE 5;20;0;Create;True;0;0;False;0;False;0,1,0,0;0,1,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;265;762.6077,2329.814;Float;False;Property;_MRE6;MRE 6;21;0;Create;True;0;0;False;0;False;0,1,0,0;0,1,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;271;760.3356,2757.597;Float;False;Property;_MRE8;MRE 8;23;0;Create;True;0;0;False;0;False;0,1,0,0;0,1,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;272;756.025,2958.429;Float;False;Property;_MRE9;MRE 9;24;0;Create;True;0;0;False;0;False;0,1,0,0;0,1,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;203;328.2687,-922.1614;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;204;301.5615,-792.5283;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;264;800.6055,1472.631;Float;False;Property;_MRE2;MRE 2;17;0;Create;True;0;0;False;0;False;0,1,0,0;0.4352941,0.3411765,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;279;1072.083,1685.052;Inherit;True;ColorShartSlot;-1;;329;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;3;False;9;FLOAT;3;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;281;1066.266,2314.42;Inherit;True;ColorShartSlot;-1;;328;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;3;False;9;FLOAT;2;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;278;1073.824,1263.506;Inherit;True;ColorShartSlot;-1;;327;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;1;False;9;FLOAT;3;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;280;1072.05,1897.946;Inherit;True;ColorShartSlot;-1;;326;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;1;False;9;FLOAT;2;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;275;1074.009,1474.637;Inherit;True;ColorShartSlot;-1;;325;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;2;False;9;FLOAT;3;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;277;1068.635,2106.349;Inherit;True;ColorShartSlot;-1;;320;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;2;False;9;FLOAT;2;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;273;1065.782,2963.45;Inherit;True;ColorShartSlot;-1;;322;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;3;False;9;FLOAT;1;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;205;508.7686,-952.5815;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;274;1063.897,2751.832;Inherit;True;ColorShartSlot;-1;;321;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;2;False;9;FLOAT;1;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;276;1067.94,2529.334;Inherit;True;ColorShartSlot;-1;;323;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;1;False;9;FLOAT;1;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;152;-377.5372,262.0459;Float;False;Property;_Color3;Color 3;9;0;Create;True;0;0;False;0;False;0.2535501,0.1544118,1,1;0.2535501,0.1544118,1,0.228;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;23;-383.1242,-232.1767;Float;False;Property;_Color1;Color 1;7;0;Create;True;0;0;False;1;Header(Albedo);False;1,0.1544118,0.1544118,1;0.7830189,0.2179156,0.2179156,0.9529412;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;208;591.5417,-443.1692;Float;False;Property;_GradientOffset;Gradient Offset;31;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;207;585.6387,-538.9446;Float;False;Property;_GradientScale;Gradient Scale;30;0;Create;True;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;261;1513.617,1678.717;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;262;1509.151,1956.105;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;260;1506.911,1450.623;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;206;793.5166,-914.7413;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;156;-369.1905,827.4952;Float;False;Property;_Color5;Color 5;11;0;Create;True;0;0;False;0;False;0.2669384,0.3207547,0.0226949,1;0.9533468,1,0.1544118,0.353;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;157;-365.6628,1086.36;Float;False;Property;_Color6;Color 6;12;0;Create;True;0;0;False;0;False;1,0.4519259,0.1529412,1;0.8483773,1,0.1544118,0.341;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;150;-391.0649,27.18103;Float;False;Property;_Color2;Color 2;8;0;Create;True;0;0;False;0;False;1,0.1544118,0.8017241,1;1,0.0518868,0.0518868,0.6784314;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;183;-364.4173,1384.535;Float;False;Property;_Color7;Color 7;13;0;Create;True;0;0;False;1;Space(10);False;0.9099331,0.9264706,0.6267301,1;0.1544118,0.6151115,1,0.316;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;159;-367.2498,538.3683;Float;False;Property;_Color4;Color 4;10;0;Create;True;0;0;False;1;Space(10);False;0.9533468,1,0.1544118,1;0.1529412,1,0.3513595,0.2039216;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;181;-372.3579,1643.892;Float;False;Property;_Color8;Color 8;14;0;Create;True;0;0;False;0;False;0.1544118,0.1602434,1,1;0.4849697,0.5008695,0.5073529,0.484;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;256;-348.6548,1931.713;Float;False;Property;_Color9;Color 9;15;0;Create;True;0;0;False;0;False;0.1529412,0.9929401,1,1;0.1529412,0.9929401,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;238;2.790063,246.9754;Inherit;True;ColorShartSlot;-1;;338;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;3;False;9;FLOAT;3;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;239;-2.797049,-241.6734;Inherit;True;ColorShartSlot;-1;;337;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;1;False;9;FLOAT;3;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;231;11.13652,815.7118;Inherit;True;ColorShartSlot;-1;;336;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;2;False;9;FLOAT;2;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;253;1474.609,-467.7142;Float;False;Property;_GradientPower;Gradient Power;32;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;263;1761.779,1591.684;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;257;58.41343,1898.4;Inherit;True;ColorShartSlot;-1;;333;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;3;False;9;FLOAT;1;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;236;-10.73773,16.68434;Inherit;True;ColorShartSlot;-1;;334;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;2;False;9;FLOAT;3;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;235;25.18534,1368.447;Inherit;True;ColorShartSlot;-1;;332;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;1;False;9;FLOAT;1;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;209;1091.96,-605.7403;Inherit;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;233;13.07732,530.6414;Inherit;True;ColorShartSlot;-1;;331;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;1;False;9;FLOAT;2;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;232;15.24454,1627.805;Inherit;True;ColorShartSlot;-1;;330;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;2;False;9;FLOAT;1;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;240;14.66442,1076.863;Inherit;True;ColorShartSlot;-1;;335;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;1,1,1,1;False;3;FLOAT;3;False;9;FLOAT;2;False;7;FLOAT;3;False;8;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;193;639.0421,747.4011;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;146;636.8021,241.9187;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;285;1723.407,545.6401;Inherit;False;Property;_EmissionPower;Emission Power;25;0;Create;True;0;0;False;1;Header(Emmision);False;1;12.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;254;1704.252,-572.7532;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;286;1814.112,662.0173;Inherit;True;False;False;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;164;643.5082,470.012;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;283;1847.278,310.2184;Inherit;True;False;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;287;2168.038,542.0409;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;155;891.6702,382.979;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;255;2050.583,-493.1835;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;259;2656.78,376.0335;Inherit;True;Property;_DetailMap;DetailMap;27;1;[NoScaleOffset];Create;True;0;0;False;1;Header(Gradient);False;-1;None;0f424a347039ef447a763d3d4b4782b0;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;2401.917,528.9325;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;1843.751,-118.5323;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;289;1302.781,286.4212;Inherit;True;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;282;1841.3,112.2717;Inherit;True;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;284;2135.428,309.1418;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;290;2110.873,882.7791;Inherit;True;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2536.031,-130.9072;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Malbers/Color3x3;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;0;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;202;1;258;0
WireConnection;203;0;202;0
WireConnection;203;1;200;0
WireConnection;204;0;201;0
WireConnection;279;38;269;0
WireConnection;281;38;265;0
WireConnection;278;38;268;0
WireConnection;280;38;267;0
WireConnection;275;38;264;0
WireConnection;277;38;266;0
WireConnection;273;38;272;0
WireConnection;205;0;203;0
WireConnection;205;1;204;0
WireConnection;274;38;271;0
WireConnection;276;38;270;0
WireConnection;261;0;280;0
WireConnection;261;1;277;0
WireConnection;261;2;281;0
WireConnection;262;0;276;0
WireConnection;262;1;274;0
WireConnection;262;2;273;0
WireConnection;260;0;278;0
WireConnection;260;1;275;0
WireConnection;260;2;279;0
WireConnection;206;0;205;0
WireConnection;238;38;152;0
WireConnection;239;38;23;0
WireConnection;231;38;156;0
WireConnection;263;0;260;0
WireConnection;263;1;261;0
WireConnection;263;2;262;0
WireConnection;257;38;256;0
WireConnection;236;38;150;0
WireConnection;235;38;183;0
WireConnection;209;0;206;0
WireConnection;209;1;207;0
WireConnection;209;2;208;0
WireConnection;233;38;159;0
WireConnection;232;38;181;0
WireConnection;240;38;157;0
WireConnection;193;0;235;0
WireConnection;193;1;232;0
WireConnection;193;2;257;0
WireConnection;146;0;239;0
WireConnection;146;1;236;0
WireConnection;146;2;238;0
WireConnection;254;0;209;0
WireConnection;254;1;253;0
WireConnection;286;0;263;0
WireConnection;164;0;233;0
WireConnection;164;1;231;0
WireConnection;164;2;240;0
WireConnection;283;0;263;0
WireConnection;287;0;285;0
WireConnection;287;1;286;0
WireConnection;155;0;146;0
WireConnection;155;1;164;0
WireConnection;155;2;193;0
WireConnection;255;0;254;0
WireConnection;288;0;155;0
WireConnection;288;1;287;0
WireConnection;210;0;155;0
WireConnection;210;1;255;0
WireConnection;289;0;155;0
WireConnection;282;0;263;0
WireConnection;284;0;283;0
WireConnection;290;0;263;0
WireConnection;0;0;210;0
WireConnection;0;2;288;0
WireConnection;0;3;282;0
WireConnection;0;4;284;0
WireConnection;0;7;290;0
ASEEND*/
//CHKSM=32BCFA3EDC5F63825209EB9695AEE6B8F8046642