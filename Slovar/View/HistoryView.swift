//
//  HistoryView.swift
//  Slovar
//
//  Created by Алексей Козачук on 06.09.2025.
//

import SwiftData
import SwiftUI

struct HistoryView: View {
    var viewModel: HistoryViewModel
    @State var selectedSortOrder: SortingOrder
    init(context: ModelContext) {
        self.viewModel = HistoryViewModel(context: context)
        self.selectedSortOrder = .alphabetical
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.allHistoryItems, id: \.cachedItem.id) { item in
                NavigationLink(value: item) {
                    HStack {
                        Text(item.lookupResult.def.first?.text ?? "")
                        Spacer()
                        Text(viewModel.getLocalizedTargetLangString(for: item.cachedItem.languagePair))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchHistoryItems()
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: { selectedSortOrder = .alphabetical }) {
                            Label("Alphabet", systemImage: selectedSortOrder == .alphabetical ? "checkmark" : "")
                        }
                        Button(action: { selectedSortOrder = .language }) {
                                Label("Language", systemImage: selectedSortOrder == .language ? "checkmark" : "")
                            }
                        Button(action: { selectedSortOrder = .date }) {
                                Label("Date", systemImage: selectedSortOrder == .date ? "checkmark" : "")
                            }
                        Menu("Order") {
                            Button(action: { viewModel.ascendingOrder = true }) {
                                Label("Ascending", systemImage: viewModel.ascendingOrder ? "checkmark" : "")
                                }
                            Button(action: { viewModel.ascendingOrder = false }) {
                                    Label("Descending", systemImage: !viewModel.ascendingOrder ? "checkmark" : "")
                                }
                        }
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                    .onChange(of: selectedSortOrder) {
                        viewModel.sort(order: selectedSortOrder)
                    }
                    .onChange(of: viewModel.ascendingOrder) {
                        viewModel.sort(order: selectedSortOrder)
                    }
                }
            }
            .navigationDestination(for: DictionaryEntryItem.self) { item in
                DictionaryEntryView(lookupResult: item.lookupResult, cachedItem: item.cachedItem)
            }
        }
        
    }
}
