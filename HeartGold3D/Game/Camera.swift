import CoreGraphics

protocol Camera: Transformable {
    var projectionMatrix: float4x4 { get }
    var viewMatrix: float4x4 { get }
    mutating func update(size: CGSize)
    mutating func update(deltaTime: Float)
}

struct PlayerCamera: Camera {
//    var gameController: InputController
    var gameController = InputController()
    var transform = Transform()
    var aspect: Float = 1.0
    var fov = Float(70).degreesToRadians
    var near: Float = 0.1
    var far: Float = 1000
    var projectionMatrix: float4x4 {
        float4x4(projectionFov: fov, near: near, far: far, aspect: aspect)
    }
    
    var viewMatrix: float4x4 {
//        (float4x4(translation: position) * float4x4(rotation: rotation)).inverse
        let rotateMatrix = float4x4(
            rotationYXZ: [-rotation.x, rotation.y, 0])
        return (float4x4(translation: position) *
            rotateMatrix).inverse
    }
    
    init() {
        position = [0, 1.5, -4]
    }

    
    mutating func update(size: CGSize) {
        aspect = Float(size.width / size.height)
    }
    
    mutating func update(deltaTime: Float) {
        
        //WASD
//        let transform = updateInput(deltaTime: deltaTime)
//        rotation += transform.rotation
//        position += transform.position
        
        //DUALSENSE
        rotation.x += gameController.cameraX/25
        rotation.y += gameController.cameraY/25
        
        position.z += gameController.positionY/20 * cos(rotation.y) + gameController.positionX/20 * -sin(rotation.y)
        position.x += gameController.positionY/20 * sin(rotation.y) + gameController.positionX/20 * cos(rotation.y)
        
        if gameController.flyUp {
            position.y += 0.1
        }
        if gameController.flyDown {
            position.y -= 0.1
        }
    }
}

extension PlayerCamera: Movement {
    
}

