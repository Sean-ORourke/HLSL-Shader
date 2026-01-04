Shader "Custom/OutlineShader"
{
    Properties
    {
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)

        [Toggle] _OutlineExist("Outline Exist?", Float) = 0
        [Toggle] _AutoOutlineColor("Auto Outline Color?", Float) = 0
        

        _OutlineColor("Outline Color", Color) = (0, 0, 0, 0)
        _OutlineThickness("Outline Thickness", Float) = 0.05

        _BaseMap("Base Map", 2D) = "white"
    }

    SubShader
    {
        Name "Main Object"
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }
        
        Pass
        {
            // Tags { "LightMode"="UniversalForward" }
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS   : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                float4 _BaseMap_ST;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv) * _BaseColor;
                return color;
            }
            ENDHLSL
        }
        
        Pass 
        {
            Name "OutlineVisual"
            Tags { "LightMode"="UniversalForward" }

            Cull Front

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS   : NORMAL;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
            };

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                float4 _BaseMap_ST;
                float _OutlineThickness;
                half4 _OutlineColor;
                float _AutoOutlineColor;
                float _OutlineExist;
            CBUFFER_END

            Varyings vert (Attributes IN)
            {
                Varyings OUT;
                float3 expandedPosition = IN.positionOS.xyz + IN.normalOS * _OutlineThickness;
                OUT.positionHCS = lerp(TransformObjectToHClip(IN.positionOS.xyz), TransformObjectToHClip(expandedPosition), _OutlineExist);
                return OUT;
            }

            half4 frag (Varyings IN) : SV_Target
            {

                float brightness = dot(_BaseColor.rgb, float3(0.2126, 0.7152, 0.0722));
                half4 CalculatedOutlineColor = _BaseColor - lerp(half4(-0.5, -0.5, -0.5, 1), half4(1.5, 1.5, 1.5, 1), brightness);
                half4 finalOutlineColor = lerp(_OutlineColor, CalculatedOutlineColor, _AutoOutlineColor);
                return finalOutlineColor;
            }
            ENDHLSL
        }
        
    }
}
