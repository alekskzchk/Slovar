//
//  DictionaryAPI.swift
//  Slovar
//
//  Created by Алексей Козачук on 05.09.2025.
//

import Foundation

final class DictionaryAPI {
    
    private let decoder = JSONDecoder()
    private let session: URLSession
    private let baseURL = URL(string: "https://dictionary.yandex.net/api/v1/dicservice.json/lookup")!
    private let apiKey: String
    static let shared = DictionaryAPI()
    
    init(session: URLSession = .shared, apiKey: String = APIKeys.key1) {
        self.session = session
        self.apiKey = apiKey
    }
    
    private func makeURL(word: String, lang: String) -> URL {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "text", value: word),
            URLQueryItem(name: "lang", value: lang)
        ]
        return components.url!
    }
    
    func lookup(word: String, lang: String) async throws -> LookupResult {
        let url = makeURL(word: word, lang: lang)
        let (data, response) = try await session.data(from: url)
        let ignoredStatusCodes = Set([403, 400]) //reserved for API errors parsing
        
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) && !ignoredStatusCodes.contains(http.statusCode) {
            throw APIError.httpStatus(code: http.statusCode)
        }
        
        if let apiError = try? decoder.decode(APIErrorResponse.self, from: data) {
            throw APIError.apiError(code: apiError.code)
        }
        guard let decodedData = try? decoder.decode(LookupResult.self, from: data) else {
            throw APIError.decoding
        }
        
        if decodedData.def.isEmpty {
            throw APIError.apiError(code: .notFound)
        }
        
        return decodedData
    }
    
    
    func getLangs() async throws -> [String] {
        var components = URLComponents(url: URL(string: "https://dictionary.yandex.net/api/v1/dicservice.json/getLangs")!, resolvingAgainstBaseURL: false)!
        components.queryItems = [ URLQueryItem(name: "key", value: APIKeys.key1) ]
        guard let url = components.url else { throw APIError.badURL }
        
        let (data, response) = try await session.data(from: url)
        
        let ignoredStatusCodes = Set([403]) //reserved for API errors parsing
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) && !ignoredStatusCodes.contains(http.statusCode) {
            throw APIError.httpStatus(code: http.statusCode)
        }
        
        if let apiError = try? decoder.decode(APIErrorResponse.self, from: data) {
            throw APIError.apiError(code: apiError.code)
        }
        
        guard let decodedData = try? JSONDecoder().decode([String].self, from: data) else {
            throw APIError.decoding
        }
        
        return decodedData
    }
}

enum APIError: LocalizedError {
    case badURL
    case network(URLError)
    case httpStatus(code: Int)
    case decoding
    case unknown(Error)
    case apiError(code: APIErrorCode)
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return String(localized: "errors.badURL")
        case .network(let urlError):
            return String(localized: "errors.badURL") + ": \(urlError.localizedDescription)"
        case .httpStatus(code: let code):
            return String(localized: "errors.httpStatus") + ": \(code)"
        case .decoding:
            return String(localized: "errors.decodingFailed")
        case .unknown(let error):
            return String(localized: "errors.unknown") + ": \(error)"
        case .apiError(code: let code):
            switch code {
            case .invalidKey: return String(localized: "APIerrors.invalidAPIKey")
            case .blockedKey: return String(localized: "APIerrors.blockedAPIKey")
            case .keyDailyLimitExceeded: return String(localized: "APIerrors.APIKeyDailyLimitExceeded")
            case .textTooLong: return String(localized: "APIerrors.textTooLong")
            case .unsupportedLanguagePair: return String(localized: "APIerrors.unsupportedLanguagePair")
            case .notFound: return String(localized: "APIerrors.wordNotFound")
            case .unknown: return String(localized: "APIerrors.unknownError")
            }
        }
    }
}
