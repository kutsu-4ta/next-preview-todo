import SwiftUI
import SwiftData

struct TaskAddView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var vm = TaskAddViewModel()
    @StateObject private var settings = SettingsViewModel()
    @ObservedObject private var speech = SpeechService.shared

    var body: some View {
        NavigationStack {
            Form {
                taskInfoSection
                styleSection
                previewSection
            }
            .navigationTitle("タスクを追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
            .alert("エラー", isPresented: $vm.showError) {
                Button("OK") {}
            } message: {
                Text(vm.errorMessage ?? "不明なエラーが発生しました")
            }
        }
    }

    // MARK: - Sections
    private var taskInfoSection: some View {
        Section("タスク情報") {
            TextField("タスク名を入力（例：歯医者）", text: $vm.title)
                .submitLabel(.done)
            DatePicker("実施日", selection: $vm.dueDate, displayedComponents: .date)
        }
    }

    private var styleSection: some View {
        Section("予告スタイル") {
            ForEach(PreviewStyle.allCases) { style in
                StyleRow(style: style, isSelected: vm.selectedStyle == style)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        vm.selectedStyle = style
                        vm.previewGenerated = false
                        vm.generatedPreview = ""
                        speech.stop()
                    }
            }
        }
    }

    @ViewBuilder
    private var previewSection: some View {
        Section("予告文") {
            if vm.isGenerating {
                generatingView
            } else if vm.previewGenerated {
                generatedView
            } else {
                generateButton
            }
        }
    }

    private var generatingView: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                ProgressView()
                Text("AIが予告文を生成中…")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }

    private var generatedView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("「\(vm.generatedPreview)」")
                .font(.callout)
                .italic()
                .lineSpacing(4)

            HStack {
                Button {
                    if speech.isSpeaking {
                        speech.stop()
                    } else {
                        speech.speak(vm.generatedPreview, style: vm.selectedStyle)
                    }
                } label: {
                    Label(
                        speech.isSpeaking ? "停止" : "読み上げ",
                        systemImage: speech.isSpeaking ? "stop.circle.fill" : "play.circle.fill"
                    )
                }
                .buttonStyle(.bordered)
                .tint(vm.selectedStyle.accentColor)

                Spacer()

                Button("再生成") {
                    speech.stop()
                    Task { await vm.generatePreview(apiKey: settings.apiKey) }
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private var generateButton: some View {
        VStack(spacing: 8) {
            Button {
                Task { await vm.generatePreview(apiKey: settings.apiKey) }
            } label: {
                Label("予告文を生成する", systemImage: "wand.and.stars")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!vm.canSave)

            if settings.apiKey.isEmpty {
                Text("APIキー未設定のため、サンプル予告文が生成されます")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("キャンセル") {
                speech.stop()
                dismiss()
            }
        }
        ToolbarItem(placement: .confirmationAction) {
            Button("保存") {
                speech.stop()
                vm.save(context: modelContext)
                dismiss()
            }
            .disabled(!vm.canSave)
            .fontWeight(.semibold)
        }
    }
}

// MARK: - Style Row
private struct StyleRow: View {
    let style: PreviewStyle
    let isSelected: Bool

    private func description(for style: PreviewStyle) -> String {
        switch style {
        case .shonen:  return "「ぜってぇ見てくれよな！」"
        case .shojo:   return "「絶対に見てね♡」"
        case .mystery: return "「真実はいつもひとつ！」"
        case .movie:   return "「全米が泣いた」"
        case .overseas: return "「冗談はやめてくれよ、ボブ」"
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(style.emoji).font(.title2)
            VStack(alignment: .leading, spacing: 2) {
                Text(style.displayName)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
                Text(description(for: style))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundStyle(Color.accentColor)
                    .fontWeight(.semibold)
            }
        }
    }
}
