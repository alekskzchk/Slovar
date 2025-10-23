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
    private var title: String
    init(context: ModelContext, type: CachedVMType) {
        self.viewModel = CachedItemsVM(context: context, type: type)
        switch type {
            case .history:
            self.title = "History"
        case .bookmarks:
            self.title = "Bookmarks"
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
            ForEach(viewModel.items, id: \.cachedItem.id) { item in
                NavigationLink(value: item) {
                    HStack {
                        Text(item.lookupResult.def.first?.text ?? "")
                        Spacer()
                        Text(viewModel.localizedTargetLangString(for: item.cachedItem.languagePair))
                            .foregroundStyle(.secondary)
                    }
                }
                
            }
            .onDelete(perform: viewModel.deleteCachedItem)
        }
            .onAppear {
                Task {
                    await viewModel.fetchItems()
                    viewModel.sort()
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: { viewModel.sortOrder = .alphabet }) {
                            Label("Alphabet", systemImage: viewModel.sortOrder == .alphabet ? "checkmark" : "")
                        }
                        Button(action: { viewModel.sortOrder = .language }) {
                            Label("Language", systemImage: viewModel.sortOrder == .language ? "checkmark" : "")
                        }
                        Button(action: { viewModel.sortOrder = .date }) {
                            Label("Date", systemImage: viewModel.sortOrder == .date ? "checkmark" : "")
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
                    .onChange(of: viewModel.sortOrder) {
                        viewModel.sort()
                    }
                    .onChange(of: viewModel.ascendingOrder) {
                        viewModel.sort()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .navigationDestination(for: DictionaryEntryItem.self) { item in
                DictionaryEntryView(lookupResult: item.lookupResult, cachedItem: item.cachedItem)
            }
        }
    }
}
