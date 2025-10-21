//
//  HistoryViewModel.swift
//  Slovar
//
//  Created by Алексей Козачук on 21.10.2025.
//

import Observation
import SwiftData
import SwiftUI

enum SortingOrder {
    case alphabetical, date, language
}

@MainActor
@Observable
class HistoryViewModel {
    private let persistenceManager: PersistenceManager
    var allHistoryItems = [(CachedItem, LookupResult)]()
    var ascendingOrder: Bool = true
    
    
    init(context: ModelContext) {
        self.persistenceManager = PersistenceManager(context: context)
    }
    
    func fetchHistoryItems() async {
        guard let items = await persistenceManager.fetchAllCachedItems() else { return }
        allHistoryItems.removeAll()
        for item in items {
            if let lookupResult = persistenceManager.fetchFromCache(id: item.id).1 {
                allHistoryItems.append((item, lookupResult))
                sort(order: .date)
            }
        }
    }
    
    func sort(order: SortingOrder) {
        allHistoryItems.sort(by: {
            switch order {
            case .alphabetical:
                let a = $0.1.def.first?.text ?? ""
                let b = $1.1.def.first?.text ?? ""
                return ascendingOrder ? a < b : a > b
            case .date:
                let a = $0.0.lastSearchDate
                let b = $1.0.lastSearchDate
                return ascendingOrder ? a < b : a > b
            case .language:
                let a = getLocalizedTargetLangString(for: $0.0.languagePair)
                let b = getLocalizedTargetLangString(for: $1.0.languagePair)
                return ascendingOrder ? a < b : a > b
            }
        })
    }
    
    func getLocalizedTargetLangString(for languagePair: String) -> String {
        let targetLanguageId = String(languagePair.split(separator: "-").last!)
        return Locale.current.localizedString(forIdentifier: targetLanguageId) ?? "N/A"
    }
}
