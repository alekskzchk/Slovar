//
//  Models.swift
//  Slovar
//
//  Created by Алексей Козачук on 06.09.2025.
//

import Foundation
import SwiftData

@Model
final class SearchHistoryItem {
    var word: String
    var timestamp: Date
    var sourceLanguageId: String
    var targetLanguageId: String
    
    init(word: String, timestamp: Date, sourceLanguageId: String, targetLanguageId: String) {
        self.word = word
        self.timestamp = timestamp
        self.sourceLanguageId = sourceLanguageId
        self.targetLanguageId = targetLanguageId
    }
}

@Model
final class CachedEntry {
    var word: String
    var lookupResult: Data
    
    init(word: String, lookupResult: Data) {
        self.word = word
        self.lookupResult = lookupResult
    }
}

@Model
final class FavoriteWord {
    var word: String
    var sourceLanguageId: String
    var targetLanguageId: String
    
    init(word: String, sourceLanguageId: String, targetLanguageId: String) {
        self.word = word
        self.sourceLanguageId = sourceLanguageId
        self.targetLanguageId = targetLanguageId
    }
}

@Model
final class LastLanguagePair {
    var sourceLanguageId: String
    var targetLanguageId: String
    
    init(sourceLanguageId: String, targetLanguageId: String) {
        self.sourceLanguageId = sourceLanguageId
        self.targetLanguageId = targetLanguageId
    }
}

@Model
final class CachedLanguagePairs {
    var languagePairs: [String]
    var dateOfLastFetch: Date
    
    init(languagePairs: [String], dateOfLastFetch: Date) {
        self.languagePairs = languagePairs
        self.dateOfLastFetch = dateOfLastFetch
    }
}

@Model
final class AppSettings {
    var key: String
    var value: Data
    
    init(key: String, value: Data) {
        self.key = key
        self.value = value
    }
}
