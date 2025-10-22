//
//  SearchBarView.swift
//  Slovar
//
//  Created by Алексей Козачук on 05.09.2025.
//

import SwiftData
import SwiftUI
import Observation

struct SearchBarView: View {
    var placeholder = String(localized: "Search")
    var viewModel: SearchViewModel
    var searchButtonTapped: (String) async -> Void
    @State var searchBarText: String = ""
    @State var searchResult: LookupResult?
    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        GeometryReader { proxy in
            HStack {
                GlassEffectContainer {
                    HStack(spacing: 10) {
                        if searchBarText.isEmpty {
                            Button {
                                if let clipboard = UIPasteboard.general.string {
                                    searchBarText = clipboard
                                }
                            } label: {
                                Image(systemName: "document.on.clipboard")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 40, height: 40)
                            .glassEffect(.regular)
                        } else {
                            Button {
                                searchBarText = ""
                            } label: {
                                Image(systemName: "trash")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 40, height: 40)
                            .glassEffect(.regular.tint(.red.opacity(0.5)))
                        }
                        
                        TextField(placeholder, text: $searchBarText)
                            .onSubmit { submit(text: searchBarText) }
                            .onChange(of: searchBarText) {
                                withAnimation {
                                    viewModel.errorMessage = nil
                                }
                            }
                        
                            .focused($isFocused)
                            .task { await MainActor.run {
                                isFocused = true
                            }
                            }
                            .onChange(of: proxy.size.width) {
                                isFocused = false
                                isFocused = true
                            } //custom keyboards may cause unexpected layout issues, so that was made to address such behavior
                            .toolbar {
                                if isFocused {
                                    Button {
                                        isFocused = false
                                    } label: {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .ignoresSafeArea(.keyboard, edges: .bottom)
                            .glassEffect(.regular.interactive())
                        Button {
                            submit(text: searchBarText)
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.title3)
                        }
                        .disabled(viewModel.isLoadingLanguages || searchBarText.isEmpty)
                        .frame(width: 40, height: 40)
                        .glassEffect(.regular.interactive(!viewModel.isLoadingLanguages && !searchBarText.isEmpty))
                        
                    }
                }
            }
        }
        .frame(maxHeight: 50)
    }
    private func submit(text: String) {
        isFocused = false
        Task {
            await searchButtonTapped(searchBarText)
        }
    }
}

//#Preview {
//    if let config = try? ModelConfiguration(isStoredInMemoryOnly: true),
//       let container = try? ModelContainer(for: CachedItem.self, configurations: config) {
//        let mockViewModel = SearchViewModel(modelContext: container)
//        mockViewModel.modelContext(container)
//        mockViewModel.allLanguages = [
//            Language(id: "en", name: "English", possiblePairsIds: ["ru", "fr"]),
//            Language(id: "ru", name: "Русский", possiblePairsIds: ["en"]),
//            Language(id: "fr", name: "Français", possiblePairsIds: ["en"]),
//            Language(id: "pt", name: "Brazilian Portuguese", possiblePairsIds: ["en", "ru", "fr"])
//        ]
//        
//        SearchBarView(viewModel: mockViewModel, searchButtonTapped: {_ in })
//            
//    }
//}
