import MetalKit

class GameController: NSObject {
    var scene: GameScene
    var renderer: Renderer
    //  var options = Options()
    var fps: Double = 0
    var deltaTime: Double = 0
    var lastTime: Double = CFAbsoluteTimeGetCurrent()

    init(metalView: MTKView) {
        renderer = Renderer(metalView: metalView)
        scene = GameScene()
        super.init()
        metalView.delegate = self
        fps = Double(metalView.preferredFramesPerSecond)
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
    }
}

extension GameController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene.update(size: size)
        renderer.mtkView(view, drawableSizeWillChange: size)
    }

    func draw(in view: MTKView) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        let deltaTime = (currentTime - lastTime)
        lastTime = currentTime
        scene.update(deltaTime: Float(deltaTime))
        renderer.draw(scene: scene, in: view)
    }
}
