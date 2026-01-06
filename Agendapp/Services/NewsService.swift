//
//  NewsService.swift
//  Agendapp
//
//  Created by Muhammad Taha Imran on 06.01.26.
//


import Foundation

final class NewsService {
    static let shared = NewsService()
    private init() {}

    private let apiKey = ""

    func fetchTopHeadlines() async throws -> [NewsArticle] {
        let today = todayString()

        let urlString =
        """
        https://newsapi.org/v2/top-headlines\
        ?country=us\
        &category=technology\
        &from=\(today)\
        &to=\(today)\
        &sortBy=publishedAt\
        &apiKey=\(apiKey)
        """

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(NewsResponse.self, from: data)
        return response.articles
    }
    private func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        return formatter.string(from: Date())
    }

}
