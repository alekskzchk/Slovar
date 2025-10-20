//
//  LanguagePairSelectionView.swift
//  Slovar
//
//  Created by Алексей Козачук on 05.09.2025.
//

import SwiftUI

struct LanguageSelectorView: View {
    var viewModel: SearchViewModel
    
    var body: some View {
        GeometryReader { geometry in
            GlassEffectContainer {
                HStack(spacing: 10) {
                    LanguagePicker(viewModel: viewModel, isSourcePicker: true)
                        .frame(
                            minWidth: geometry.size.width / 3,
                            alignment: .leading
                        )
                        .padding(.leading, 10)
                    
                    Button(action: viewModel.swap) {
                        Image(systemName: viewModel.canSwap ? "arrow.left.arrow.right" : "arrow.right")
                            .font(.title3)
                            .transition(.scale.combined(with: .opacity))
                    }
                    .frame(width: 40, height: 40)
                    .disabled(!viewModel.canSwap)
                    .glassEffect(.regular.interactive(viewModel.canSwap))
                    
                    LanguagePicker(viewModel: viewModel, isSourcePicker: false)
                        .frame(
                            minWidth: geometry.size.width / 3,
                            alignment: .trailing
                        )
                        .padding(.trailing, 10)
                }
                .animation(.easeInOut, value: viewModel.canSwap)
            }
        }
        .frame(height: 40)
    }
    
}

//#Preview {
//    let mockViewModel = SearchViewModel()
//    return LanguageSelectorView(viewModel: mockViewModel)
//}
