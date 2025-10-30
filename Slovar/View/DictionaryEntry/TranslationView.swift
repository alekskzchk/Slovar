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
                    .font(FontsProvider.garamond(24, relativeTo: .title3, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(alignment: .leading)
                WordFeaturesView(word: translation)
                    .scaleEffect(0.8, anchor: .bottomLeading)
                    .padding(.bottom, 2)
            }
            
            if let synonyms = translation.syn {
                VStack(alignment: .leading) {
                    ForEach(synonyms) { synonym in
                        HStack(alignment: .bottom, spacing: 5) {
                            Text(synonym.text)
                                .font(FontsProvider.garamond(18, relativeTo: .caption2, weight: .semibold, italic: true))
                                .frame(alignment: .leading)
                            WordFeaturesView(word: synonym)
                                .scaleEffect(0.7, anchor: .bottomLeading)
                                .padding(.bottom, 1)
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
