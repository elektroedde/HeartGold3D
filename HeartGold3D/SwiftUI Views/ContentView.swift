//
//  ContentView.swift
//  HeartGold3D
//
//  Created by Edvin Berling on 2024-03-28.
//

import SwiftUI

struct ContentView: View {
    @State private var temp = false
    var body: some View {
//        ZStack {
//            if !temp {
//                MetalView()
//            }
//            
//            Spacer()
//            HStack {
//                Toggle("Test", isOn: $temp)
//                Toggle("Test", isOn: $temp)
//                Toggle("Test", isOn: $temp)
//                Toggle("Test", isOn: $temp)
//            }
//            
//        }
        MetalView()
        
    }
}

#Preview {
    ContentView()
}
