import SwiftUI

struct ToBeContinuedSection: View {
    let tasks: [TaskItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // タイトルバー
            HStack {
                Rectangle()
                    .frame(width: 3, height: 20)
                    .foregroundStyle(.orange)
                Text("To Be Continued...")
                    .font(.headline)
                    .foregroundStyle(.orange)
                    .italic()
                Spacer()
                Image(systemName: "clock.badge.exclamationmark")
                    .foregroundStyle(.orange)
            }

            Text("昨日以前の未完了タスク")
                .font(.caption)
                .foregroundStyle(.secondary)

            ForEach(tasks) { task in
                HStack(spacing: 8) {
                    Text(task.style.emoji)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(task.title)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                        Text(task.dueDate.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "arrow.right.circle")
                        .foregroundStyle(.orange.opacity(0.7))
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(16)
        .background(Color.orange.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
}
