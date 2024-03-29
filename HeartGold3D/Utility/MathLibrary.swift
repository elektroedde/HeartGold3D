import simd

extension float4x4 {
    static var identity: float4x4 {
        matrix_identity_float4x4
    }

    //Translation
    init(translation: SIMD3<Float>) {
        let x = translation.x, y = translation.y, z = translation.z
        let matrix = float4x4(
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
            [x, y, z, 1])
        self = matrix
    }

    //Scaling
    init(scaling: SIMD3<Float>) {
        let x = scaling.x, y = scaling.y, z = scaling.z
        let matrix = float4x4(
            [x, 0, 0, 0],
            [0, y, 0, 0],
            [0, 0, z, 0],
            [0, 0, 0, 1])
        self = matrix
    }
    
    init(scaling: Float) {
        self = matrix_identity_float4x4
        columns.3.w = 1 / scaling
    }

    //Rotation
    init(rotation angle: SIMD3<Float>) {
        let rotationX = float4x4(rotationX: angle.x)
        let rotationY = float4x4(rotationY: angle.y)
        let rotationZ = float4x4(rotationZ: angle.z)
        self = rotationX * rotationY * rotationZ
    }

    //Projection
    init(projectionFov fov: Float, near: Float, far: Float, aspect: Float) {
        let y = 1 / tan(fov / 2)
        let x = y / aspect
        let z = far / (far - near)
        
        let X = SIMD4<Float>(x, 0, 0, 0)
        let Y = SIMD4<Float>(0, y, 0, 0)
        let Z = SIMD4<Float>(0, 0, z, 1)
        let W = SIMD4<Float>(0, 0, z * -near, 0)
        
        self.init()
        columns = (X, Y, Z, W)
    }

    // LookAt
    init(eye: SIMD3<Float>, center: SIMD3<Float>, up: SIMD3<Float>) {
        let z = normalize(center - eye)
        let x = normalize(cross(up, z))
        let y = cross(z, x)

        let X = SIMD4<Float>(x.x, y.x, z.x, 0)
        let Y = SIMD4<Float>(x.y, y.y, z.y, 0)
        let Z = SIMD4<Float>(x.z, y.z, z.z, 0)
        let W = SIMD4<Float>(-dot(x, eye), -dot(y, eye), -dot(z, eye), 1)

        self.init()
        columns = (X, Y, Z, W)
    }

    init(rotationX angle: Float) {
        let c = cos(angle)
        let s = sin(angle)
        let matrix = float4x4(
            [1, 0, 0, 0],
            [0, c, s, 0],
            [0, -s, c, 0],
            [0, 0, 0, 1])
        self = matrix
    }

    init(rotationY angle: Float) {
        let c = cos(angle)
        let s = sin(angle)
        let matrix = float4x4(
            [c, 0, -s, 0],
            [0, 1, 0, 0],
            [s, 0, c, 0],
            [0, 0, 0, 1])
        self = matrix
    }

    init(rotationZ angle: Float) {
        let c = cos(angle)
        let s = sin(angle)
        let matrix = float4x4(
            [c, s, 0, 0],
            [-s, c, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1])
        self = matrix
    }

//    init(scaling: Float) {
//      self = matrix_identity_float4x4
//      columns.3.w = 1 / scaling
//    }
}

extension Float {
    var radiansToDegrees: Float {
      (self / .pi) * 180
    }
    
    var degreesToRadians: Float {
      (self / 180) * .pi
    }
}
