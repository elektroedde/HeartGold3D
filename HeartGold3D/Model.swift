import MetalKit

class Model: Transformable {
    let mesh: MTKMesh
    let name: String
    var transform = Transform()
    
    init(device: MTLDevice, name: String) {
        guard let assetURL = Bundle.main.url(forResource: "\(name)", withExtension: "usdz")
        else{ fatalError("Model: \(name) not found") }
        
        let allocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: assetURL, 
                             vertexDescriptor: .defaultLayout,
                             bufferAllocator: allocator)
        
        if let mdlMesh = asset.childObjects(of: MDLMesh.self).first as? MDLMesh {
            do {
                mesh = try MTKMesh(mesh: mdlMesh, device: device)
            } catch { fatalError("Failed to load mesh") }
        } else { fatalError("No mesh available") }
        
        self.name = name
    }
}
