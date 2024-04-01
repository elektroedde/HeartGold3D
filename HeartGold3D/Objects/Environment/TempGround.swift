
struct TempGround {
    lazy var model: Model = {
        let model = Model(name: "ground2")
        model.transform.rotation.x = -Float(90).degreesToRadians
        model.transform.scale = 40
        return model
    }()
}
