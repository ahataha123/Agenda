//
//  EmptyUpcomingView.swift
//  Agendapp
//
//  Created by Muhammad Taha Imran on 06.01.26.
//


import SwiftUI

struct EmptyUpcomingView: View {

    private let quotes = [
        "Nothing planned — and that’s okay 🌱",
        "Your future is clear. Enjoy the calm.",
        "No upcoming tasks. Space to breathe.",
        "Sometimes the best plan is no plan.",
        "A quiet schedule is a powerful thing."
    ]

    private var randomQuote: String {
        quotes.randomElement()!
    }

    var body: some View {
        VStack(spacing: 20) {

            Image(systemName: "sparkles")
                .font(.system(size: 42))
                .foregroundStyle(.secondary)

            Text("You're all caught up")
                .font(.title2)
                .fontWeight(.semibold)

            Text(randomQuote)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
