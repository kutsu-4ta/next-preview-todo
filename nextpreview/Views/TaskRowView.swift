import SwiftUI

struct TaskRowView: View {
    let task: TaskItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // 完了ボタン
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(task.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)

            // コンテンツ
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(task.style.emoji)
                        .font(.subheadline)
                    Text(task.title)
                        .font(.headline)
                        .strikethrough(task.isCompleted)
                        .foregroundStyle(task.isCompleted ? .secondary : .primary)
                }

                HStack(spacing: 8) {
                    Text(task.dueDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if task.isOverdue {
                        Text("To Be Continued...")
                            .font(.caption)
                            .foregroundStyle(.orange)
                            .italic()
                    }
                }

                if !task.generatedPreview.isEmpty && !task.isCompleted {
                    Text(task.generatedPreview)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .italic()
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}
