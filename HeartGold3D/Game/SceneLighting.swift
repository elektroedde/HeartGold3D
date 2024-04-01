import MetalKit

struct SceneLighting {
    var options: Options
    var lights: [Light] = []
    var sunlight: Light = {
        var light = Self.buildDefaultLight()
        light.position = [0, 100, -200.0]
        return light
    }()
    
    var ambientLight: Light = {
        var light = Self.buildDefaultLight()
        light.color = [0.1, 0.1, 0.1]
        light.type = Ambient
        return light
    }()

    static func buildDefaultLight() -> Light {
        var light = Light()
        light.position = [0, 0, 0]
        light.color = [1, 1, 1]
        light.specularColor = [0.6, 0.6, 0.6]
        light.attenuation = [1, 0, 0]
        light.type = Sun
        return light
    }

    init(options: Options) {
        lights.append(sunlight)
        lights.append(ambientLight)
        self.options = options
    }
    
    mutating func update(size: CGSize) {
        
    }
    
    mutating func update(deltaTime: Float) {
        
        //temporary solution to change a lights value
        lights[0].position = [100*options.angle-50, 10, -20]


    }
}
