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
    var errorMessage: String?
    var allLanguages: [Language] = []
    var selectedSource: Language?
    var selectedTarget: Language?
    let dictionaryAPI = DictionaryAPI()
    private let persistenceManager: PersistenceManager
    
    init(modelContext: ModelContext) {
        self.persistenceManager = PersistenceManager(context: modelContext)
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
    
    private func buildLanguages(from pairs: [String]) -> [Language] {
        var map: [String: Set<String>] = [:]
        
        for pair in pairs {
            let components = pair.split(separator: "-").map(String.init)
            let source: String
            let target: String
            if components.count == 2 {
                source = components[0]
                target = components[1]
            } else {
                source = components[0]
                target = components[1] + "-" + components[2]
            }
            map[source, default: []].insert(target)
        }
        
        let languages = map.map { (id, targets) in
            Language(
                id: id,
                name: Locale.current.localizedString(forLanguageCode: id) ?? id,
                possiblePairsIds: Array(targets)
            )
        }
        let sortedLanguages = languages.sorted { $0.name < $1.name }
        return sortedLanguages
    }
    
    func fetchLanguages() async {
        isLoadingLanguages = true
        errorMessage = nil
        if let newPairs = await loadAndCacheLanguagePairs() {
            allLanguages = buildLanguages(from: newPairs)
        }
        isLoadingLanguages = false
    }
    
    func loadAndCacheLanguagePairs() async -> [String]? {
        var languagePairs: [String]? = nil
        do {
            languagePairs = try await dictionaryAPI.getLangs()
        } catch let error as APIError {
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = error.localizedDescription
        }
        return languagePairs
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
                let lookupResult = try await dictionaryAPI.lookup(word: wordRefined, lang: languagePair)
                print("SearchViewModel: Fetched new result")
                persistenceManager.saveToCache(id: id, lookupResult: lookupResult)
                print("SearchViewModel: Saved to cache")
                return await persistenceManager.fetchFromCache(id: id).1
            } catch {
                self.errorMessage = error.localizedDescription
                return nil
            }
        }
    }
}
