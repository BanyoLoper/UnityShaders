Shader "Custom/SpecularShader"
{
    Properties {
        _MainTex ("Diffuse Texture", 2D) = "white" {}
        _SpecularTex ("Specular Texture", 2D) = "white" {}
        _LightPos ("Light Position", Vector) = (0, 0, 0)
        _Shininess ("Shininess", Range(1, 1000)) = 50
        _SpecularFactor ("Specular Factor", Range(0, 10)) = 1
    }

    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _SpecularTex;
        float _Shininess;
        float3 _LightPos;
        float _SpecularFactor;

        struct Input {
            float2 uv_MainTex;
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutput o) {
            float3 lightDir = normalize(_LightPos - IN.worldPos);
            float3 viewDir = normalize(_WorldSpaceCameraPos - IN.worldPos);
            float3 halfDir = normalize(lightDir + viewDir);
            float NdotH = max(0, dot(o.Normal, halfDir));
            float spec = pow(NdotH, _Shininess);
            o.Emission = _SpecularFactor * spec * tex2D(_SpecularTex, IN.uv_MainTex).rgb;
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            o.Specular = 0.5;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
