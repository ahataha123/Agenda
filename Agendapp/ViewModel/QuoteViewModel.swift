//
//  QuoteViewModel.swift
//  Agendapp
//
//  Created by Muhammad Taha Imran on 25.12.25.
//
import Foundation

@MainActor
class QuoteViewModel: ObservableObject {
    @Published var quote: Quote?

    func loadQuote() async {
        do {
            let quotes = try await QuoteService.fetchQuotes()
            quote = quotes.randomElement()
        } catch {
            print("Quote fetch failed")
        }
    }
}
