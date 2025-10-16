//
//  TranscriptionView.swift
//  Slovar
//
//  Created by Алексей Козачук on 07.09.2025.
//

import SwiftUI

struct TranscriptionView: View {
    var transcription: String
    var body: some View {
        Text("[\(transcription)]")
            .font(FontsProvider.garamond(22, relativeTo: .caption2, weight: .semibold))
            .foregroundStyle(Color(.secondaryLabel))
            .lineLimit(1)
            .minimumScaleFactor(0.5)
    }
}

#Preview {
    DictionaryEntryView(lookupResult: .fromMockFile())
}
