import MetalKit
import SwiftUI

struct MetalView: View {
    @State private var metalView = MTKView()
    @State private var gameController: GameController?
    @State private var previousTranslation = CGSize.zero
    @State private var previousScroll: CGFloat = 1

    var body: some View {
        MetalViewRepresentable(gameController: gameController, metalView: $metalView)
            .onAppear {
                gameController = GameController(metalView: metalView)
            }
    }
}

#if os(macOS)
    typealias ViewRepresentable = NSViewRepresentable
#elseif os(iOS)
    typealias ViewRepresentable = UIViewRepresentable
#endif

struct MetalViewRepresentable: ViewRepresentable {
    let gameController: GameController?
    @Binding var metalView: MTKView

    #if os(macOS)
        func makeNSView(context: Context) -> some NSView {
            metalView
        }

        func updateNSView(_ uiView: NSViewType, context: Context) {
            updateMetalView()
        }

    #elseif os(iOS)
        func makeUIView(context: Context) -> MTKView {
            metalView
        }

        func updateUIView(_ uiView: MTKView, context: Context) {
            updateMetalView()
        }
    #endif

    func updateMetalView() {
    }
}

#Preview {
    VStack {
        MetalView()
        Text("Metal View")
    }
}
