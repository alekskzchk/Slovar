//
//  AnimatedGradientView.swift
//  MultiplicationTable
//
//  Created by Алексей Козачук on 08.03.2025.
//

import SwiftUI

struct AnimatedGradientView: View {
    @State private var expand = false
    var color1: Color
    var color2: Color
    var color3: Color
    var duration: Double
    
    init(color1: Color, color2: Color, color3: Color, duration: Double) {
        self.color1 = color1
        self.color2 = color2
        self.color3 = color3
        self.duration = duration
    }
    
    var body: some View {
        RadialGradient(gradient: Gradient(colors: [color1, color2, color3]),
                       center: expand ? .bottom : .top,
                       startRadius: 100,
                       endRadius: 500)
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                    expand.toggle()
                }
            }
    }
}
