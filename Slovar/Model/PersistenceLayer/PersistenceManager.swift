//
//  PersistenceManager.swift
//  Slovar
//
//  Created by Алексей Козачук on 06.09.2025.
//

import Foundation
import SwiftData

@MainActor
final class PersistenceManager {
    static let shared = PersistenceManager()
    let container: ModelContainer
    
    private init() {
        container = try! ModelContainer(for:
            SearchHistoryItem.self,
            CachedEntry.self,
            FavoriteWord.self,
            LastLanguagePair.self,
            AppSettings.self,
            CachedLanguagePairs.self
        )
    }
    
    func setHistory(word: String, sourceLanguageId: String, targetLanguageId: String) {
        let item = SearchHistoryItem(word: word, timestamp: .now, sourceLanguageId: sourceLanguageId, targetLanguageId: targetLanguageId)
        container.mainContext.insert(item)
        try? container.mainContext.save()
    }
    
    func getHistory() -> [SearchHistoryItem] {
        try! container.mainContext.fetch(FetchDescriptor<SearchHistoryItem>())
    }
    
    func getCachedEntry(for word: String) -> CachedEntry? {
        let request = FetchDescriptor<CachedEntry>(predicate: #Predicate { $0.word == word })
        return try? container.mainContext.fetch(request).first
    }
    
    func saveCachedEntry(word: String, result: Data) {
        if let existing = getCachedEntry(for: word) {
            return
        } else {
            let entry = CachedEntry(word: word, lookupResult: result)
            container.mainContext.insert(entry)
            try? container.mainContext.save()
        }
    }
    
    func getLastLanguagePair() -> LastLanguagePair? {
            try? container.mainContext.fetch(FetchDescriptor<LastLanguagePair>()).first
        }
    
    func setLastLanguagePair(sourceId: String, targetId: String) {
        let lastPair = LastLanguagePair(sourceLanguageId: sourceId, targetLanguageId: targetId)
        container.mainContext.insert(lastPair)
        try? container.mainContext.save()
    }
    
    func getCachedLanguagePairs() async -> CachedLanguagePairs? {
        let cachedPairs = try? container.mainContext.fetch(FetchDescriptor<CachedLanguagePairs>()).first
        return cachedPairs
    }
    
    func setCachedLanguagePairs(_ pairs: [String]) {
        let cachedPairs = CachedLanguagePairs(languagePairs: pairs, dateOfLastFetch: .now)
        container.mainContext.insert(cachedPairs)
        try? container.mainContext.save()
    }
    
    func getSetting<T: Codable>(key: String, type: T.Type) -> T? {
        let request = FetchDescriptor<AppSettings>(
            predicate: #Predicate { (obj: AppSettings) in obj.key == key }
        )
        
        guard let data = try? container.mainContext.fetch(request).first?.value else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func setSetting<T: Codable>(key: String, value: T) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        let request = FetchDescriptor<AppSettings>(
            predicate: #Predicate { (obj: AppSettings) in obj.key == key }
            )
        if let existing = try? container.mainContext.fetch(request).first {
            existing.value = data
        } else {
            let setting = AppSettings(key: key, value: data)
            container.mainContext.insert(setting)
        }
        try? container.mainContext.save()
    }

}
