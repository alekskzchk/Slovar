//
//  TabBarView.swift
//  Slovar
//
//  Created by Алексей Козачук on 06.09.2025.
//

import SwiftUI

struct TabBarView: View {
    @Environment(\.modelContext) var modelContext
    @State private var selectedTab: Tab = .search
    
    enum Tab {
        case search, history, bookmarks, settings
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SearchPageView(modelContext: modelContext)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(Tab.search)
            CachedItemsView(context: modelContext, type: .history)
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                .tag(Tab.history)
            CachedItemsView(context: modelContext, type: .bookmarks)
                .tabItem {
                    Label("Bookmarks", systemImage: "book")
                }
                .tag(Tab.bookmarks)
        }
    }
}

#Preview {
    TabBarView()
}
