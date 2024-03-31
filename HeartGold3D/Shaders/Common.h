//
//  Common.h
//  HeartGold3D
//
//  Created by Edvin Berling on 2024-03-29.
//

#ifndef Common_h
#define Common_h
#import <simd/simd.h>

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
    matrix_float3x3 normalMatrix;
} Uniforms;

typedef struct {
    uint width;
    uint height;
    uint tiling;
    uint lightCount;
    vector_float3 cameraPosition;
} Params;

typedef enum {
    Position = 0,
    Normal   = 1,
    UV       = 2
} Attributes;

typedef enum {
    VertexBuffer   = 0,
    UVBuffer       = 1,
    UniformsBuffer = 11,
    ParamsBuffer   = 12,
    LightBuffer    = 13
} BufferIndices;

typedef enum {
    BaseColor = 0
} TextureIndices;

typedef enum {
    unused  = 0,
    Sun     = 1,
    Spot    = 2,
    Point   = 3,
    Ambient = 4
} LightType;

typedef struct {
    LightType type;
    vector_float3 position;
    vector_float3 color;
    vector_float3 specularColor;
    float radius;
    vector_float3 attenuation;
    float coneAngle;
    vector_float3 coneDirection;
    float coneAttenuation;
} Light;

#endif /* Common_h */
