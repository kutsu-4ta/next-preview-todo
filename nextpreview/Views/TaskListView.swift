import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskItem.dueDate) private var tasks: [TaskItem]
    @State private var vm = TaskListViewModel()

    private var today: [TaskItem]     { vm.todaysTasks(from: tasks) }
    private var overdue: [TaskItem]   { vm.overdueTasks(from: tasks) }
    private var future: [TaskItem]    { vm.futureTasks(from: tasks) }
    private var completed: [TaskItem] { vm.completedTasks(from: tasks) }

    var body: some View {
        NavigationStack {
            List {
                // 期限切れ（To Be Continued）
                if !overdue.isEmpty {
                    Section {
                        ForEach(overdue) { task in
                            TaskRowView(task: task) {
                                vm.toggleComplete(task, context: modelContext)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.map { overdue[$0] }
                                .forEach { vm.delete($0, context: modelContext) }
                        }
                    } header: {
                        Label("To Be Continued...", systemImage: "clock.badge.exclamationmark")
                            .foregroundStyle(.orange)
                    }
                }

                // 今日
                Section {
                    if today.isEmpty {
                        Label("今日のタスクはありません", systemImage: "checkmark.circle")
                            .foregroundStyle(.secondary)
                            .listRowBackground(Color.clear)
                    } else {
                        ForEach(today) { task in
                            TaskRowView(task: task) {
                                vm.toggleComplete(task, context: modelContext)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.map { today[$0] }
                                .forEach { vm.delete($0, context: modelContext) }
                        }
                    }
                } header: {
                    Label("今日", systemImage: "star.fill").foregroundStyle(.yellow)
                }

                // 今後
                if !future.isEmpty {
                    Section {
                        ForEach(future) { task in
                            TaskRowView(task: task) {
                                vm.toggleComplete(task, context: modelContext)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.map { future[$0] }
                                .forEach { vm.delete($0, context: modelContext) }
                        }
                    } header: {
                        Label("今後の予定", systemImage: "calendar")
                    }
                }

                // 完了済み
                if !completed.isEmpty {
                    Section {
                        ForEach(completed) { task in
                            TaskRowView(task: task) {
                                vm.toggleComplete(task, context: modelContext)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.map { completed[$0] }
                                .forEach { vm.delete($0, context: modelContext) }
                        }
                    } header: {
                        Label("完了済み", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
            }
            .navigationTitle("タスク一覧")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        vm.showingAddTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $vm.showingAddTask) {
                TaskAddView()
            }
        }
    }
}
