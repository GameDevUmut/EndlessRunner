// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Synty/VehicleShader_01"
{
	Properties
	{
		_AlbedoMain("AlbedoMain", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_RustOverlay("RustOverlay", 2D) = "white" {}
		[ToggleUI]_RustToggle("RustToggle", Range( 0 , 1)) = 0
		_BloodOverlay("BloodOverlay", 2D) = "white" {}
		[ToggleUI]_BloodToggle("BloodToggle", Range( 0 , 1)) = 0
		_Metallic_Smoothness("Metallic_Smoothness", 2D) = "black" {}
		[ToggleUI]_UseMetallicMap("UseMetallicMap", Range( 0 , 1)) = 0
		_MetallicValue("MetallicValue", Range( 0 , 1)) = 0
		[ToggleUI]_UseSmoothnessMap("UseSmoothnessMap", Range( 0 , 1)) = 0
		_SmoothnessValue("SmoothnessValue", Range( 0 , 1)) = 0
		_Emissive("Emissive", 2D) = "black" {}
		_EmissiveValue("EmissiveValue", Range( 0 , 2)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
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
			float2 uv2_texcoord2;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _AlbedoMain;
		uniform float4 _AlbedoMain_ST;
		uniform sampler2D _RustOverlay;
		uniform float4 _RustOverlay_ST;
		uniform float _RustToggle;
		uniform sampler2D _BloodOverlay;
		uniform float4 _BloodOverlay_ST;
		uniform float _BloodToggle;
		uniform sampler2D _Emissive;
		uniform float4 _Emissive_ST;
		uniform float _EmissiveValue;
		uniform float _MetallicValue;
		uniform sampler2D _Metallic_Smoothness;
		uniform float4 _Metallic_Smoothness_ST;
		uniform float _UseMetallicMap;
		uniform float _SmoothnessValue;
		uniform float _UseSmoothnessMap;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 tex2DNode20 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float3 appendResult21 = (float3(tex2DNode20.r , tex2DNode20.g , tex2DNode20.b));
			o.Normal = appendResult21;
			float2 uv_AlbedoMain = i.uv_texcoord * _AlbedoMain_ST.xy + _AlbedoMain_ST.zw;
			float4 tex2DNode1 = tex2D( _AlbedoMain, uv_AlbedoMain );
			float3 appendResult12 = (float3(tex2DNode1.r , tex2DNode1.g , tex2DNode1.b));
			float2 uv_RustOverlay = i.uv_texcoord * _RustOverlay_ST.xy + _RustOverlay_ST.zw;
			float4 tex2DNode9 = tex2D( _RustOverlay, uv_RustOverlay );
			float3 appendResult13 = (float3(tex2DNode9.r , tex2DNode9.g , tex2DNode9.b));
			float3 lerpResult11 = lerp( appendResult12 , appendResult13 , ( tex2DNode9.a * _RustToggle ));
			float2 uv2_BloodOverlay = i.uv2_texcoord2 * _BloodOverlay_ST.xy + _BloodOverlay_ST.zw;
			float4 tex2DNode10 = tex2D( _BloodOverlay, uv2_BloodOverlay );
			float3 appendResult14 = (float3(tex2DNode10.r , tex2DNode10.g , tex2DNode10.b));
			float3 lerpResult15 = lerp( lerpResult11 , appendResult14 , ( tex2DNode10.a * _BloodToggle ));
			o.Albedo = lerpResult15;
			float2 uv_Emissive = i.uv_texcoord * _Emissive_ST.xy + _Emissive_ST.zw;
			float4 tex2DNode34 = tex2D( _Emissive, uv_Emissive );
			float3 appendResult35 = (float3(tex2DNode34.r , tex2DNode34.g , tex2DNode34.b));
			o.Emission = ( appendResult35 * _EmissiveValue );
			float3 temp_cast_0 = (_MetallicValue).xxx;
			float2 uv_Metallic_Smoothness = i.uv_texcoord * _Metallic_Smoothness_ST.xy + _Metallic_Smoothness_ST.zw;
			float4 tex2DNode23 = tex2D( _Metallic_Smoothness, uv_Metallic_Smoothness );
			float3 appendResult24 = (float3(tex2DNode23.r , tex2DNode23.g , tex2DNode23.b));
			float3 lerpResult32 = lerp( temp_cast_0 , ( appendResult24 * _MetallicValue ) , _UseMetallicMap);
			o.Metallic = lerpResult32.x;
			float3 temp_cast_2 = (_SmoothnessValue).xxx;
			float3 lerpResult33 = lerp( temp_cast_2 , ( appendResult24 * _SmoothnessValue ) , _UseSmoothnessMap);
			o.Smoothness = lerpResult33.x;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18909
-3424;7;2956;1351;2417.841;434.0453;1;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;4;346,-3.5;Inherit;True;Property;_Albedo;Albedo;13;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;610,50.5;Inherit;False;AlbedoSS;-1;True;1;0;SAMPLERSTATE;0;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.GetLocalVarNode;8;-1533,-398.5;Inherit;False;7;AlbedoSS;1;0;OBJECT;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SamplerNode;23;-1273,712;Inherit;True;Property;_Metallic_Smoothness;Metallic_Smoothness;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-1259,-207.5;Inherit;True;Property;_RustOverlay;RustOverlay;2;0;Create;True;0;0;0;False;0;False;-1;23857d7abc999dc48b814213e9aa14ba;7d4422588be55b04bbacfcdafe97d1b9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1258,-408.5;Inherit;True;Property;_AlbedoMain;AlbedoMain;0;0;Create;True;0;0;0;False;0;False;-1;296a64e390bb5274cb5e668d1469178b;2fc280b09dc23b1419c612c62895ea53;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-1237,-5.5;Inherit;False;Property;_RustToggle;RustToggle;3;1;[ToggleUI];Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1242,287.5;Inherit;False;Property;_BloodToggle;BloodToggle;5;1;[ToggleUI];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-940,-102.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-944,-227.5;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-972,733;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;10;-1256,89.5;Inherit;True;Property;_BloodOverlay;BloodOverlay;4;0;Create;True;0;0;0;False;0;False;-1;655222e720e330e40b0fae291b570136;417b48fb0f2d35b4fba7b92fc5aecbbd;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-1195.5,1231.25;Inherit;False;Property;_SmoothnessValue;SmoothnessValue;10;0;Create;True;0;0;0;False;0;False;0;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-950,-369.5;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;34;-1266.5,408.75;Inherit;True;Property;_Emissive;Emissive;11;0;Create;True;0;0;0;False;0;False;-1;None;155175aa2fb75ec42bc160c10de3ea5b;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-1258,907.5;Inherit;False;Property;_MetallicValue;MetallicValue;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1259,987.5;Inherit;False;Property;_UseMetallicMap;UseMetallicMap;7;1;[ToggleUI];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1195,1314.5;Inherit;False;Property;_UseSmoothnessMap;UseSmoothnessMap;9;1;[ToggleUI];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-835,730.5;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;35;-965.5,429.75;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-818.5,1087.25;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-935,36.5;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;20;-646,48.5;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;0;False;0;False;-1;None;f124423d56f83a24aaa3388b913d9bb8;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-931,166.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;11;-772,-291.5;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1251.5,604.25;Inherit;False;Property;_EmissiveValue;EmissiveValue;12;0;Create;True;0;0;0;False;0;False;0;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;33;-650,1073.5;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;15;-589,-113.5;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-314,68.5;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;32;-668,732.5;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-809.5,429.25;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Synty/VehicleShader_01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;4;1
WireConnection;23;7;8;0
WireConnection;9;7;8;0
WireConnection;1;7;8;0
WireConnection;18;0;9;4
WireConnection;18;1;19;0
WireConnection;13;0;9;1
WireConnection;13;1;9;2
WireConnection;13;2;9;3
WireConnection;24;0;23;1
WireConnection;24;1;23;2
WireConnection;24;2;23;3
WireConnection;10;7;8;0
WireConnection;12;0;1;1
WireConnection;12;1;1;2
WireConnection;12;2;1;3
WireConnection;34;7;8;0
WireConnection;25;0;24;0
WireConnection;25;1;22;0
WireConnection;35;0;34;1
WireConnection;35;1;34;2
WireConnection;35;2;34;3
WireConnection;27;0;24;0
WireConnection;27;1;29;0
WireConnection;14;0;10;1
WireConnection;14;1;10;2
WireConnection;14;2;10;3
WireConnection;17;0;10;4
WireConnection;17;1;16;0
WireConnection;11;0;12;0
WireConnection;11;1;13;0
WireConnection;11;2;18;0
WireConnection;33;0;29;0
WireConnection;33;1;27;0
WireConnection;33;2;31;0
WireConnection;15;0;11;0
WireConnection;15;1;14;0
WireConnection;15;2;17;0
WireConnection;21;0;20;1
WireConnection;21;1;20;2
WireConnection;21;2;20;3
WireConnection;32;0;22;0
WireConnection;32;1;25;0
WireConnection;32;2;30;0
WireConnection;36;0;35;0
WireConnection;36;1;37;0
WireConnection;0;0;15;0
WireConnection;0;1;21;0
WireConnection;0;2;36;0
WireConnection;0;3;32;0
WireConnection;0;4;33;0
ASEEND*/
//CHKSM=8C5C2083F9FA14DE027F54266C73822EB9D257A4