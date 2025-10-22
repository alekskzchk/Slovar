//
//  HistoryView.swift
//  Slovar
//
//  Created by Алексей Козачук on 06.09.2025.
//

import SwiftData
import SwiftUI

struct CachedItemsView: View {
    var viewModel: CachedItemsVM
    @State var selectedSortOrder: SortOrder
    private var title: String
    init(context: ModelContext, type: CachedVMType) {
        self.viewModel = CachedItemsVM(context: context, type: type)
        self.selectedSortOrder = .alphabet
        switch type {
            case .history:
            self.title = "History"
        case .bookmarks:
            self.title = "Bookmarks"
        }
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.items, id: \.cachedItem.id) { item in
                NavigationLink(value: item) {
                    HStack {
                        Text(item.lookupResult.def.first?.text ?? "")
                        Spacer()
                        Text(viewModel.localizedTargetLangString(for: item.cachedItem.languagePair))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchItems()
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: { selectedSortOrder = .alphabet }) {
                            Label("Alphabet", systemImage: selectedSortOrder == .alphabet ? "checkmark" : "")
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
