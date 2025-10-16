//
//  HistoryView.swift
//  Slovar
//
//  Created by Алексей Козачук on 06.09.2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section("Preferences") {
                Toggle("Open keyboard on launch", isOn: .constant(false))
                Toggle("Remember selected languages", isOn: .constant(true))
                Toggle("Do not record history", isOn: .constant(true))
                Picker("Theme", selection: .constant("Light")) {
                    Text("Light")
                    Text("Dark")
                    Text("System")
                }
                Button("Clean cache", role: .destructive, action: {})
                Button("About") {}
            }
        }
    }
}

#Preview {
    SettingsView()
}
