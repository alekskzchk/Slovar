//
//  Picker.swift
//  Slovar
//
//  Created by Алексей Козачук on 06.09.2025.
//

import SwiftUI

struct LanguagePicker: View {
    var viewModel: SearchViewModel
    let isSourcePicker: Bool

    var body: some View {
        Menu {
            if viewModel.selectedTarget != nil && isSourcePicker {
                Button(action: { viewModel.selectedTarget = nil }, label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Clear target")
                    }
                })
            } else if viewModel.selectedSource != nil && !isSourcePicker {
                Button(action: { viewModel.selectedSource = nil }, label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Clear source")
                    }
                })
            }
                
            ForEach(viewModel.allLanguages) { language in
                var isCompatible: Bool {
                    if isSourcePicker {
                        viewModel.selectedTarget?.possiblePairsIds.contains(language.id) ?? true
                    } else {
                        viewModel.selectedSource?.possiblePairsIds.contains(language.id) ?? true
                    }
                }

                Button {
                    if isSourcePicker {
                        viewModel.selectedSource = language
                    } else {
                        viewModel.selectedTarget = language
                    }
                } label: {
                    HStack {
                        if isSourcePicker && viewModel.selectedSource?.id == language.id || !isSourcePicker && viewModel.selectedTarget?.id == language.id {
                            Image(systemName: "checkmark")
                        }
                        Text(language.name.capitalized)
                    }
                }
                .disabled(!isCompatible)
            }
        } label: {
            HStack {
                if isSourcePicker {
                    Spacer()
                    Text(viewModel.selectedSource?.name.capitalized ?? String(localized: "From"))
                        .padding(.horizontal, 5)
                    Spacer()
                } else {
                    Spacer()
                    Text(viewModel.selectedTarget?.name.capitalized ?? String(localized: "To"))
                        .padding(.horizontal, 5)
                    Spacer()
                }
            }
            
            .frame(minHeight: 40)
            .glassEffect(.regular.interactive())
            .disabled(viewModel.allLanguages.isEmpty)
        }
        
        
    }
}
