//
//  Lighting.metal
//  HeartGold3D
//
//  Created by Edvin Berling on 2024-03-31.
//

#include <metal_stdlib>
using namespace metal;


#import "Lighting.h"
float3 phongLighting(float3           normal,
                     float3           position,
                     constant Params &params,
                     constant Light   *lights,
                     float3           baseColor) {
    float3 diffuseColor = 0;
    float3 ambientColor = 0;
    float3 specularColor = 0;

    for (uint i = 0; i < params.lightCount; i++) {
        Light light = lights[i];
        switch (light.type) {
            case Sun: {
                float3 lightDirection = normalize(-light.position);
                float diffuseIntensity = saturate(-dot(lightDirection, normal));
                diffuseColor += light.color * baseColor * diffuseIntensity;
                break;
            }

            case Point: {
                break;
            }

            case Spot: {
                break;
            }

            case Ambient: {
                ambientColor += light.color;
                break;
            }

            case unused: {
                break;
            }
        }
    }

    
    return diffuseColor + specularColor + ambientColor;
}
