import SwiftUI
import SwiftData

struct PreviewPlayerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskItem.dueDate) private var allTasks: [TaskItem]
    @ObservedObject private var speech = SpeechService.shared
    @State private var playingTaskID: UUID?

    private var todaysTasks: [TaskItem] {
        allTasks.filter { Calendar.current.isDateInToday($0.dueDate) && !$0.isCompleted }
    }
    private var overdueTasks: [TaskItem] {
        let today = Calendar.current.startOfDay(for: Date())
        return allTasks.filter { $0.dueDate < today && !$0.isCompleted }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                if todaysTasks.isEmpty && overdueTasks.isEmpty {
                    emptyState
                } else {
                    mainContent
                }
            }
            .navigationTitle("今日の予告")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }

    // MARK: - Main Content
    private var mainContent: some View {
        VStack(spacing: 0) {
            dateHeader

            ScrollView {
                VStack(spacing: 14) {
                    if !overdueTasks.isEmpty {
                        ToBeContinuedSection(tasks: overdueTasks)
                            .padding(.top, 8)
                    }

                    if !todaysTasks.isEmpty {
                        sectionHeader("今日の予告", icon: "play.tv.fill")

                        ForEach(todaysTasks) { task in
                            PreviewCardView(
                                task: task,
                                isCurrentlyPlaying: playingTaskID == task.id && speech.isSpeaking
                            ) {
                                togglePlay(task: task)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, todaysTasks.isEmpty ? 0 : 100)
            }

            if !todaysTasks.isEmpty {
                playAllBar
            }
        }
    }

    // MARK: - Date Header
    private var dateHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(Date(), format: .dateTime.year().month().day())
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                if speech.isSpeaking {
                    HStack(spacing: 6) {
                        SoundWaveView(color: .accentColor, barCount: 4)
                        Text("ON AIR")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.accentColor)
                    }
                }
            }
            Spacer()
            // 今日のタスク数バッジ
            if !todaysTasks.isEmpty {
                Text("\(todaysTasks.count)件")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.accentColor.opacity(0.2))
                    .foregroundStyle(Color.accentColor)
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    // MARK: - Section Header
    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
            Text(title)
                .fontWeight(.semibold)
            Spacer()
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }

    // MARK: - Play All Bar
    private var playAllBar: some View {
        VStack(spacing: 0) {
            Divider().background(Color.white.opacity(0.1))
            HStack(spacing: 16) {
                // 停止ボタン
                if speech.isSpeaking {
                    Button {
                        speech.stop()
                        playingTaskID = nil
                    } label: {
                        Image(systemName: "stop.fill")
                            .font(.title2)
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    if speech.isSpeaking {
                        speech.stop()
                        playingTaskID = nil
                    } else {
                        playAll()
                    }
                } label: {
                    Label(
                        speech.isSpeaking ? "再生中..." : "全部まとめて再生",
                        systemImage: speech.isSpeaking ? "waveform" : "play.fill"
                    )
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(speech.isSpeaking ? Color.gray.opacity(0.3) : Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.black.opacity(0.9))
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "tv.slash")
                .font(.system(size: 64))
                .foregroundStyle(.gray)
            Text("今日の予告はありません")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            Text("「タスク」タブからタスクを追加してみよう")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    // MARK: - Actions
    private func togglePlay(task: TaskItem) {
        if speech.isSpeaking && playingTaskID == task.id {
            speech.stop()
            playingTaskID = nil
        } else {
            speech.stop()
            let text = task.generatedPreview.isEmpty
                ? OpenAIService.shared.fallbackPreview(for: task.title, style: task.style)
                : task.generatedPreview
            playingTaskID = task.id
            speech.speak(text, style: task.style)
        }
    }

    private func playAll() {
        speech.stop()
        let items = todaysTasks.map { task -> (text: String, style: PreviewStyle) in
            let text = task.generatedPreview.isEmpty
                ? OpenAIService.shared.fallbackPreview(for: task.title, style: task.style)
                : task.generatedPreview
            return (text: text, style: task.style)
        }
        if let first = todaysTasks.first {
            playingTaskID = first.id
        }
        speech.speakAll(items)
    }
}
