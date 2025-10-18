//
//  TooltipView.swift
//  Slovar
//
//  Created by Алексей Козачук on 15.09.2025.
//

import SwiftUI

struct TooltipView: View {
    var tooltipMessage: String?
   @State var isShaking = false
    @State var alpha: Double = 0
    var body: some View {
        ZStack {
            if let message = tooltipMessage {
                Text(message)
                    .font(Font.callout.bold())
                    .foregroundStyle(.red)
                    .shadow(radius: 10)
                    .modifier(ShakeEffect(animatableData: CGFloat(isShaking ? 1 : 0)))
                    .opacity(alpha)
                    .onAppear {
                        shake()
                    }
                    .onChange(of: tooltipMessage) { _, _ in
                        shake()
                    }
            } else {
                EmptyView()
            }
        }
        .frame(height: 10)
    }
    
    private func shake() {
        withAnimation {
            isShaking = true
            alpha = 1
        }
        Task {
            try await Task.sleep(nanoseconds: 3000000000)
            isShaking = false
        }
    }
    
    }
        


#Preview {
    TooltipView(tooltipMessage: "Entered word is too long")
}
