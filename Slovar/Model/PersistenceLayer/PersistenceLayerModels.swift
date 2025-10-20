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
    var lookupResultData: Data
    var lastSearchDate: Date
    var isBookmarked: Bool
    var showInHistory: Bool
    
    init(id: String, lookupResultData: Data, lastSearchDate: Date, isBookmarked: Bool, showInHistory: Bool) {
        self.id = id
        self.lookupResultData = lookupResultData
        self.lastSearchDate = lastSearchDate
        self.isBookmarked = isBookmarked
        self.showInHistory = showInHistory
    }
}
