//
//  QuoteCard.swift
//  Agendapp
//
//  Created by Muhammad Taha Imran on 25.12.25.
//


import SwiftUI

struct QuoteCard: View {
    let text: String
    let author: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("“\(text)”")
                .font(.headline)

            Text("– \(author ?? "Unknown")")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
        )
    }
}
