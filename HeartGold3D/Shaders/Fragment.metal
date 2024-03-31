#include <metal_stdlib>
using namespace metal;
#import "Lighting.h"
#import "ShaderDefs.h"

fragment float4 fragment_main(constant Params &   params [[buffer(ParamsBuffer)]],
                              VertexOut           in [[stage_in]],
                              texture2d < float > baseColorTexture [[texture(BaseColor)]],
                              constant Light      *lights [[buffer(LightBuffer)]]) {
//    constexpr sampler textureSampler(
//        filter::linear,
//        mip_filter::linear,
//        max_anisotropy(8),
//        address::repeat);
//    float3 baseColor = baseColorTexture.sample(
//        textureSampler,
//        in.uv * params.tiling).rgb;

//        return float4(in.normal ,1);

    constexpr sampler textureSampler(
        filter::linear,
        mip_filter::linear,
        max_anisotropy(8),
        address::repeat);
    
    float3 baseColor = baseColorTexture.sample(
        textureSampler,
        in.uv * params.tiling).rgb;
    
    float3 normalDirection = normalize(in.worldNormal);
    float3 color = phongLighting(
        normalDirection,
        in.worldPosition,
        params,
        lights,
        baseColor);

    return float4(color, 1);
}
