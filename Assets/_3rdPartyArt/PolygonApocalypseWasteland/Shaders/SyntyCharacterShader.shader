// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Synty/CharacterShader"
{
	Properties
	{
		_PolygonApocalypse2_Character_Texture_01_A("PolygonApocalypse2_Character_Texture_01_A", 2D) = "white" {}
		_SkinColour("SkinColour", Color) = (0,0,0,0)
		_chrTats("chrTats", 2D) = "white" {}
		_TattooTint("TattooTint", Color) = (0,0,0,0)
		_Emissive("Emissive", 2D) = "black" {}
		_EmissiveAmount("EmissiveAmount", Range( 0 , 2)) = 0
		_EmissiveTint("EmissiveTint", Color) = (1,1,1,0)
		_Smoothness("Smoothness", 2D) = "black" {}
		_SmoothnessAmount("SmoothnessAmount", Range( 0 , 1)) = 0.2
		_SmoothnessBasline("SmoothnessBasline", Range( 0 , 1)) = 0.2
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Normals("Normals", 2D) = "bump" {}
		_NormalAmount("NormalAmount", Range( 0 , 2)) = 1
		[HideInInspector]_skinMask("skinMask", 2D) = "white" {}
		[HideInInspector]_chrSkin("chrSkin", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normals;
		uniform float4 _Normals_ST;
		uniform float _NormalAmount;
		uniform sampler2D _PolygonApocalypse2_Character_Texture_01_A;
		uniform float4 _PolygonApocalypse2_Character_Texture_01_A_ST;
		uniform float4 _SkinColour;
		uniform sampler2D _skinMask;
		uniform float4 _skinMask_ST;
		uniform sampler2D _chrTats;
		uniform float4 _chrTats_ST;
		uniform float4 _TattooTint;
		uniform sampler2D _chrSkin;
		uniform float4 _chrSkin_ST;
		uniform sampler2D _Emissive;
		uniform float4 _Emissive_ST;
		uniform float _EmissiveAmount;
		uniform float4 _EmissiveTint;
		uniform float _Metallic;
		uniform sampler2D _Smoothness;
		uniform float4 _Smoothness_ST;
		uniform float _SmoothnessAmount;
		uniform float _SmoothnessBasline;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normals = i.uv_texcoord * _Normals_ST.xy + _Normals_ST.zw;
			o.Normal = ( UnpackNormal( tex2D( _Normals, uv_Normals ) ) * _NormalAmount );
			float2 uv_PolygonApocalypse2_Character_Texture_01_A = i.uv_texcoord * _PolygonApocalypse2_Character_Texture_01_A_ST.xy + _PolygonApocalypse2_Character_Texture_01_A_ST.zw;
			float2 uv_skinMask = i.uv_texcoord * _skinMask_ST.xy + _skinMask_ST.zw;
			float3 lerpResult15 = lerp( (tex2D( _PolygonApocalypse2_Character_Texture_01_A, uv_PolygonApocalypse2_Character_Texture_01_A )).rgb , (_SkinColour).rgb , tex2D( _skinMask, uv_skinMask ).r);
			float2 uv_chrTats = i.uv_texcoord * _chrTats_ST.xy + _chrTats_ST.zw;
			float4 tex2DNode2 = tex2D( _chrTats, uv_chrTats );
			float3 lerpResult19 = lerp( lerpResult15 , ( (tex2DNode2).rgb + (_TattooTint).rgb ) , tex2DNode2.a);
			float2 uv_chrSkin = i.uv_texcoord * _chrSkin_ST.xy + _chrSkin_ST.zw;
			o.Albedo = ( lerpResult19 * (tex2D( _chrSkin, uv_chrSkin )).rgb );
			float2 uv_Emissive = i.uv_texcoord * _Emissive_ST.xy + _Emissive_ST.zw;
			o.Emission = ( (tex2D( _Emissive, uv_Emissive )).rgb * _EmissiveAmount * (_EmissiveTint).rgb );
			o.Metallic = _Metallic;
			float2 uv_Smoothness = i.uv_texcoord * _Smoothness_ST.xy + _Smoothness_ST.zw;
			o.Smoothness = ( ( (tex2D( _Smoothness, uv_Smoothness )).rgb * _SmoothnessAmount ) + _SmoothnessBasline ).x;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18909
-3424;7;2956;1351;2395.059;396.1323;1;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;5;322.382,8.447534;Inherit;True;Property;_Texture0;Texture 0;15;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;604.6243,85.03591;Inherit;False;AlbedoSS;-1;True;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-2610.678,-654.0443;Inherit;False;6;AlbedoSS;1;0;OBJECT;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1371.707,562.7437;Inherit;False;6;AlbedoSS;1;0;OBJECT;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SamplerNode;2;-2221.681,-252.5363;Inherit;True;Property;_chrTats;chrTats;2;0;Create;True;0;0;0;False;0;False;-1;fea9907e743cf9246a35b92a0b9f947b;fea9907e743cf9246a35b92a0b9f947b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-2234.078,-789.644;Inherit;False;Property;_SkinColour;SkinColour;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-2366.739,-1021.242;Inherit;True;Property;_PolygonApocalypse2_Character_Texture_01_A;PolygonApocalypse2_Character_Texture_01_A;0;0;Create;True;0;0;0;False;0;False;-1;6aac82dfb5a99c542a883fd2a8615461;6aac82dfb5a99c542a883fd2a8615461;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;24;-2178.209,-49.19621;Inherit;False;Property;_TattooTint;TattooTint;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;22;-1492.431,-488.6697;Inherit;False;6;AlbedoSS;1;0;OBJECT;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-1014.895,263.3741;Inherit;False;6;AlbedoSS;1;0;OBJECT;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.ComponentMaskNode;25;-1941.209,-47.19621;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;20;-1903.078,-260.644;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;16;-1984.078,-847.644;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;18;-1993.078,-698.644;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;30;-1178.027,509.3066;Inherit;True;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-2244.267,-589.3337;Inherit;True;Property;_skinMask;skinMask;13;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;61a7c11b32068ef4e96b6cc03c475db2;61a7c11b32068ef4e96b6cc03c475db2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1312.438,-487.4777;Inherit;True;Property;_chrSkin;chrSkin;14;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;ca149d8b462458a4eb1ab7e4ce85b5bb;ca149d8b462458a4eb1ab7e4ce85b5bb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;31;-781.3007,517.7394;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;15;-1723.078,-559.644;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;10;-821.2153,209.937;Inherit;True;Property;_Emissive;Emissive;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-850.6733,612.8631;Inherit;False;Property;_SmoothnessAmount;SmoothnessAmount;8;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;-1176.059,330.8677;Inherit;False;Property;_EmissiveTint;EmissiveTint;6;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1630.496,-230.5389;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-535.7073,317.6369;Inherit;False;Property;_EmissiveAmount;EmissiveAmount;5;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;28;-808.3073,-40.80195;Inherit;True;Property;_Normals;Normals;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-545.4857,101.1485;Inherit;False;Property;_NormalAmount;NormalAmount;12;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-1444.078,-231.644;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;27;-993.2089,-279.1963;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-537.451,523.8356;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;40;-944.0593,407.8677;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;13;-503.1936,209.9371;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-846.2524,687.2222;Inherit;False;Property;_SmoothnessBasline;SmoothnessBasline;9;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-365.5872,605.7065;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-259.344,216.0333;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-765.2089,-192.1962;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-267.2053,18.22681;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-532.6512,407.0344;Inherit;False;Property;_Metallic;Metallic;10;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Synty/CharacterShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;1
WireConnection;2;7;21;0
WireConnection;3;7;21;0
WireConnection;25;0;24;0
WireConnection;20;0;2;0
WireConnection;16;0;3;0
WireConnection;18;0;17;0
WireConnection;30;7;29;0
WireConnection;4;7;21;0
WireConnection;1;7;22;0
WireConnection;31;0;30;0
WireConnection;15;0;16;0
WireConnection;15;1;18;0
WireConnection;15;2;4;1
WireConnection;10;7;14;0
WireConnection;36;0;20;0
WireConnection;36;1;25;0
WireConnection;19;0;15;0
WireConnection;19;1;36;0
WireConnection;19;2;2;4
WireConnection;27;0;1;0
WireConnection;32;0;31;0
WireConnection;32;1;8;0
WireConnection;40;0;39;0
WireConnection;13;0;10;0
WireConnection;33;0;32;0
WireConnection;33;1;34;0
WireConnection;11;0;13;0
WireConnection;11;1;9;0
WireConnection;11;2;40;0
WireConnection;26;0;19;0
WireConnection;26;1;27;0
WireConnection;37;0;28;0
WireConnection;37;1;38;0
WireConnection;0;0;26;0
WireConnection;0;1;37;0
WireConnection;0;2;11;0
WireConnection;0;3;7;0
WireConnection;0;4;33;0
ASEEND*/
//CHKSM=BADE9623FC6555F5261F09A775EA384FF77C3E50