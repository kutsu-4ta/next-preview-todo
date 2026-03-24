import Foundation
import SwiftData

@Observable
final class TaskListViewModel {
    var showingAddTask = false

    func todaysTasks(from tasks: [TaskItem]) -> [TaskItem] {
        tasks.filter { Calendar.current.isDateInToday($0.dueDate) && !$0.isCompleted }
    }

    func overdueTasks(from tasks: [TaskItem]) -> [TaskItem] {
        let today = Calendar.current.startOfDay(for: Date())
        return tasks.filter { $0.dueDate < today && !$0.isCompleted }
    }

    func futureTasks(from tasks: [TaskItem]) -> [TaskItem] {
        guard let tomorrow = Calendar.current.date(
            byAdding: .day, value: 1,
            to: Calendar.current.startOfDay(for: Date())
        ) else { return [] }
        return tasks.filter { $0.dueDate >= tomorrow && !$0.isCompleted }
    }

    func completedTasks(from tasks: [TaskItem]) -> [TaskItem] {
        tasks.filter { $0.isCompleted }
    }

    func toggleComplete(_ task: TaskItem, context: ModelContext) {
        task.isCompleted.toggle()
        try? context.save()
    }

    func delete(_ task: TaskItem, context: ModelContext) {
        context.delete(task)
        try? context.save()
    }
}
