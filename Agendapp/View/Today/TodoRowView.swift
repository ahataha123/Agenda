import SwiftUI

struct TodoRowView: View {
    let todo: Todo

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.body)
                    .strikethrough(todo.completedAt != nil)
                    .foregroundColor(
                        todo.completedAt != nil
                        ? .secondary
                        : todo.isOverdue ? .red : .primary
                    )

                Text(todo.dueDate.formatted(date: .long, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if todo.completedAt != nil {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 6)
    }
}
