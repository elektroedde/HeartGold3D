//
//  ContentView.swift
//  HeartGold3D
//
//  Created by Edvin Berling on 2024-03-28.
//

import SwiftUI

struct ContentView: View {
    @State private var options = Options()

    var body: some View {
        ZStack {
            MetalView(options: options).ignoresSafeArea()

            OptionView(options: $options)
        }.statusBar(hidden: true)
    }
}

#Preview {
    ContentView()
}

struct OptionView: View {
    #if os(macOS)
        var width: CGFloat = 150
        var height: CGFloat = 100
    #elseif os(iOS)
        var width: CGFloat = 200
        var height: CGFloat = 150
    #endif
    @Binding var options: Options
    var body: some View {
        HStack {
            VStack {
                Rectangle()
                    .cornerRadius(10.0)
                    .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0, opacity: 0.4))
                    .frame(width: width, height: height)
                    .overlay(
                        HStack {
                            VStack(spacing: 10) {
                                HStack {
                                    Toggle("Wireframe", isOn: $options.showWireframe).padding(.leading, 10)
                                    Spacer()
                                }
                                HStack {
                                    Toggle("Debug lights", isOn: $options.showDebugLights).padding(.leading, 10)
                                    Spacer()
                                }
                                
                                Slider(value: $options.angle)
                            }
                        }
                    )
                Spacer()
            }
            .padding(.leading, 5)
            .padding(.top, 5)

            Spacer()
        }
    }
}
