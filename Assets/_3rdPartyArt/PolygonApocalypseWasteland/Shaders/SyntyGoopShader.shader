// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Synty/GoopShader"
{
	Properties
	{
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.6
		_TilingX("TilingX", Float) = 1
		_TilingY("TilingY", Float) = 1
		_ScrollSpeed("ScrollSpeed", Range( 0 , 1)) = 1
		_Albedo("Albedo", 2D) = "white" {}
		_BaseColour("BaseColour", Color) = (0.2627451,0.6039216,0.05490196,0)
		_AlbedoBlend("AlbedoBlend", Range( 0 , 1)) = 1
		_Emissive("Emissive", 2D) = "black" {}
		_EmitColour("EmitColour", Color) = (0.2627451,0.6039216,0.05490196,0)
		_EmitBlend("EmitBlend", Range( 0 , 1)) = 0
		_EmitAmount("EmitAmount", Range( 0 , 2)) = 0
		_Specular("Specular", 2D) = "black" {}
		_SpecAmount("SpecAmount", Range( 0 , 1)) = 0
		_Normal("Normal", 2D) = "bump" {}
		_NormalAmount("NormalAmount", Range( 0 , 2)) = 1
		_NormalTilingX("NormalTilingX", Float) = 1
		_NormalTilingY("NormalTilingY", Float) = 1
		_ScrollSpeed_Normal("ScrollSpeed_Normal", Range( 0 , 1)) = 1
		[Header(Foam)]_FoamTexture("FoamTexture", 2D) = "white" {}
		_FoamScale("FoamScale", Float) = 1
		_FoamTint("FoamTint", Color) = (1,1,1,0)
		_FoamSpread("FoamSpread", Range( 0 , 10)) = 0
		_FoamFalloff("FoamFalloff", Range( 0 , 10)) = 0
		_FoamSpeed("FoamSpeed", Float) = 0.1
		_FoamWobble("FoamWobble", Float) = 1
		_FoamMoveDistance("FoamMoveDistance", Float) = 1
		_Shoreline("Shoreline", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float4 screenPos;
		};

		uniform sampler2D _Normal;
		uniform float _NormalTilingX;
		uniform float _NormalTilingY;
		uniform float _ScrollSpeed_Normal;
		uniform float _NormalAmount;
		uniform float4 _BaseColour;
		uniform sampler2D _Albedo;
		uniform float _TilingX;
		uniform float _TilingY;
		uniform float _ScrollSpeed;
		uniform float _AlbedoBlend;
		uniform float4 _FoamTint;
		uniform sampler2D _FoamTexture;
		uniform float _FoamScale;
		uniform float _FoamSpeed;
		uniform float _FoamWobble;
		uniform float _FoamMoveDistance;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _FoamSpread;
		uniform float _Shoreline;
		uniform float _FoamFalloff;
		uniform float4 _EmitColour;
		uniform sampler2D _Emissive;
		uniform float _EmitBlend;
		uniform float _EmitAmount;
		uniform sampler2D _Specular;
		uniform float _SpecAmount;
		uniform float _Smoothness;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 appendResult42 = (float2(_NormalTilingX , _NormalTilingY));
			float2 temp_cast_0 = (_ScrollSpeed_Normal).xx;
			float2 panner37 = ( 1.0 * _Time.y * temp_cast_0 + float2( 0,0 ));
			float2 appendResult41 = (float2(0.0 , panner37.y));
			float2 uv_TexCoord43 = i.uv_texcoord * appendResult42 + appendResult41;
			o.Normal = UnpackScaleNormal( tex2D( _Normal, uv_TexCoord43 ), _NormalAmount );
			float3 appendResult17 = (float3(_BaseColour.r , _BaseColour.g , _BaseColour.b));
			float2 appendResult26 = (float2(_TilingX , _TilingY));
			float2 temp_cast_1 = (_ScrollSpeed).xx;
			float2 panner1 = ( 1.0 * _Time.y * temp_cast_1 + float2( 0,0 ));
			float2 appendResult25 = (float2(0.0 , panner1.y));
			float2 uv_TexCoord14 = i.uv_texcoord * appendResult26 + appendResult25;
			float4 tex2DNode4 = tex2D( _Albedo, uv_TexCoord14 );
			float3 appendResult7 = (float3(tex2DNode4.r , tex2DNode4.g , tex2DNode4.b));
			float3 lerpResult18 = lerp( appendResult17 , appendResult7 , ( tex2DNode4.a * _AlbedoBlend ));
			float3 Colour_In85 = lerpResult18;
			float3 ase_worldPos = i.worldPos;
			float2 break61 = ( (ase_worldPos).xz * _FoamScale );
			float mulTime49 = _Time.y * ( _FoamSpeed * _FoamWobble );
			float mulTime51 = _Time.y * _FoamSpeed;
			float2 appendResult69 = (float2(( break61.x + ( 0.0 + ( sin( mulTime49 ) * _FoamMoveDistance ) ) ) , ( break61.y + ( sin( mulTime51 ) * _FoamMoveDistance ) )));
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth62 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth62 = abs( ( screenDepth62 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _FoamSpread ) );
			float temp_output_66_0 = ( 1.0 - distanceDepth62 );
			float3 lerpResult80 = lerp( Colour_In85 , (_FoamTint).rgb , saturate( ( (tex2D( _FoamTexture, appendResult69 )).rgb + saturate( ( pow( temp_output_66_0 , _Shoreline ) * 5.0 ) ) ) ));
			float3 lerpResult82 = lerp( Colour_In85 , lerpResult80 , saturate( ( temp_output_66_0 * _FoamFalloff ) ));
			float3 Albedo89 = lerpResult82;
			o.Albedo = Albedo89;
			float3 appendResult93 = (float3(_EmitColour.r , _EmitColour.g , _EmitColour.b));
			float4 tex2DNode6 = tex2D( _Emissive, uv_TexCoord14 );
			float3 appendResult8 = (float3(tex2DNode6.r , tex2DNode6.g , tex2DNode6.b));
			float3 lerpResult95 = lerp( appendResult93 , appendResult8 , ( tex2DNode6.a * _EmitBlend ));
			o.Emission = ( lerpResult95 * _EmitAmount );
			float4 tex2DNode12 = tex2D( _Specular, uv_TexCoord14 );
			float3 appendResult13 = (float3(tex2DNode12.r , tex2DNode12.g , tex2DNode12.b));
			o.Specular = ( appendResult13 * _SpecAmount );
			o.Smoothness = _Smoothness;
			o.Alpha = _Opacity;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float4 tSpace0 : TEXCOORD4;
				float4 tSpace1 : TEXCOORD5;
				float4 tSpace2 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18909
-3424;7;2956;1351;2617.861;441.0822;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;88;-3618.782,780.5266;Inherit;False;2391;1040.078;Foam;39;46;47;48;49;50;51;52;53;54;55;56;57;58;59;60;61;62;63;64;65;66;67;68;69;70;71;72;73;74;75;76;77;78;79;80;81;82;87;86;;0,0.8072343,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-3568.782,979.2766;Inherit;False;Property;_FoamWobble;FoamWobble;26;0;Create;True;0;0;0;False;0;False;1;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-3387.782,1355.276;Inherit;False;Property;_FoamSpeed;FoamSpeed;25;0;Create;True;0;0;0;False;0;False;0.1;1.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-3369.782,893.2766;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;50;-3560.683,1091.145;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;49;-3191.033,843.5266;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2789.4,-42.62;Inherit;False;Property;_ScrollSpeed;ScrollSpeed;5;0;Create;True;0;0;0;False;0;False;1;0.041;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;53;-3295.427,1095.45;Inherit;False;FLOAT2;0;2;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-3265.783,1186.277;Inherit;False;Property;_FoamScale;FoamScale;21;0;Create;True;0;0;0;False;0;False;1;0.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-3060.783,1425.276;Inherit;False;Property;_FoamMoveDistance;FoamMoveDistance;27;0;Create;True;0;0;0;False;0;False;1;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;52;-2994.033,845.5266;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;1;-2452.98,-66.62;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;51;-3130.783,1329.276;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;297,74.5;Inherit;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;27;-2269.82,-212.2931;Inherit;False;Property;_TilingX;TilingX;3;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-2268.82,-135.2931;Inherit;False;Property;_TilingY;TilingY;4;0;Create;True;0;0;0;False;0;False;1;1.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;23;-2273.82,-46.29309;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-3051.783,1084.276;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinOpNode;58;-2960.783,1286.277;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-2627.783,1641.277;Inherit;False;Property;_FoamSpread;FoamSpread;23;0;Create;True;0;0;0;False;0;False;0;0.37;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-2855.033,830.5266;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;61;-2867.783,1063.276;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;25;-2141.82,-46.29309;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;-2100.82,-190.2931;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;3;592,101.5;Inherit;False;AlbedoSS;-1;True;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-2821.783,1271.277;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-2708.033,851.5266;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;62;-2322.783,1594.277;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;-2696.783,1193.277;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;-2671.783,1056.276;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;5;-1675.4,39.38;Inherit;False;3;AlbedoSS;1;0;OBJECT;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.OneMinusNode;66;-2038.783,1541.277;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-2233.05,1419.271;Inherit;False;Property;_Shoreline;Shoreline;28;0;Create;True;0;0;0;False;0;False;1;11.43;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-1955.4,-77.62;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;16;-1434.4,-323.62;Inherit;False;Property;_BaseColour;BaseColour;7;0;Create;True;0;0;0;False;0;False;0.2627451,0.6039216,0.05490196,0;0.3363008,0.5849056,0.1848521,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;87;-2532.383,1208.89;Inherit;False;3;AlbedoSS;1;0;OBJECT;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.PowerNode;68;-1926.05,1400.605;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-1482.4,-97.62002;Inherit;True;Property;_Albedo;Albedo;6;0;Create;True;0;0;0;False;0;False;-1;None;be2410df551d96a47862a8fcb833563a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;69;-2516.783,1069.276;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1260.4,73.38;Inherit;False;Property;_AlbedoBlend;AlbedoBlend;8;0;Create;True;0;0;0;False;0;False;1;0.034;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;7;-1178.4,-68.62;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;-1149.4,-271.62;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-989.8201,-18.29309;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;71;-2357.783,1016.277;Inherit;True;Property;_FoamTexture;FoamTexture;20;1;[Header];Create;True;1;Foam;0;0;False;0;False;-1;b164af25093b46140af8c4fb65855882;b164af25093b46140af8c4fb65855882;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1762.05,1407.605;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;72;-2055.783,1064.276;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;18;-881.4,-191.62;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;73;-1640.05,1406.271;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;76;-2291.049,1223.605;Inherit;False;Property;_FoamTint;FoamTint;22;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.7019608,0.8196079,0.4745098,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-1850.05,1086.605;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-2187.05,1704.605;Inherit;False;Property;_FoamFalloff;FoamFalloff;24;0;Create;True;0;0;0;False;0;False;0;2.25;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;-669.1592,-188.31;Inherit;False;Colour_In;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1480.767,-860.5652;Inherit;False;Property;_ScrollSpeed_Normal;ScrollSpeed_Normal;19;0;Create;True;0;0;0;False;0;False;1;0.023;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;37;-1144.347,-884.5653;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;77;-2044.05,1227.605;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-1869.05,1587.605;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;79;-1727.05,1136.605;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-1779.66,862.124;Inherit;False;85;Colour_In;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;6;-1486.4,124.38;Inherit;True;Property;_Emissive;Emissive;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;97;-1163.861,298.9178;Inherit;False;Property;_EmitBlend;EmitBlend;11;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;81;-1686.05,1630.605;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;40;-965.1866,-864.2383;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;39;-960.1866,-953.2384;Inherit;False;Property;_NormalTilingY;NormalTilingY;18;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;80;-1578.05,1121.605;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;94;-940.3608,95.91779;Inherit;False;Property;_EmitColour;EmitColour;10;0;Create;True;0;0;0;False;0;False;0.2627451,0.6039216,0.05490196,0;0.3363008,0.5849056,0.1848521,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-961.1866,-1030.238;Inherit;False;Property;_NormalTilingX;NormalTilingX;17;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;93;-722.3608,123.9178;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;12;-1486.9,349.88;Inherit;True;Property;_Specular;Specular;13;0;Create;True;0;0;0;False;0;False;-1;None;76a8a326cd1816a43a3687dcb5a56530;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;8;-1179.4,153.38;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;82;-1409.783,1135.277;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;41;-833.1865,-864.2383;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;42;-792.1863,-1008.238;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-872.8608,274.9178;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-1179.9,378.88;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-646.7664,-895.5652;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;95;-576.8608,130.9178;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-657.8199,267.7069;Inherit;False;Property;_EmitAmount;EmitAmount;12;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-692.1335,-697.7139;Inherit;False;Property;_NormalAmount;NormalAmount;16;0;Create;True;0;0;0;False;0;False;1;0.61;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1191.82,508.7069;Inherit;False;Property;_SpecAmount;SpecAmount;14;0;Create;True;0;0;0;False;0;False;0;0.235;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;-1185.314,1145.467;Inherit;False;Albedo;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-692.4,505.38;Inherit;False;Property;_Smoothness;Smoothness;2;0;Create;True;0;0;0;False;0;False;0.6;0.395;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;90;-251.9141,-29.73294;Inherit;False;89;Albedo;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-955.8201,396.7069;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-402.8203,156.7069;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;35;-371.1334,-651.7139;Inherit;True;Property;_Normal;Normal;15;0;Create;True;0;0;0;False;0;False;-1;None;9945c39703054724fa43f3de1ff1f9f9;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-754.4,616.3799;Inherit;False;Property;_Opacity;Opacity;1;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;67,-2;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Synty/GoopShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;48;0;46;0
WireConnection;48;1;47;0
WireConnection;49;0;48;0
WireConnection;53;0;50;0
WireConnection;52;0;49;0
WireConnection;1;2;10;0
WireConnection;51;0;46;0
WireConnection;23;0;1;0
WireConnection;57;0;53;0
WireConnection;57;1;54;0
WireConnection;58;0;51;0
WireConnection;56;0;52;0
WireConnection;56;1;55;0
WireConnection;61;0;57;0
WireConnection;25;1;23;1
WireConnection;26;0;27;0
WireConnection;26;1;28;0
WireConnection;3;0;2;1
WireConnection;63;0;58;0
WireConnection;63;1;55;0
WireConnection;60;1;56;0
WireConnection;62;0;59;0
WireConnection;64;0;61;1
WireConnection;64;1;63;0
WireConnection;65;0;61;0
WireConnection;65;1;60;0
WireConnection;66;0;62;0
WireConnection;14;0;26;0
WireConnection;14;1;25;0
WireConnection;68;0;66;0
WireConnection;68;1;67;0
WireConnection;4;1;14;0
WireConnection;4;7;5;0
WireConnection;69;0;65;0
WireConnection;69;1;64;0
WireConnection;7;0;4;1
WireConnection;7;1;4;2
WireConnection;7;2;4;3
WireConnection;17;0;16;1
WireConnection;17;1;16;2
WireConnection;17;2;16;3
WireConnection;29;0;4;4
WireConnection;29;1;19;0
WireConnection;71;1;69;0
WireConnection;71;7;87;0
WireConnection;70;0;68;0
WireConnection;72;0;71;0
WireConnection;18;0;17;0
WireConnection;18;1;7;0
WireConnection;18;2;29;0
WireConnection;73;0;70;0
WireConnection;74;0;72;0
WireConnection;74;1;73;0
WireConnection;85;0;18;0
WireConnection;37;2;36;0
WireConnection;77;0;76;0
WireConnection;78;0;66;0
WireConnection;78;1;75;0
WireConnection;79;0;74;0
WireConnection;6;1;14;0
WireConnection;6;7;5;0
WireConnection;81;0;78;0
WireConnection;40;0;37;0
WireConnection;80;0;86;0
WireConnection;80;1;77;0
WireConnection;80;2;79;0
WireConnection;93;0;94;1
WireConnection;93;1;94;2
WireConnection;93;2;94;3
WireConnection;12;1;14;0
WireConnection;12;7;5;0
WireConnection;8;0;6;1
WireConnection;8;1;6;2
WireConnection;8;2;6;3
WireConnection;82;0;86;0
WireConnection;82;1;80;0
WireConnection;82;2;81;0
WireConnection;41;1;40;1
WireConnection;42;0;38;0
WireConnection;42;1;39;0
WireConnection;96;0;6;4
WireConnection;96;1;97;0
WireConnection;13;0;12;1
WireConnection;13;1;12;2
WireConnection;13;2;12;3
WireConnection;43;0;42;0
WireConnection;43;1;41;0
WireConnection;95;0;93;0
WireConnection;95;1;8;0
WireConnection;95;2;96;0
WireConnection;89;0;82;0
WireConnection;31;0;13;0
WireConnection;31;1;32;0
WireConnection;34;0;95;0
WireConnection;34;1;33;0
WireConnection;35;1;43;0
WireConnection;35;5;45;0
WireConnection;0;0;90;0
WireConnection;0;1;35;0
WireConnection;0;2;34;0
WireConnection;0;3;31;0
WireConnection;0;4;20;0
WireConnection;0;9;11;0
ASEEND*/
//CHKSM=0C5CA811D3A92BB546E708CCD6E1176B436A1E72