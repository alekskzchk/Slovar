//
//  SlovarApp.swift
//  Slovar
//
//  Created by Алексей Козачук on 04.09.2025.
//

import SwiftUI
import SwiftData

@main
struct SlovarApp: App {
    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
        .modelContainer(for: CachedItem.self)
    }
}
