import MetalKit

enum DebugLights {
    static let linePipelineState: MTLRenderPipelineState = {
        let library = Renderer.library
        let vertexFunction = library?.makeFunction(name: "vertex_debug")
        let fragmentFunction = library?.makeFunction(name: "fragment_debug_line")
        let psoDescriptor = MTLRenderPipelineDescriptor()
        psoDescriptor.vertexFunction = vertexFunction
        psoDescriptor.fragmentFunction = fragmentFunction
        psoDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        psoDescriptor.depthAttachmentPixelFormat = .depth32Float
        let pipelineState: MTLRenderPipelineState
        do {
            pipelineState = try Renderer.device.makeRenderPipelineState(descriptor: psoDescriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
        return pipelineState
    }()

    static let pointPipelineState: MTLRenderPipelineState = {
        let library = Renderer.library
        let vertexFunction = library?.makeFunction(name: "vertex_debug")
        let fragmentFunction = library?.makeFunction(name: "fragment_debug_point")
        let psoDescriptor = MTLRenderPipelineDescriptor()
        psoDescriptor.vertexFunction = vertexFunction
        psoDescriptor.fragmentFunction = fragmentFunction
        psoDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        psoDescriptor.depthAttachmentPixelFormat = .depth32Float
        let pipelineState: MTLRenderPipelineState
        do {
            pipelineState = try Renderer.device.makeRenderPipelineState(
                descriptor: psoDescriptor
            )
        } catch {
            fatalError(error.localizedDescription)
        }
        return pipelineState
    }()

    static func draw(lights: Light, encoder: MTLRenderCommandEncoder, uniforms: Uniforms) {
        
        encoder.label = "Debug lights"

                debugDrawDirection(
                    renderEncoder: encoder,
                    uniforms: uniforms,
                    direction: lights.position,
                    color: [1, 0, 0],
                    count: 5)
    }

    static func debugDrawPoint(
        encoder: MTLRenderCommandEncoder,
        uniforms: Uniforms,
        position: SIMD3<Float>,
        color: SIMD3<Float>
    ) {
        var vertices = [position]
        encoder.setVertexBytes(&vertices, length: MemoryLayout<SIMD3<Float>>.stride, index: 0)
        var uniforms = uniforms
        uniforms.modelMatrix = .identity
        encoder.setVertexBytes(
            &uniforms,
            length: MemoryLayout<Uniforms>.stride,
            index: UniformsBuffer.index)
        var lightColor = color
        encoder.setFragmentBytes(
            &lightColor,
            length: MemoryLayout<SIMD3<Float>>.stride,
            index: 1)
        encoder.setRenderPipelineState(pointPipelineState)
        encoder.drawPrimitives(
            type: .point,
            vertexStart: 0,
            vertexCount: vertices.count)
    }

    static func debugDrawDirection(
        renderEncoder: MTLRenderCommandEncoder,
        uniforms: Uniforms,
        direction: SIMD3<Float>,
        color: SIMD3<Float>,
        count: Int
    ) {
        var vertices: [SIMD3<Float>] = []
        for index in -count ..< count {
            let value = Float(index) * 0.4
            vertices.append(SIMD3<Float>(value, 0, value))
            vertices.append(
                SIMD3<Float>(
                    direction.x + value,
                    direction.y,
                    direction.z + value))
        }
        let buffer = Renderer.device.makeBuffer(
            bytes: &vertices,
            length: MemoryLayout<SIMD3<Float>>.stride * vertices.count,
            options: [])
        var uniforms = uniforms
        uniforms.modelMatrix = .identity
        renderEncoder.setVertexBytes(
            &uniforms,
            length: MemoryLayout<Uniforms>.stride,
            index: UniformsBuffer.index)
        var lightColor = color
        renderEncoder.setFragmentBytes(&lightColor, length: MemoryLayout<SIMD3<Float>>.stride, index: 1)
        renderEncoder.setVertexBuffer(buffer, offset: 0, index: 0)
        renderEncoder.setRenderPipelineState(linePipelineState)
        renderEncoder.drawPrimitives(
            type: .line,
            vertexStart: 0,
            vertexCount: vertices.count)
    }

    static func debugDrawLine(
        renderEncoder: MTLRenderCommandEncoder,
        uniforms: Uniforms,
        position: SIMD3<Float>,
        direction: SIMD3<Float>,
        color: SIMD3<Float>
    ) {
        var vertices: [SIMD3<Float>] = []
        vertices.append(position)
        vertices.append(SIMD3<Float>(
            position.x + direction.x,
            position.y + direction.y,
            position.z + direction.z))
        let buffer = Renderer.device.makeBuffer(
            bytes: &vertices,
            length: MemoryLayout<SIMD3<Float>>.stride * vertices.count,
            options: [])
        var uniforms = uniforms
        uniforms.modelMatrix = .identity
        renderEncoder.setVertexBytes(
            &uniforms,
            length: MemoryLayout<Uniforms>.stride,
            index: UniformsBuffer.index)
        var lightColor = color
        renderEncoder.setFragmentBytes(&lightColor, length: MemoryLayout<SIMD3<Float>>.stride, index: 1)
        renderEncoder.setVertexBuffer(buffer, offset: 0, index: 0)
        // render line
        renderEncoder.setRenderPipelineState(linePipelineState)
        renderEncoder.drawPrimitives(
            type: .line,
            vertexStart: 0,
            vertexCount: vertices.count)
        // render starting point
        renderEncoder.setRenderPipelineState(pointPipelineState)
        renderEncoder.drawPrimitives(
            type: .point,
            vertexStart: 0,
            vertexCount: 1)
    }
}
