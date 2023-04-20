Shader "Unlit/WaterWave"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed ("Speed", Range(0, 10)) = 1
        _Amplitude ("Amplitude", Range(0, 0.1)) = 0.01
        _Frequency ("Frequency", Range(0, 50)) = 10
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
        float _Speed;
        float _Amplitude;
        float _Frequency;

        v2f vert (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = v.uv;
            return o;
        }

        fixed4 frag (v2f i) : SV_Target
        {
            float2 uv = i.uv;
            float time = _Time.y * _Speed;
            float wave = _Amplitude * sin(_Frequency * (uv.x + uv.y) + time);

            uv.x += wave;
            uv.y += wave;

                fixed4 col = tex2D(_MainTex, uv);
            return col;
        }
        ENDCG
        }
    }
}
