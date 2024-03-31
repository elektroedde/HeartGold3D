//
//  Lighting.h
//  HeartGold3D
//
//  Created by Edvin Berling on 2024-03-31.
//

#ifndef Lighting_h
#define Lighting_h
#import "Common.h"


float3 phongLighting(float3 normal,
                     float3 position,
                     constant Params &params,
                     constant Light *lights,
                     float3 baseColor);

#endif /* Lighting_h */
