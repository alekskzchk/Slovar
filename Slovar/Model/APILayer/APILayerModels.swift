//
//  Models.swift
//  Slovar
//
//  Created by Алексей Козачук on 05.09.2025.
//

import Foundation

nonisolated struct Language: Identifiable, Hashable, Codable {
    var id: String
    var name: String
    var possiblePairsIds: [String]
}

enum UILanguage {
    case en, ru, uk, tr
}

struct LookupResult: Codable, Hashable, Identifiable {
    let id = UUID()
    let head: Head?
    let def: [Word]
    let nmtCode: Int
    let code: Int
    
    enum CodingKeys: String, CodingKey {
        case head, def, nmtCode = "nmt_code", code
    }
}

struct Head: Codable, Hashable {}

struct Word: Codable, Identifiable, Hashable {
    var id = UUID()
    let text: String
    let pos: String?
    let gen: String?
    let anm: String?
    let fr: Int?
    let ts: String?
    let fl: String?
    let mean: [Word]?
    let syn: [Word]?
    let tr: [Word]?
    
    private enum CodingKeys: String, CodingKey {
        case text, pos, gen, anm, fr, ts, fl, mean, syn, tr
    }
}

struct APIErrorResponse: Decodable {
    let code: APIErrorCode
    let message: String
}

enum APIErrorCode: Int, Decodable {
    case invalidKey = 401
    case blockedKey = 402
    case keyDailyLimitExceeded = 403
    case textTooLong = 413
    case unsupportedLangsPair = 501
    case notFound = 502
    case unknown = -1
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawCode = try container.decode(Int.self)
        self = APIErrorCode(rawValue: rawCode) ?? .unknown
    }
    
}

extension LookupResult {
    static func fromMockFile() -> LookupResult {
        let url = Bundle.main.url(forResource: "mock2", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode(LookupResult.self, from: data)
    }
}
