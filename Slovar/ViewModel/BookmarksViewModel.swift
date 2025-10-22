//
//  BookmarksViewModel.swift
//  Slovar
//
//  Created by Алексей Козачук on 22.10.2025.
//

import Observation
import SwiftData
import SwiftUI

@MainActor
@Observable
class BookmarksViewModel {
    private let persistenceManager: PersistenceManager
    var bookmarkedItems = [DictionaryEntryItem]()
    var ascendingOrder: Bool = true
    
    
    init(context: ModelContext) {
        self.persistenceManager = PersistenceManager(context: context)
    }
    
    func fetchHistoryItems() async {
        guard let cachedItems = await persistenceManager.fetchAllCachedItems() else { return }
        bookmarkedItems.removeAll()
        for item in cachedItems {
            if let lookupResult = persistenceManager.fetchFromCache(id: item.id).1 {
                if item.isBookmarked {
                    self.bookmarkedItems.append(DictionaryEntryItem(lookupResult: lookupResult, cachedItem: item))
                }
                
            }
        }
        sort(order: .date)
    }
    
    func sort(order: SortingOrder) {
        bookmarkedItems.sort(by: {
            switch order {
            case .alphabetical:
                let a = $0.lookupResult.def.first?.text ?? ""
                let b = $1.lookupResult.def.first?.text ?? ""
                return ascendingOrder ? a < b : a > b
            case .date:
                let a = $0.cachedItem.lastSearchDate
                let b = $1.cachedItem.lastSearchDate
                return ascendingOrder ? a < b : a > b
            case .language:
                let a = getLocalizedTargetLangString(for: $0.cachedItem.languagePair)
                let b = getLocalizedTargetLangString(for: $1.cachedItem.languagePair)
                return ascendingOrder ? a < b : a > b
            }
        })
    }
    
    func getLocalizedTargetLangString(for languagePair: String) -> String {
        let targetLanguageId = String(languagePair.split(separator: "-").last!)
        return Locale.current.localizedString(forIdentifier: targetLanguageId) ?? "N/A"
    }
}
