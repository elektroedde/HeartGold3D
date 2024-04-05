import MetalKit

struct ForwardRenderPass: RenderPass {
    let label: String = "Forward Render Pass"
    var descriptor: MTLRenderPassDescriptor?

    var pipelineState: MTLRenderPipelineState
    let depthStencilState: MTLDepthStencilState?
    
    var options: Options

    init(view: MTKView, options: Options) {
        self.options = options
        pipelineState = PipelineStates.createForwardPSO(colorPixelFormat: view.colorPixelFormat)
        depthStencilState = Self.buildDepthStencilState()
    }

    mutating func resize(view: MTKView, size: CGSize) {
    }

    func draw(commandBuffer: any MTLCommandBuffer, scene: GameScene, uniforms: Uniforms, params: Params) {
        guard let descriptor = descriptor, let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else { return }
        
        renderEncoder.label = label
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        
        var lights = scene.lighting.lights
        renderEncoder.setFragmentBytes(&lights, length: MemoryLayout<Light>.stride * lights.count, index: LightBuffer.index)
        
        if options.showWireframe {
            renderEncoder.setTriangleFillMode(.lines)
        }
        
        for model in scene.models {
            model.render(encoder: renderEncoder, uniforms: uniforms, params: params)
        }
        
        if options.showDebugLights {
            DebugLights.draw(
                lights: scene.lighting.lights[0],
                encoder: renderEncoder,
                uniforms: uniforms)
        }
        
        renderEncoder.endEncoding()
    }
}
