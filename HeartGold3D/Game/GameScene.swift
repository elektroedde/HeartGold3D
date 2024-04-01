import MetalKit


struct GameScene {
    var camera = PlayerCamera()
    var models: [Model] = []
    var lighting: SceneLighting
    
    var options: Options
    
    var typhlosion = Typhlosion()
    var pokecenter = PokeCenter()
    var tempground = TempGround()
    
    init(options: Options) {
        self.options = options
        lighting = SceneLighting(options: options)
        models = [typhlosion.model, pokecenter.model, tempground.model]
    }
    
    mutating func update(size: CGSize) {
        camera.update(size: size)
    }
    
    mutating func update(deltaTime: Float) {
        lighting.update(deltaTime: deltaTime)
        camera.update(deltaTime: deltaTime)
    }
}
