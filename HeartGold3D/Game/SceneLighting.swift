struct SceneLighting {
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

    init() {
        lights.append(sunlight)
        lights.append(ambientLight)
    }
}
