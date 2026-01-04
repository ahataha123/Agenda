import SwiftUI
import SwiftData

struct TodoDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    var todo: Todo?

    @State private var title: String
    @State private var dueDate: Date
    @State private var notes: String

    init(todo: Todo? = nil, presetDate: Date? = nil) {
        self.todo = todo

        _title = State(initialValue: todo?.title ?? "")
        _dueDate = State(
            initialValue: todo?.dueDate
            ?? presetDate
            ?? Calendar.current.startOfDay(for: Date())
        )
        _notes = State(initialValue: todo?.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {

                // 🔹 Main info
                Section {
                    TextField("Task title", text: $title)

                    DatePicker(
                        "Due date",
                        selection: $dueDate,
                        displayedComponents: [.date]
                    )
                }

                // Notes (THIS is the safe way)
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 120)
                        .scrollContentBackground(.hidden)
                }

                // Details (edit only)
                if let todo {
                    Section("Details") {
                        HStack {
                            Label("Status", systemImage: "info.circle")
                            Spacer()
                            Text(
                                todo.isOverdue
                                ? "Overdue"
                                : todo.completedAt != nil
                                    ? "Completed"
                                    : "Active"
                            )
                            .foregroundStyle(
                                todo.isOverdue
                                ? .red
                                : todo.completedAt != nil
                                    ? .green
                                    : .secondary
                            )
                        }
                    }
                }
            }
            .navigationTitle(todo == nil ? "New Task" : "Edit Task")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {

                // Cancel only for new
                if todo == nil {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    // MARK: - Save
    private func save() {
        let normalizedDate = Calendar.current.startOfDay(for: dueDate)

        if let todo {
            todo.title = title
            todo.dueDate = normalizedDate
            todo.notes = notes
        } else {
            let newTodo = Todo(
                title: title,
                dueDate: normalizedDate,
                notes: notes
            )
            context.insert(newTodo)
        }
    }
}
