import SwiftUI
import SwiftData

struct UpcomingView: View {
    @Query(sort: \Todo.dueDate) private var todos: [Todo]
    @Environment(\.modelContext) private var context
    @State private var showAdd = false

    var upcomingTodos: [Todo] {
        let tomorrow = Calendar.current.startOfDay(
            for: Date().addingTimeInterval(86400)
        )
        return todos.filter {
            $0.completedAt == nil &&
            $0.dueDate >= tomorrow
        }
    }

    var body: some View {
        NavigationStack {

            if upcomingTodos.isEmpty {
                EmptyUpcomingView()
                    .navigationTitle("Upcoming 👀")
                    .toolbar {
                        Button {
                            showAdd = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }

            } else {
                List {
                    ForEach(upcomingTodos) { todo in
                        NavigationLink {
                            TodoDetailView(todo: todo)
                        } label: {
                            TodoRowView(todo: todo)
                        }
                    }
                    .onDelete(perform: deleteTodo)
                }
                .navigationTitle("Upcoming 👀")
                .toolbar {
                    Button {
                        showAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showAdd) {
            TodoDetailView(todo: nil)
        }
    }

    // MARK: - Delete
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = upcomingTodos[index]
            context.delete(todo)
        }
    }
}
