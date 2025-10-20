//
//  SearchViewModel.swift
//  Slovar
//
//  Created by Алексей Козачук on 05.09.2025.
//

import Observation
import SwiftData
import SwiftUI

@MainActor
@Observable
class SearchViewModel {
    var searchResult: LookupResult?
    var isLoadingLanguages: Bool = false
    var isLoadingSearchQuery: Bool = false
    var errorMessage: String?
    var allLanguages: [Language] = []
    var selectedSource: Language?
    var selectedTarget: Language?
    let dictionaryAPI = DictionaryAPI()
    private let persistenceManager: PersistenceManager
    
    init(modelContext: ModelContext) {
        self.persistenceManager = PersistenceManager(context: modelContext)
        Task {
            await loadLangs()
        }
    }
    
    var availableSources: [Language] {
        guard let target = selectedTarget else { return allLanguages }
        return allLanguages.filter { target.possiblePairsIds.contains($0.id) }
    }
    
    var availableTargets: [Language] {
        guard let source = selectedSource else { return allLanguages }
        return allLanguages.filter { source.possiblePairsIds.contains($0.id) }
    }
    
    var canSwap: Bool {
        guard let source = selectedSource, let target = selectedTarget else { return false }
        return source.possiblePairsIds.contains(target.id) && target.possiblePairsIds.contains(source.id)
    }
    
    func swap() {
        guard selectedSource != nil, selectedTarget != nil else { return }
        withAnimation {
            let tmp = selectedSource
            selectedSource = selectedTarget
            selectedTarget = tmp
        }
    }
    
    func loadLangs() async {
        var rawStrings = [String]()
        if let cachedLangs = await persistenceManager.fetchCachedLangs() {
            rawStrings = cachedLangs
            print("Retrieved from cache")
        } else {
            do {
                isLoadingLanguages = true
                rawStrings = try await dictionaryAPI.getLangs()
                persistenceManager.saveLangs(rawStrings)
                print("Got langs from API")
                isLoadingLanguages = false
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
        allLanguages = dictionaryAPI.buildLangs(from: rawStrings)
    }
    
    func search(word: String) async -> LookupResult? {
        guard let selectedSource, let selectedTarget else {
            errorMessage = String(localized: "Source and target languages are not selected")
            return nil
        }
        let id = persistenceManager.makeCacheItemId(sourceLang: selectedSource, targetLang: selectedTarget, userPrompt: word)
        let fetchResult = await persistenceManager.fetchFromCache(id: id)
        if let cachedItem = fetchResult.0, let lookupResult = fetchResult.1 {
            cachedItem.lastSearchDate = .now
            print("SearchViewModel: Using cached result")
            return lookupResult
        } else {
            do {
                guard !word.isEmpty else {
                    errorMessage = String(localized: "Enter a word to translate")
                    return nil
                }
                let languagePair = "\(selectedSource.id)-\(selectedTarget.id)"
                let wordRefined = word.trimmingCharacters(in: .whitespacesAndNewlines)
                isLoadingSearchQuery = true
                let lookupResult = try await dictionaryAPI.lookup(word: wordRefined, lang: languagePair)
                print("SearchViewModel: Fetched new result")
                persistenceManager.saveToCache(id: id, lookupResult: lookupResult)
                print("SearchViewModel: Saved to cache")
                isLoadingSearchQuery = false
                return await persistenceManager.fetchFromCache(id: id).1
            } catch {
                self.errorMessage = error.localizedDescription
                return nil
            }
        }
    }
}
