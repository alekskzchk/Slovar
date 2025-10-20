//
//  PersistenceManager.swift
//  Slovar
//
//  Created by Алексей Козачук on 06.09.2025.
//

import SwiftData
import Foundation

struct PersistenceManager {
    let context: ModelContext
    
    func makeCacheItemId(sourceLang: Language, targetLang: Language, userPrompt: String) -> String {
        let refinedUserPrompt = userPrompt
            .lowercased()
            .filter { $0.isLetter || $0.isWhitespace }
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let id = refinedUserPrompt + "|\(sourceLang.id)-\(targetLang.id)"
        print("Made id: \(id)")
        return id
    }
    
    func fetchFromCache(id: String) async -> (CachedItem?, LookupResult?) {
        let descriptor = FetchDescriptor<CachedItem>(
            predicate: #Predicate { $0.id == id }
        )
        guard let cachedItem = try? context.fetch(descriptor).first,
              let lookupResult = try? JSONDecoder().decode(LookupResult.self, from: cachedItem.json)
        else { return (nil, nil) }
        
        print("Got from cache")
        return (cachedItem, lookupResult)
    }
    
    func saveToCache(id: String, lookupResult: LookupResult) {
        if let data = try? JSONEncoder().encode(lookupResult) {
            let cachedItem = CachedItem(
                id: id,
                lookupResultData: data,
                lastSearchDate: .now,
                isBookmarked: false,
                showInHistory: true
            )
            context.insert(cachedItem)
            try? context.save()
            print("Saved to cache")
        } else {
            fatalError("Failed to create CachedItem object encoding lookupResult")
        }
    }
    
    func saveLangs(_ langs: [String]) {
        let cachedLangs = CachedLangs(langs: langs)
        context.insert(cachedLangs)
        try? context.save()
        print("langs saved to cache")
    }
    
    func fetchCachedLangs() async -> [String]? {
        let descriptor = FetchDescriptor<CachedLangs>()
        guard let cachedLangs = try? context.fetch(descriptor).first else { return nil }
        return cachedLangs.langs
    }
}
