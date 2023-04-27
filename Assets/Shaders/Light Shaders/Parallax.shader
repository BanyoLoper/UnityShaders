Shader "Unlit/Parallax"
{
    Properties {
        _MainTex ("Albedo Texture", 2D) = "white" {}
        _NormalTex ("Normal Texture", 2D) = "white" {}
        _HeightTex ("Height Texture", 2D) = "white" {}
        _ParallaxHeight ("Parallax Height", Range(-0.1, 0.1)) = 0.02
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float3 tangent : TANGENT;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD1;
                float3 worldTangent : TEXCOORD2;
                float3 worldBinormal : TEXCOORD3;
                float3 worldPos : TEXCOORD4;
            };

            sampler2D _MainTex;
            sampler2D _NormalTex;
            sampler2D _HeightTex;
            float _ParallaxHeight;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldTangent = UnityObjectToWorldDir(v.tangent);
                o.worldBinormal = cross(o.worldNormal, o.worldTangent);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }


            float2 ParallaxMapping(float2 uv, float3 worldPos, float3 worldNormal, float3 worldTangent, float3 worldBinormal)
            {
                float3 viewDir = normalize(_WorldSpaceCameraPos - worldPos);
                float2 texCoords = uv;
                float3 viewDirectionTBN = float3(dot(viewDir, worldTangent), dot(viewDir, worldBinormal), dot(viewDir, worldNormal));
                viewDirectionTBN.xy = viewDirectionTBN.xy * _ParallaxHeight;
                texCoords = texCoords - viewDirectionTBN.xy * (tex2D(_HeightTex, texCoords).r - 0.5);
                return texCoords;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float2 newUV = ParallaxMapping(i.uv, i.worldPos, i.worldNormal, i.worldTangent, i.worldBinormal);
                fixed4 col = tex2D(_MainTex, newUV);
                return col;
            }
        ENDCG
        }
    }
}
