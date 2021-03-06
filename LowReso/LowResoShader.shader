﻿Shader "ore/LowResoShader" {
    /*
        Only on orthographics
     */
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
            "Queue"="Transparent"
        }
        LOD 200
        Pass {
            Name "Bullet"
            Cull Off
            Blend SrcAlpha OneMinusSrcAlpha
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

sampler2D _MainTex;
half4 _MainTex_ST;

struct a2v {
    float4 vertex : POSITION;
    float4 color : COLOR;
    float2 uv : TEXCOORD0;
};

struct v2f {
    float4 position : SV_POSITION;
    float4 color : COLOR;
    float2 uv : TEXCOORD0;
};


v2f vert(a2v v) {
    v2f o;
    o.position = mul(UNITY_MATRIX_MVP, v.vertex);
    o.position.xy *= _ScreenParams.xy;
    o.position.x = (int)o.position.x;
    o.position.y = (int)o.position.y;
    o.position.xy /= _ScreenParams.xy;
    o.color = v.color;
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    return o;
}

fixed4 frag(v2f i) : COLOR {
    half4 col = i.color * tex2D(_MainTex, i.uv);
    col *= 16.0;
    col = floor(col);
    col *= 1.0/16.0;
    col.w = 1;
    return col;//i.color * tex2D(_MainTex, i.uv);
}
ENDCG
        }
    }
    FallBack "Diffuse"
}
