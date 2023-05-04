// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Parallax2"
{
    Properties {
        _AlbedoTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex ("Normal (RGB)", 2D) = "bump" {}
        _HeightTex ("Height (R)", 2D) = "white" {}
        _ParallaxIntensity ("Parallax Intensity", Range(0, 0.1)) = 0.02
        _Specular ("Specular", Range(0, 1)) = 0.5
        _Gloss ("Gloss", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert
        #pragma target 3.0
        
        sampler2D _AlbedoTex;
        sampler2D _NormalTex;
        sampler2D _HeightTex;
        float _ParallaxIntensity;
        float _Gloss;
        float _Specular;

        struct Input
        {
            float2 UV; // Coordenadas de textura
            float3 WorldNormal; // Normal en el espacio del mundo
            float3 WorldPos;
        };

        void vert (inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.UV = v.texcoord;
            o.WorldNormal = UnityObjectToWorldNormal(v.normal);
            o.WorldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
        }
        
        void surf (Input IN, inout SurfaceOutput o) {

            float3 worldTangent = normalize(cross(float3(0,1,0), IN.WorldNormal));
            float3 worldBinormal = cross(IN.WorldNormal, worldTangent);

            float3 viewDirWorld = normalize(_WorldSpaceCameraPos - IN.WorldPos);
            float3 viewDirTangentSpace = normalize(viewDirWorld.x * worldTangent + viewDirWorld.y * worldBinormal + viewDirWorld.z * IN.WorldNormal);
            
            float height = tex2D(_HeightTex, IN.UV).r * _ParallaxIntensity;
            float2 parallaxUV = IN.UV + viewDirTangentSpace.xy * height;

            o.Albedo = tex2D(_AlbedoTex, parallaxUV).rgb;
            float3 normalTangentSpace = tex2D(_NormalTex, parallaxUV).rgb * 2 - 1;

            o.Specular = _Specular;
            o.Normal = normalize(normalTangentSpace.x * worldTangent + normalTangentSpace.y * worldBinormal + normalTangentSpace.z * IN.WorldNormal);
            o.Gloss = _Gloss;
            o.Emission = float3(0, 0, 0);
            o.Alpha = 1;
        }
        ENDCG
    }
}
