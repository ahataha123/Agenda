//
//  QuoteService.swift
//  Agendapp
//
//  Created by Muhammad Taha Imran on 03.12.25.
//

import Foundation

struct Quote: Codable {
    let text: String
    let author: String?
}

struct QuoteService {
    static func fetchQuotes() async throws -> [Quote] {
        let url = URL(string: "https://type.fit/api/quotes")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Quote].self, from: data)
    }
}
