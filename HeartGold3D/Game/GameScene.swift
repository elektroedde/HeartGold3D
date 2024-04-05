import MetalKit


struct GameScene {
    var camera = PlayerCamera()
    var models: [Model] = []
    var lighting: SceneLighting
    
    var options: Options
    
    var typhlosion = Typhlosion()
    var pokecenter = PokeCenter()
    var tempground = TempGround()
    
    lazy var donut: Model = {
        let donut = Model(name: "groudon")
        donut.transform.position.z = -15
        donut.transform.position.y = 2
        return donut
    }()
    
    init(options: Options) {
        self.options = options
        lighting = SceneLighting(options: options)
        models = [typhlosion.model, pokecenter.model, tempground.model, donut]
    }
    
    mutating func update(size: CGSize) {
        camera.update(size: size)
    }
    
    mutating func update(deltaTime: Float) {
        lighting.update(deltaTime: deltaTime)
        camera.update(deltaTime: deltaTime)
    }
}
