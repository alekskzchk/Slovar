//
//  SubtitleView.swift
//  Slovar
//
//  Created by Алексей Козачук on 07.09.2025.
//

import SwiftUI

struct SubtitleView: View {
    var text: String
    var body: some View {
        Text(String(localized: "\(text)"))
            .font(FontsProvider.garamond(29, relativeTo: .title2, weight: .bold))
            .foregroundStyle(Color(.secondaryLabel))
            .padding(.top, 10)
    }
}

//#Preview {
//    DictionaryEntryView(lookupResult: .fromMockFile())
//}
