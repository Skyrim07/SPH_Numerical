Shader "Unlit/SPH"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            float4 _MainTex_ST;

            float4 _Pos[250];

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float Circle(float2 uv, float2 pos, float r, float w)
            {
	            float l = length(uv - pos);
	            float s = smoothstep(r, r - w, l);
	            return s;
            }

            float RayParticle(float3 origin, float3 dir, float3 center){
                float radius = 0.01;
                float3 offset = origin - center;
                float a = dot(dir, dir);
                float b = 2*dot(offset, dir);
                float c = dot(offset, offset) - radius * radius;
                float delta = b*b-4*a*c;
                if(delta>0){
                     float dst = (-b-sqrt(delta))/2*a;
                    return step(0, dst);
                }
                return 0;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                i.uv -= .5;
                float f = 1;
                float3 camera = float3(0,0,-f);
                float3 dir = normalize(float3(i.uv, f));
                for(int i =0 ; i<250;i++){
                        float t = RayParticle(camera, dir, _Pos[i].xyz);
                        if(t>=1)
                            col = fixed4(0,0,1,1);
                }
                return col;
            }
            ENDCG
        }
    }
}
