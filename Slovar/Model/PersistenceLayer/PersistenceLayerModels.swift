//
//  Models.swift
//  Slovar
//
//  Created by Алексей Козачук on 06.09.2025.
//

import Foundation
import SwiftData

@Model
class CachedItem: Identifiable {
    var id: String
    var json: Data
    var languagePair: String
    var lastSearchDate: Date
    var isBookmarked: Bool
    
    init(id: String,
         json: Data,
         languagePair: String,
         lastSearchDate: Date,
         isBookmarked: Bool) {
        self.id = id
        self.json = json
        self.languagePair = languagePair
        self.lastSearchDate = lastSearchDate
        self.isBookmarked = isBookmarked
    }
}

@Model
class CachedLangs {
    var langs: [String]
    
    init(langs: [String]) {
        self.langs = langs
    }
}

@Model
class LangPair {
    var source: Language
    var target: Language
    
    init(source: Language, target: Language) {
        self.source = source
        self.target = target
    }
}

struct DictionaryEntryItem: Hashable {
    var lookupResult: LookupResult
    var cachedItem: CachedItem
}
