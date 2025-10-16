//
//  WordFeaturesView.swift
//  Slovar
//
//  Created by Алексей Козачук on 07.09.2025.
//

import SwiftUI

struct WordFeaturesView: View {
    let word: Word
    private var features: [String] {
        var arr: [String] = []
        if let gender = word.gen { arr.append("\(gender).") }
        if let animacy = word.anm { arr.append("\(animacy).") }
        if let partOfSpeech = word.pos { arr.append(partOfSpeech) }
        return arr
    }
    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(features, id: \.self) { feature in
                Text(feature)
                    .font(FontsProvider.garamond(16, relativeTo: .callout, weight: .regular))
                    .foregroundStyle(Color(.secondaryLabel))
                    .padding([.leading, .trailing], 2)
            }
        }
    }
}

#Preview {
    DictionaryEntryView(lookupResult: .fromMockFile())
}
