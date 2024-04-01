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
    
    //Get these from correct models
    float materialShininess = 32;
    float3 materialSpecularColor = float3(1, 1, 1);

    for (uint i = 0; i < params.lightCount; i++) {
        Light light = lights[i];
        switch (light.type) {
            case Sun: {
                float3 lightDirection = normalize(-light.position);
                float diffuseIntensity = saturate(-dot(lightDirection, normal));
                diffuseColor += light.color * baseColor * diffuseIntensity;
                
                if(diffuseIntensity > 0) {
                    float3 reflection = reflect(lightDirection, normal);
                    float3 viewDirection = normalize(params.cameraPosition);
                    float specularIntensity = pow(saturate(dot(reflection, viewDirection)), materialShininess);
                    
                    specularColor += light.specularColor * materialSpecularColor * specularIntensity;
                }
                
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
