
struct PokeCenter {
    lazy var model: Model = {
        let model = Model(name: "pokecenter")
        model.transform.scale = 0.07
        model.transform.rotation.x = .pi
        model.transform.rotation.z = .pi
        model.transform.position.z = 10
        model.transform.position.y = 0.01
        return model
    }()
}
