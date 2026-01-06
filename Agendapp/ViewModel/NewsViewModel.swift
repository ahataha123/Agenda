//
//  NewsViewModel.swift
//  Agendapp
//
//  Created by Muhammad Taha Imran on 06.01.26.
//


import Foundation

@MainActor
final class NewsViewModel: ObservableObject {
    @Published var articles: [NewsArticle] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadNews() async {
        isLoading = true
        errorMessage = nil

        do {
            articles = try await NewsService.shared.fetchTopHeadlines()
        } catch {
            errorMessage = "Failed to load news"
        }

        isLoading = false
    }
}
