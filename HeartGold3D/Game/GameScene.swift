import MetalKit


struct GameScene {
    var camera = PlayerCamera()
    var gameController: InputController!
    var lighting = SceneLighting()
    var time: Float = 0
    
    let music = Music()
    
    lazy var typhlosion: Model = {
        let typhlosion = Model(name: "typhlosion")
        typhlosion.transform.scale = 0.01
        typhlosion.transform.rotation.x = -.pi/2
        typhlosion.transform.rotation.z = .pi
        return typhlosion
    }()
    
    lazy var pokecenter: Model = {
        let pokecenter = Model(name: "pokecenter")
        pokecenter.transform.scale = 0.07
        pokecenter.transform.rotation.x = .pi
        pokecenter.transform.rotation.z = .pi
        pokecenter.transform.position.z = 10
        pokecenter.transform.position.y = 0.01
        return pokecenter
    }()
    
    lazy var ground: Model = {
        let ground = Model(name: "ground")
        ground.transform.rotation.x = -Float(90).degreesToRadians
        ground.transform.scale = 40
        return ground
    }()
    
//    lazy var ground: Model = {
//        let ground = Model(name: "ground", primitiveType: .plane)
//        ground.setTexture(name: "poke-ground", type: BaseColor)
//        ground.tiling = 160
//        ground.transform.scale = 400
//        ground.transform.rotation.z = Float(70).degreesToRadians
//        ground.transform.rotation.x = Float(10).degreesToRadians
//        ground.transform.rotation.y = Float(10).degreesToRadians
//        return ground
//    }()
    
    var models: [Model] = []
    
    

    
    
    init() {
        camera.position = [0, 1.4, -4.0]
        gameController = InputController()
        
        models = [typhlosion, pokecenter, ground]
        
    }
    
    mutating func update(size: CGSize) {
        camera.update(size: size)
    }
    
    mutating func update(deltaTime: Float) {
//        time += deltaTime*2 * .pi/10
//        lighting.sunlight.color.x = sin((time+1)/2)
        
//        lighting.sunlight.position = [30*cos(time), 10, -20]
        
        camera.rotation.x += gameController.cameraX/25
        camera.rotation.y += gameController.cameraY/25
        
        camera.position.z += gameController.positionY/20 * cos(camera.rotation.y) + gameController.positionX/20 * -sin(camera.rotation.y)
        camera.position.x += gameController.positionY/20 * sin(camera.rotation.y) + gameController.positionX/20 * cos(camera.rotation.y)
        
        if gameController.flyUp {
            camera.position.y += 0.1
        }
        if gameController.flyDown {
            camera.position.y -= 0.1
        }
    }
}
