Shader "Unlit/ToonShading"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RampTex ("Ramp Texture", 2D) = "white" {}
        _OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
        _OutlineWidth ("Outline Width", Range(0, 0.1)) = 0.01
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100

        CGPROGRAM
        #pragma surface surf Lambert noforwardadd

        sampler2D _MainTex;
        sampler2D _RampTex;
        float _OutlineWidth;
        float4 _OutlineColor;

        struct Input {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            o.Specular = 0;
            o.Gloss = 0;

            float3 viewDirection = normalize(_WorldSpaceCameraPos - IN.worldPos);
            float ndotv = dot(IN.worldNormal, viewDirection);
            float rampValue = tex2D(_RampTex, float2(ndotv, 0.5)).r;
            o.Albedo *= rampValue;

            float outline = 1 - smoothstep(0, _OutlineWidth, ndotv);
            o.Emission = _OutlineColor.rgb * outline;
        }
            ENDCG
    }
}
