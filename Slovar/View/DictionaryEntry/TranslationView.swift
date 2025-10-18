//
//  TranslationView.swift
//  Slovar
//
//  Created by Алексей Козачук on 07.09.2025.
//

import SwiftUI

struct TranslationView: View {
    let translation: Word
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom, spacing: 5) {
                Text(translation.text)
                    .font(FontsProvider.garamond(18, relativeTo: .title3, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(alignment: .leading)
                WordFeaturesView(word: translation)
            }
            
            if let synonyms = translation.syn {
                VStack(alignment: .leading) {
                    ForEach(synonyms) { synonym in
                        HStack(alignment: .bottom, spacing: 5) {
                            Text(synonym.text)
                                .font(FontsProvider.garamond(16, relativeTo: .caption2, weight: .semibold, italic: true))
                                .frame(alignment: .leading)
                            WordFeaturesView(word: synonym)
                                .scaleEffect(0.5, anchor: .bottomLeading)
                        }
                        
                    }
                }
                .padding(.leading, 20)
            }
        }
    }
}

#Preview {
    DictionaryEntryView(lookupResult: .fromMockFile())
}
