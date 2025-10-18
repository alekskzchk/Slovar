//
//  SearchPageView.swift
//  Slovar
//
//  Created by Алексей Козачук on 06.09.2025.
//

import SwiftUI

struct SearchPageView: View {
    @State private var viewModel = SearchViewModel()
    @State var lookupResult: LookupResult?
    @State var isLoading: Bool = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    VStack {
                        Spacer()
                        TooltipView(tooltipMessage: viewModel.errorMessage)
                            .padding(.bottom, 20)
                        LanguageSelectorView(viewModel: viewModel)
                            .task {
                                await viewModel.fetchLanguages()
                            }
                            .disabled(viewModel.isLoadingLanguages)
                        SearchBarView(viewModel: viewModel) { word in
                            isLoading = true
                            if let result = await viewModel.search(word: word) {
                                await MainActor.run {
                                    lookupResult = result
                                    isLoading = false
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
                    .ignoresSafeArea(.all, edges: .top)
                }
                .background(GradientView())
                .navigationDestination(item: $lookupResult) { result in
                    DictionaryEntryView(lookupResult: result)
                }
            }
            
            if isLoading {
                withAnimation(.easeIn) {
                    ZStack {
                        RadialGradient(colors: [.black, .clear], center: .center, startRadius: 900, endRadius: 0)
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(2)
                    }
                    .ignoresSafeArea(.all)
                }
            }
        }
    }
}

#Preview {
    SearchPageView()
}
