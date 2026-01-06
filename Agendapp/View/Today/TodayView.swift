import SwiftUI
import SwiftData

struct TodayView: View {
    @Query(sort: \Todo.dueDate) private var todos: [Todo]
    @Environment(\.modelContext) private var context
    @StateObject private var quoteVM = QuoteViewModel()
    @State private var showAdd = false

    // MARK: - Computed
    var todayTodos: [Todo] {
        todos.filter {
            $0.isDueToday || $0.isOverdue
        }
    }
    var activeTodayTodos: [Todo] {
        todayTodos.filter { $0.completedAt == nil }
    }

    var completedTodayTodos: [Todo] {
        todayTodos.filter { $0.isCompletedToday }
    }


    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                // 🔹 Quote card
                if let quote = quoteVM.quote {
                    QuoteCard(
                        text: quote.text,
                        author: quote.author
                    )
                    .padding(.horizontal)
                }

                //  Refresh quote
                Button("Refresh Quote") {
                    Task { await quoteVM.loadQuote() }
                }

                List {

                    // 🎉 EMPTY STATE (no active tasks)
                    if activeTodayTodos.isEmpty {
                        VStack(spacing: 14) {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 42))
                                .foregroundStyle(.secondary)

                            Text("All done for today 🎉")
                                .font(.headline)

                            Text("Enjoy your day.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .listRowSeparator(.hidden)
                    }

                    // 🔹 ACTIVE TASKS
                    ForEach(activeTodayTodos) { todo in
                        NavigationLink {
                            TodoDetailView(todo: todo)
                        } label: {
                            TodoRowView(todo: todo)
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                withAnimation(.spring()) {
                                    todo.completedAt = Date()
                                    UIImpactFeedbackGenerator(style: .light)
                                        .impactOccurred()
                                }
                            } label: {
                                Label("Done", systemImage: "checkmark")
                            }
                            .tint(.green)
                        }
                    }

                    // 🔹 COMPLETED TODAY
                    if !completedTodayTodos.isEmpty {
                        Section("Completed") {
                            ForEach(completedTodayTodos) { todo in
                                TodoRowView(todo: todo)
                                    .disabled(true)
                                    .opacity(0.5)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Agenda 📋")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                TodoDetailView(
                    todo: nil,
                    presetDate: Date()
                )
            }
            .task {
                await quoteVM.loadQuote()
            }
        }
    }
}
