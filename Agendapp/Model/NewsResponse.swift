//
//  NewsResponse.swift
//  Agendapp
//
//  Created by Muhammad Taha Imran on 06.01.26.
//


import Foundation

struct NewsResponse: Decodable {
    let articles: [NewsArticle]
}

struct NewsArticle: Decodable, Identifiable {
    let id = UUID()
    let title: String
    let description: String?
    let url: String
    let publishedAt: String
}
