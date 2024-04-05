import MetalKit

class Renderer: NSObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    
    var uniforms = Uniforms()
    var params = Params()
    var options: Options
    
    var forwardRenderPass: ForwardRenderPass

    init(metalView: MTKView, options: Options) {
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue()
        else { fatalError("GPU not available") }

        Self.device = device
        Self.commandQueue = commandQueue
        metalView.device = device

        // Create the library
        let library = device.makeDefaultLibrary()
        Self.library = library

        self.options = options
        
        
        forwardRenderPass = ForwardRenderPass(view: metalView, options: options)
        super.init()

        metalView.clearColor = MTLClearColor(red: 0.65, green: 0.8, blue: 1.0, alpha: 1.0)
        metalView.depthStencilPixelFormat = .depth32Float

        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
    }

    static func buildDepthStencilState() -> MTLDepthStencilState? {
        let descriptor = MTLDepthStencilDescriptor()

        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true

        return Renderer.device.makeDepthStencilState(descriptor: descriptor)
    }
}

extension Renderer {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        forwardRenderPass.resize(view: view, size: size)
    }

    func updateUniforms(scene: GameScene) {
        uniforms.viewMatrix = scene.camera.viewMatrix
        uniforms.projectionMatrix = scene.camera.projectionMatrix
        params.lightCount = UInt32(scene.lighting.lights.count)
        params.cameraPosition = scene.camera.position
    }

    func draw(scene: GameScene, in view: MTKView) {
        guard
            let commandBuffer = Self.commandQueue.makeCommandBuffer(),
            let descriptor = view.currentRenderPassDescriptor
        else { return }

        updateUniforms(scene: scene)

        forwardRenderPass.descriptor = descriptor
        forwardRenderPass.draw(commandBuffer: commandBuffer, scene: scene, uniforms: uniforms, params: params)
        
        


        guard let drawable = view.currentDrawable
        else { return }

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
