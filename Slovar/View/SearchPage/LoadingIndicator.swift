//
//  LoadingIndicator.swift
//  Slovar
//
//  Created by Алексей Козачук on 18.10.2025.
//

import SwiftUI

struct LoadingIndicator: View {
    var body: some View {
        withAnimation(.easeIn) {
            ZStack {
                RadialGradient(colors: [.black, .clear], center: .center, startRadius: 900, endRadius: 0)
                Color(.black.opacity(0.7))
                    .frame(width: 100, height: 100)
                    .cornerRadius(15)
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(2)
                    .tint(.white)
            }
            .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    LoadingIndicator()
}
