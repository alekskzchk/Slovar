//
//  AnimatedGradientView.swift
//  MultiplicationTable
//
//  Created by Алексей Козачук on 08.03.2025.
//

import SwiftUI

struct GradientView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isVisible = false
    @State private var imageIndex = Int.random(in: 1...12)
    
    var body: some View {
        Image("Background Gradients/\(colorScheme == .dark ? "Dark" : "Light")/gradient\(imageIndex)")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(isVisible ? 1 : 0.001)
            .onAppear {
                withAnimation(.easeInOut(duration: 2)) {
                    isVisible = true
                }
            }
    }
}

#Preview {
    GradientView()
}
