//
//  TabBarView.swift
//  Slovar
//
//  Created by Алексей Козачук on 06.09.2025.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Tab = .search
    
    enum Tab {
        case search, history, bookmarks, settings
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SearchPageView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(Tab.search)
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                .tag(Tab.history)
            BookmarksView()
                .tabItem {
                    Label("Bookmarks", systemImage: "book")
                }
                .tag(Tab.bookmarks)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(Tab.settings)
        }
    }
}

#Preview {
    TabBarView()
}
