import SwiftData
import Foundation

@Model
class Todo {
    var title: String
    var dueDate: Date
    var completedAt: Date?
    var notes: String  

    init(
        title: String,
        dueDate: Date,
        completedAt: Date? = nil,
        notes: String = ""
    ) {
        self.title = title
        self.dueDate = dueDate
        self.completedAt = completedAt
        self.notes = notes
    }



    var isDueToday: Bool {
        Calendar.current.isDateInToday(dueDate)
    }

    var isCompletedToday: Bool {
        guard let completedAt else { return false }
        return Calendar.current.isDateInToday(completedAt)
    }

    var isOverdue: Bool {
        dueDate < Calendar.current.startOfDay(for: Date())
        && completedAt == nil
    }
}

