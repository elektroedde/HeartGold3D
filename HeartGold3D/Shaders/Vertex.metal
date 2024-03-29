//
//  Vertex.metal
//  HeartGold3D
//
//  Created by Edvin Berling on 2024-03-29.
//

//#include <metal_stdlib>
//using namespace metal;
//
//struct VertexIn {
//    float4 position [[attribute(0)]];
//};
//
//vertex VertexOut vertex_main(const VertexIn vertexIn [[stage_in]]) {
//    float4 position = vertexIn.position;
//    VertexOut vertexOut {
//        .position = position
//    };
//    return vertexOut;
//}

#include <metal_stdlib>
#import "Common.h"
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
};

vertex VertexOut vertex_main(VertexIn in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(11)]]) {
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
    VertexOut out {
        .position = position
    };

    return out;
}

fragment float4 fragment_main() {
    return float4(0.2, 0.5, 1.0, 1);
}
