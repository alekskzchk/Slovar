//
//  DictionaryEntryView.swift
//  Slovar
//
//  Created by Алексей Козачук on 05.09.2025.
//

import SwiftUI

import SwiftUI

struct DictionaryEntryView: View {
    @Environment(\.dismiss) private var dismiss
    var lookupResult: LookupResult
    var cachedItem: CachedItem?
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .bottom) {
                        DefinitionView(lookupResult: lookupResult, proxy: proxy)
                        WordFeaturesView(word: lookupResult.def.first!)
                            .padding(.trailing, 10)
                    }
                    .frame(maxWidth: proxy.size.width, alignment: .leading)
                    
                    if let definitionTranscription = lookupResult.def.first?.ts {
                        TranscriptionView(transcription: definitionTranscription)
                            .frame(maxWidth: proxy.size.width / 4, alignment: .leading)
                    }
                    
                    if let forms = lookupResult.def.first?.fl {
                        SubtitleView(text: String(localized: "Forms"))
                        Text(forms)
                            .font(FontsProvider.garamond(25, relativeTo: .caption, weight: .semibold))
                            .frame(maxWidth: proxy.size.width, alignment: .leading)
                            .padding(.leading, 20)
                    }
                    
                    if let translations = lookupResult.def.first?.tr {
                        let translationsSortedByFrequency = translations.sorted { $0.fr! < $1.fr! }
                        SubtitleView(text: String(localized: "Translations"))
                        
                        ForEach(translationsSortedByFrequency.enumerated(), id: \.element.id) { index, translation in
                            HStack(alignment: .firstTextBaseline) {
                                Image(systemName: "\(index + 1).circle")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                TranslationView(translation: translation)
                            }
                            .frame(maxWidth: proxy.size.width, alignment: .leading)
                        }
                    }
                }
                .frame(maxWidth: proxy.size.width, alignment: .leading)
                .padding(.leading, 20)
            }
            .toolbar {
                if cachedItem != nil {
                    Button(action: { cachedItem!.isBookmarked.toggle() }) {
                        Label("Alphabet", systemImage: cachedItem!.isBookmarked ? "bookmark.fill" : "bookmark")
                            .foregroundStyle(cachedItem!.isBookmarked ? Color.primary : .red)
                    }
                    
                }
            }
        }
    }
}
//#Preview {
//
//    DictionaryEntryView(lookupResult: .fromMockFile())
//}
