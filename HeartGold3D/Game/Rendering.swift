import MetalKit

extension Model {
    func render(encoder: MTLRenderCommandEncoder,
                uniforms vertex: Uniforms,
                params fragment: Params) {
        var uniforms = vertex
        var params = fragment
        params.tiling = tiling
        uniforms.modelMatrix = transform.modelMatrix
        uniforms.normalMatrix = uniforms.modelMatrix.upperLeft
        
        
        encoder.setVertexBytes(&uniforms, 
                               length: MemoryLayout<Uniforms>.stride,
                               index: UniformsBuffer.index)
        
        encoder.setFragmentBytes(&params,
                                 length: MemoryLayout<Params>.stride,
                                 index: ParamsBuffer.index)
        
        for mesh in meshes {
            for (index, vertexBuffer) in mesh.vertexBuffers.enumerated() {
                encoder.setVertexBuffer(vertexBuffer, offset: 0, index: index)
            }
            for submesh in mesh.submeshes {
                
                encoder.setFragmentTexture(submesh.textures.baseColor, index: BaseColor.index)
                
                encoder.drawIndexedPrimitives(type: .triangle,
                                              indexCount: submesh.indexCount,
                                              indexType: submesh.indexType,
                                              indexBuffer: submesh.indexBuffer,
                                              indexBufferOffset: submesh.indexBufferOffset)
            }
        }
        

    }
}
