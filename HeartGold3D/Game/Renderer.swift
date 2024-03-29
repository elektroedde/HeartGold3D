import MetalKit

class Renderer: NSObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    var mesh: MTKMesh!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    var time: Float = 0
    var uniforms = Uniforms()
    
    lazy var model: Model = {
        Model(device: Renderer.device, name: "typhlosion")
    }()

    init(metalView: MTKView) {
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
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragment_main")


        // Create the pipeline state
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultLayout

        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        super.init()

        metalView.clearColor = MTLClearColor(red: 1.0, green: 0.3, blue: 1.0, alpha: 1.0)
        metalView.delegate = self
        

        
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        let aspect = Float(view.bounds.width) / Float(view.bounds.height)
        let projectionMatrix = float4x4(projectionFov: Float(70).degreesToRadians,
                                        near: 0.1,
                                        far: 100,
                                        aspect: aspect)
        uniforms.projectionMatrix = projectionMatrix
    }

    func draw(in view: MTKView) {
        guard
            let commandBuffer = Self.commandQueue.makeCommandBuffer(),
            let descriptor = view.currentRenderPassDescriptor,
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else { return }
        
        time += 0.05
//        var test = sin(time)
        
        uniforms.viewMatrix = float4x4(translation: [0, 0, -4]).inverse
        
        
        model.position.y = -0.6
        model.rotation.y = sin(time)
        model.scale = 0.01
        
        uniforms.modelMatrix = model.transform.modelMatrix
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 11)

        model.render(encoder: renderEncoder)
        
        
        renderEncoder.endEncoding()
        
        guard let drawable = view.currentDrawable
        else { return }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}


//For primitives
//        let size: Float = 0.8
//        let mdlMesh = MDLMesh(boxWithExtent: SIMD3<Float>(repeating: size), segments: [1, 1, 1], inwardNormals: false, geometryType: .triangles, allocator: allocator)

//renderEncoder.setVertexBytes(&test, length: MemoryLayout<Float>.stride, index: 1)
//
//        renderEncoder.setRenderPipelineState(pipelineState)
//        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
//        for submesh in mesh.submeshes {
//            renderEncoder.drawIndexedPrimitives(type: .triangle,
//                                                indexCount: submesh.indexCount,
//                                                indexType: submesh.indexType,
//                                                indexBuffer: submesh.indexBuffer.buffer,
//                                                indexBufferOffset: submesh.indexBuffer.offset)
//        }
