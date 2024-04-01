import SwiftUI
import Observation

@Observable
class Options {
    var showWireframe: Bool = false
    var showDebugLights: Bool = false
    var option3: Bool = true
    var angle: Float = 0.5
}
