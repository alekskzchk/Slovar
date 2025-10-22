//
//  CachedItemsHandler.swift
//  Slovar
//
//  Created by Алексей Козачук on 23.10.2025.
//

import Observation
import SwiftData
import SwiftUI

enum SortOrder {
    case alphabet, date, language
}

enum CachedVMType {
    case history, bookmarks
}

@MainActor
@Observable
class CachedItemsVM {
    let persistenceManager: PersistenceManager
    var items = [DictionaryEntryItem]()
    var ascendingOrder: Bool = true
    private var selfType: CachedVMType
    init(context: ModelContext, type: CachedVMType) {
        self.persistenceManager = PersistenceManager(context: context)
        self.selfType = type
    }
    
    func fetchItems() async {
            guard let cachedItems = await persistenceManager.fetchAllCachedItems() else { return }
            items.removeAll()
            for cachedItem in cachedItems {
                if let lookupResult = persistenceManager.fetchFromCache(id: cachedItem.id).1 {
                    switch selfType {
                    case .history:
                        items.append(DictionaryEntryItem(lookupResult: lookupResult, cachedItem: cachedItem))
                    case .bookmarks:
                        if cachedItem.isBookmarked {
                            self.items.append(DictionaryEntryItem(lookupResult: lookupResult, cachedItem: cachedItem))
                        }
                    }
                }
            }
            sort(order: .date)
        }
    
    func sort(order: SortOrder) {
        items.sort(by: {
            switch order {
            case .alphabet:
                let a = $0.lookupResult.def.first?.text ?? ""
                let b = $1.lookupResult.def.first?.text ?? ""
                return ascendingOrder ? a < b : a > b
            case .date:
                let a = $0.cachedItem.lastSearchDate
                let b = $1.cachedItem.lastSearchDate
                return ascendingOrder ? a < b : a > b
            case .language:
                let a = localizedTargetLangString(for: $0.cachedItem.languagePair)
                let b = localizedTargetLangString(for: $1.cachedItem.languagePair)
                return ascendingOrder ? a < b : a > b
            }
        })
    }
    
    func localizedTargetLangString(for languagePair: String) -> String {
        let targetLanguageId = String(languagePair.split(separator: "-").last!)
        return Locale.current.localizedString(forIdentifier: targetLanguageId) ?? "N/A"
    }
}
