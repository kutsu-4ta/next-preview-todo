import SwiftData
import Foundation

@Model
final class TaskItem {
    var id: UUID
    var title: String
    var dueDate: Date
    var styleRawValue: String
    var generatedPreview: String
    var isCompleted: Bool
    var createdAt: Date

    init(title: String, dueDate: Date, style: PreviewStyle = .shonen) {
        self.id = UUID()
        self.title = title
        self.dueDate = dueDate
        self.styleRawValue = style.rawValue
        self.generatedPreview = ""
        self.isCompleted = false
        self.createdAt = Date()
    }

    var style: PreviewStyle {
        get { PreviewStyle(rawValue: styleRawValue) ?? .shonen }
        set { styleRawValue = newValue.rawValue }
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(dueDate)
    }

    var isOverdue: Bool {
        !isCompleted && dueDate < Calendar.current.startOfDay(for: Date())
    }
}
