//
//  NewsView.swift
//  Agendapp
//
//  Created by Muhammad Taha Imran on 06.01.26.
//


import SwiftUI

struct NewsView: View {
    @StateObject private var vm = NewsViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Loading news…")
                } else if let error = vm.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                } else {
                    List(vm.articles) { article in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(article.title)
                                .font(.headline)

                            if let description = article.description {
                                Text(description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("News 🗞️")
            .task {
                await vm.loadNews()
            }
        }
    }
}
