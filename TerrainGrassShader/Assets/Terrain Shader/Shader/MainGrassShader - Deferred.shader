Shader "Custom/TerrainShader/Shader13_Deferred" {
	Properties {
		// set by terrain engine
		[HideInInspector] _Control ("Control (RGBA)", 2D) = "red" {}
		[HideInInspector] _Splat3 ("Layer 3 (A)", 2D) = "white" {}
		[HideInInspector] _Splat2 ("Layer 2 (B)", 2D) = "white" {}
		[HideInInspector] _Splat1 ("Layer 1 (G)", 2D) = "white" {}
		[HideInInspector] _Splat0 ("Layer 0 (R)", 2D) = "white" {}
		[HideInInspector] _Normal3 ("Normal 3 (A)", 2D) = "bump" {}
		[HideInInspector] _Normal2 ("Normal 2 (B)", 2D) = "bump" {}
		[HideInInspector] _Normal1 ("Normal 1 (G)", 2D) = "bump" {}
		[HideInInspector] _Normal0 ("Normal 0 (R)", 2D) = "bump" {}
		[HideInInspector] [Gamma] _Metallic0 ("Metallic 0", Range(0.0, 1.0)) = 0.0	
		[HideInInspector] [Gamma] _Metallic1 ("Metallic 1", Range(0.0, 1.0)) = 0.0	
		[HideInInspector] [Gamma] _Metallic2 ("Metallic 2", Range(0.0, 1.0)) = 0.0	
		[HideInInspector] [Gamma] _Metallic3 ("Metallic 3", Range(0.0, 1.0)) = 0.0
		[HideInInspector] _Smoothness0 ("Smoothness 0", Range(0.0, 1.0)) = 1.0	
		[HideInInspector] _Smoothness1 ("Smoothness 1", Range(0.0, 1.0)) = 1.0	
		[HideInInspector] _Smoothness2 ("Smoothness 2", Range(0.0, 1.0)) = 1.0	
		[HideInInspector] _Smoothness3 ("Smoothness 3", Range(0.0, 1.0)) = 1.0

		// used in fallback on old cards & base map
		[HideInInspector] _MainTex ("BaseMap (RGB)", 2D) = "white" {}
		[HideInInspector] _Color2 ("Main Color", Color) = (1,1,1,1)

		// ---------------

		_GrassTex1 ("Grass Texture 1", 2D) = "white" {}
		_Height1 ("Grass Height", Range(0, 10)) = 2.6
		_Width1 ("Grass Width", Range(0,10)) = 1.95
		_Healthy1 ("Healthy Color", Color) = (1,1,1,1)
		_Dry1 ("Dry Color", Color) = (1,1,1,1)
		[Toggle] _tex1Enabled("Enabled", Float) = 1

		_GrassTex2 ("Grass Texture 1", 2D) = "white" {}
		_Height2 ("Grass Height", Range(0, 10)) = 2.6
		_Width2 ("Grass Width", Range(0,10)) = 1.95
		_Healthy2 ("Healthy Color", Color) = (1,1,1,1)
		_Dry2 ("Dry Color", Color) = (1,1,1,1)
		[Toggle] _tex2Enabled("Enabled", Float) = 0

		_GrassTex3 ("Grass Texture 1", 2D) = "white" {}
		_Height3 ("Grass Height", Range(0, 10)) = 2.6
		_Width3 ("Grass Width", Range(0,10)) = 1.95
		_Healthy3 ("Healthy Color", Color) = (1,1,1,1)
		_Dry3 ("Dry Color", Color) = (1,1,1,1)
		[Toggle] _tex3Enabled("Enabled", Float) = 0

		_GrassTex4 ("Grass Texture 1", 2D) = "white" {}
		_Height4 ("Grass Height", Range(0, 10)) = 2.6
		_Width4 ("Grass Width", Range(0,10)) = 1.95
		_Healthy4 ("Healthy Color", Color) = (1,1,1,1)
		_Dry4 ("Dry Color", Color) = (1,1,1,1)
		[Toggle] _tex4Enabled("Enabled", Float) = 0

		// ---------------

		_Noise ("Noise Texture", 2D) = "white" {}
		_NoiseInfluence ("Noise Influence", Range(0.001, 1.0)) = 0.5
		_Glossiness ("Smoothness", Range(0,1)) = 0.0
		[HideInInspector] _Metallic ("Metallic", Range(0,1)) = 0.0
		_UpDown ("UpDown", Range(0,1)) = 0.0

		_Density("Grass Density", Range(0, 20)) = 1
		[HideInInspector]_DensityWeight("Density Weight", Range(0.5,20)) = 2.0

		[HideInInspector][Toggle] _faceCamera("Billboard towards Camera", Float) = 1
		[Toggle] _moreBB("3 Sprites", Float) = 1
		[Toggle] _lessBB("1 Sprite", Float) = 0
		[Toggle] _windEnabled("Enable wind", Float) = 1
		_WindDirectionDegrees("Wind Direction", Range(0,360)) = 0
		_MaxCameraDistance("Max Distance", Range(10, 1000)) = 175.0
		_TriBillboardDistance("LOD2 Distance", Range(0, 1000)) = 38.0
		_transitionDistance("Transition Size", Range(0, 100)) = 76.0

		[HideInInspector]_Ambient("Ambient", Range(0, 1)) = 0.899
		[HideInInspector]_Diffuse("Diffuse", Range(0, 1)) = 0.665
		[HideInInspector]_Specular("Highlight", Range(0, 1)) = 0.33
		[HideInInspector]_SpecularSize("SpecularSize", Range(1, 150)) = 22.0

		[Toggle(SHADOW_ACTIVE)] _ShadowActive ("Cast Shadows", Float) = 1
		_AlphaCutoff ("Shadow Thickness", Range(0,1)) = 0.01
		_ShadowBillboardDistance("Shadow LOD Distance", Range(0, 100)) = 22.0
		[Toggle] _hdrOn("HDR On", Float) = 1
		[HideInInspector]_ShadowIntensity("ShadowIntensity", Range(0, 1)) = 0.366
		
		[HideInInspector]_Debug("Debug 0-2", Range(0, 2)) = 1.0
		[HideInInspector]_Debug2("Debug 0-1", Range(0, 1)) = 1.0
		[HideInInspector]_Debug100("Debug 0-100", Range(1, 100)) = 1.0
		[HideInInspector][Toggle] _DebugToggle("DebugToggle", Float) = 1

		[HideInInspector]_Tess ("Tessellation", Range(0.0,0.9)) = 1

		[HideInInspector] _colPos("Collider Position", Vector) = (0, 0, 0, 0)
		[HideInInspector] _colRad("Collider Radius", Float) = 1
	
			[HideInInspector] _colliderCount("Collider Count", Int) = 0

			[HideInInspector] _colPos0("Collider Position", Vector) = (0, 0, 0, 0)
			[HideInInspector] _colRad0("Collider Radius", Float) = 1
			[HideInInspector] _colPos1("Collider Position", Vector) = (0, 0, 0, 0)
			[HideInInspector] _colRad1("Collider Radius", Float) = 1
			[HideInInspector] _colPos2("Collider Position", Vector) = (0, 0, 0, 0)
			[HideInInspector] _colRad2("Collider Radius", Float) = 1
			[HideInInspector] _colPos3("Collider Position", Vector) = (0, 0, 0, 0)
			[HideInInspector] _colRad3("Collider Radius", Float) = 1
			[HideInInspector] _colPos4("Collider Position", Vector) = (0, 0, 0, 0)
			[HideInInspector] _colRad4("Collider Radius", Float) = 1
			[HideInInspector] _colPos5("Collider Position", Vector) = (0, 0, 0, 0)
			[HideInInspector] _colRad5("Collider Radius", Float) = 1
			[HideInInspector] _colPos6("Collider Position", Vector) = (0, 0, 0, 0)
			[HideInInspector] _colRad6("Collider Radius", Float) = 1
			[HideInInspector] _colPos7("Collider Position", Vector) = (0, 0, 0, 0)
			[HideInInspector] _colRad7("Collider Radius", Float) = 1
			[HideInInspector] _colPos8("Collider Position", Vector) = (0, 0, 0, 0)
			[HideInInspector] _colRad8("Collider Radius", Float) = 1
			[HideInInspector] _colPos9("Collider Position", Vector) = (0, 0, 0, 0)
			[HideInInspector] _colRad9("Collider Radius", Float) = 1



//		[HideInInspector] _MainTex ("BaseMap (RGB)", 2D) = "white" {}
		// _SpecColor ("Main Color", Color) = (1,1,1,1)
	}

	SubShader {
		Tags {
			"Queue" = "Geometry-100"
			"RenderType" = "Opaque"
		}

		CGPROGRAM
		#pragma debug
		#pragma surface surf Standard vertex:SplatmapVert finalcolor:SplatmapFinalColor finalgbuffer:SplatmapFinalGBuffer fullforwardshadows
		#pragma multi_compile_fog
		#pragma target 3.0
		// needs more than 8 texcoords
		#pragma exclude_renderers gles
		#include "UnityPBSLighting.cginc"

		#pragma multi_compile __ _TERRAIN_NORMAL_MAP

		#define TERRAIN_STANDARD_SHADER
		#define TERRAIN_SURFACE_OUTPUT SurfaceOutputStandard
		#include "TerrainSplatmapCommon.cginc"
			
		half _Metallic0;
		half _Metallic1;
		half _Metallic2;
		half _Metallic3;
		
		half _Smoothness0;
		half _Smoothness1;
		half _Smoothness2;
		half _Smoothness3;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			half4 splat_control;
			half weight;			
			
			fixed4 mixedDiffuse;
			half4 defaultSmoothness = half4(_Smoothness0, _Smoothness1, _Smoothness2, _Smoothness3);
			SplatmapMix(IN, defaultSmoothness, splat_control, weight, mixedDiffuse, o.Normal);
			o.Albedo = mixedDiffuse.rgb;
			o.Alpha = weight;
			o.Smoothness = mixedDiffuse.a;
			o.Metallic = dot(splat_control, half4(_Metallic0, _Metallic1, _Metallic2, _Metallic3));
		}
		ENDCG

		// Deferred
		Pass
		{
			Name "DeferredGrass"
			Tags{"LightMode" = "Deferred"}
			LOD 200

			ZWrite on
			Cull off
			ZTest Less

			AlphaToMask On
			CGPROGRAM
				#pragma target 5.0
				#pragma vertex vertex_shader

				#pragma hull hull_shader
				#pragma domain domain_shader

				#pragma fragment fragDeferred
				#pragma geometry geometry_shader

				#include "UnityShaderVariables.cginc"
				#include "UnityStandardConfig.cginc"
				#include "UnityLightingCommon.cginc"
				#include "UnityGlobalIllumination.cginc"

				#include "UnityPBSLighting.cginc"


				#include "UnityCG.cginc" 

				#include "Tessellation.cginc"


				// for shadows
				#pragma multi_compile_fog
				#pragma multi_compile_fwdbase //nolightmap nodirlightmap nodynlightmap novertexlight
				#include "AutoLight.cginc"
				#include "UnityStandardCore.cginc"
				// #include 

				// 
				#define TERRAIN_STANDARD_SHADER
				#define TERRAIN_SURFACE_OUTPUT SurfaceOutputStandard
				#include "TerrainSplatmapCommon.cginc"

				// Grass Helpers			
				// #define GrassHelper_FirstPass
				#include "GrassHelpers.cginc"
				#include "VertexAndTessShader.cginc"
				#include "GeometryShader.cginc"

				void fragDeferred (GS_OUTPUT i,
					out half4 outDiffuse : SV_Target0,			// diffuse color, occlusion 
					out half4 outSpecSmoothness : SV_Target1,	// spec color, smoothness
					out half4 outNormal : SV_Target2,			// normal, unused 
					out half4 outEmission : SV_Target3			// emission, unused
				)
				{
					#if (SHADER_TARGET < 30)
						outDiffuse = 1;
						outSpecSmoothness = 1;
						outNormal = 0;
						outEmission = 0;
						return;
					#endif

					float4 tex = float4(0,0,0,0);
					switch(i.type){
						case 1:
							tex = tex2D(_GrassTex1, i.tex);
							break;
						case 2:
							tex = tex2D(_GrassTex2, i.tex);
							break;
						case 3:
							tex = tex2D(_GrassTex3, i.tex);
							break;
						case 4:
							tex = tex2D(_GrassTex4, i.tex);
							break;
					}

					if(i.id > 1)
						clip(tex.a - i.cutout);

					half3 diffColor = tex.rgb * i.color;

					half3 emission = half3(0,0,0);
					if(!_hdrOn){
						emission = exp2(-diffColor.rgb) * 1.5;
					}

					outDiffuse = half4(diffColor, tex.a);
					outSpecSmoothness = half4(diffColor * _Specular , _Glossiness);
					outNormal = half4(i.normal * 0.5 + 0.5, 1);
					outEmission = half4(emission, 1);
				}
	
			ENDCG
		}

		Pass
		{
			Tags{"LightMode" = "ShadowCaster"}
			LOD 100
			// Dont write to the depth buffer
			ZWrite on
			Cull off
			ZTest LEqual
			
			// Alpha Blending
			
			// Blend SrcAlpha OneMinusSrcAlpha
			AlphaToMask On
			CGPROGRAM

				#pragma target 5.0
				#pragma shader_feature SHADOW_ACTIVE

				#pragma vertex vertex_shader

				#pragma hull hull_shader
				#pragma domain domain_shader

				#pragma fragment fragment_shader
				#pragma geometry geometry_shader

				#include "UnityPBSLighting.cginc"
				#include "Tessellation.cginc"


				// for shadows
				#pragma multi_compile_shadowcaster
				// #define SHADOWS_CUBE

				#include "UnityCG.cginc" 
				#include "HLSLSupport.cginc"

				#define TERRAIN_STANDARD_SHADER
				#define TERRAIN_SURFACE_OUTPUT SurfaceOutputStandard
				#include "TerrainSplatmapCommon.cginc"

				#define GrassHelper_ShadowPass
				// Grass Helpers
				#include "GrassHelpers.cginc"
				#include "VertexAndTessShader.cginc"
				#include "GeometryShader.cginc"
				
				// Fragment Shader -----------------------------------------------
				float4 fragment_shader(GS_OUTPUT IN) : SV_Target
				{
					// If no shadowcast from BB to BB
					// if (unity_LightShadowBias.z != 0.0) discard;
					
					float4 tex = float4(0,0,0,0);
					switch(IN.type){
						case 1:
							tex = tex2D(_GrassTex1, IN.tex);
							break;
						case 2:
							tex = tex2D(_GrassTex2, IN.tex);
							break;
						case 3:
							tex = tex2D(_GrassTex3, IN.tex);
							break;
						case 4:
							tex = tex2D(_GrassTex4, IN.tex);
							break;
					}

					clip(tex.a - (1.0 - _AlphaCutoff));

					return float4(0.5, 0.5f, 0.5, tex.a);
				}
	
			ENDCG
		}

	}

	CustomEditor "GrassShaderEditor"

	Dependency "AddPassShader" = "Hidden/TerrainEngine/Splatmap/Standard-AddPass"
	Dependency "BaseMapShader" = "Hidden/TerrainEngine/Splatmap/Standard-Base"

	// Fallback "Diffuse"



}
