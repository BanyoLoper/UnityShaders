Shader "Unlit/Blur VH"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _VerticalKernelSize ("Vertical Kernel Size", Range(1, 30)) = 5
        _HorizontalKernelSize ("Horizontal Kernel Size", Range(1, 30)) = 5
        _TextureWidth ("Texture Width", Range(1, 1000)) = 100
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment fragHorizontal
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _HorizontalKernelSize;
            float _TextureWidth;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 fragHorizontal (v2f i) : SV_Target
            {
                float texelSize = 1.0 / _TextureWidth;
                fixed4 result = fixed4(0.0, 0.0, 0.0, 0.0);

                for (int j = - _HorizontalKernelSize; j <= _HorizontalKernelSize; j++)
                {
                    float weight = float(j);
                    fixed4 sample = tex2D(_MainTex, i.uv + fixed2(weight * texelSize, 0.0));
                    result += sample;
                }

                result /= _HorizontalKernelSize * 2 + 1;
                return result;
            }
            ENDCG
        }
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment fragVertical
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _VerticalKernelSize;
            float _TextureWidth;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 fragVertical (v2f i) : SV_Target
            {
                float texelSize = 1.0 / _TextureWidth;
                fixed4 result = fixed4(0.0, 0.0, 0.0, 0.0);

                for (int j = -_VerticalKernelSize; j <= _VerticalKernelSize; j++)
                {
                    float weight = float(j);
                    fixed4 sample = tex2D(_MainTex, i.uv + fixed2( 0.0, weight * texelSize));
                    result += sample;
                }

                result /= _VerticalKernelSize * 2 + 1;
                return result;
            }
            ENDCG
        }
    }
}
