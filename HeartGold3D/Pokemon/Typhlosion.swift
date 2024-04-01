
struct Typhlosion {
    lazy var model: Model = {
        let model = Model(name: "typhlosion")
        model.transform.scale = 0.01
        model.transform.rotation.x = -.pi/2
        model.transform.rotation.z = .pi
        return model
    }()
}
