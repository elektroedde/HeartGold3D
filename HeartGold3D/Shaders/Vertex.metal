//
//  Vertex.metal
//  HeartGold3D
//
//  Created by Edvin Berling on 2024-03-29.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

vertex float4 vertex_main(const VertexIn vertexIn [[stage_in]],
                          constant float &time [[buffer(1)]]) {
    float4 position = vertexIn.position;
    position.y -= 1;
    position.x += time;
    return position;
}
