import SwiftUI

struct PreviewCardView: View {
    let task: TaskItem
    let isCurrentlyPlaying: Bool
    let onPlay: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // ヘッダー
            HStack {
                Text(task.style.emoji)
                    .font(.title2)
                Text(task.style.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                if isCurrentlyPlaying {
                    SoundWaveView(color: task.style.accentColor, barCount: 4)
                }
            }

            // タスクタイトル
            Text(task.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            // 予告文
            if !task.generatedPreview.isEmpty {
                Text("「\(task.generatedPreview)」")
                    .font(.callout)
                    .italic()
                    .foregroundStyle(task.style.accentColor)
                    .lineSpacing(4)
            } else {
                Text("予告文未生成")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }

            // フッター
            HStack {
                Text(task.dueDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Button(action: onPlay) {
                    Label(
                        isCurrentlyPlaying ? "停止" : "読み上げ",
                        systemImage: isCurrentlyPlaying ? "stop.circle.fill" : "play.circle.fill"
                    )
                    .font(.subheadline)
                    .foregroundStyle(task.style.accentColor)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: task.style.gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    isCurrentlyPlaying ? task.style.accentColor : Color.white.opacity(0.1),
                    lineWidth: isCurrentlyPlaying ? 2 : 1
                )
        )
        .shadow(color: isCurrentlyPlaying ? task.style.accentColor.opacity(0.4) : .clear, radius: 8)
    }
}
