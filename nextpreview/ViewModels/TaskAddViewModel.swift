import Foundation
import SwiftData

@Observable
final class TaskAddViewModel {
    var title = ""
    var dueDate = Date()
    var selectedStyle: PreviewStyle = .shonen
    var generatedPreview = ""
    var isGenerating = false
    var errorMessage: String?
    var showError = false
    var previewGenerated = false

    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func generatePreview(apiKey: String) async {
        guard canSave else { return }
        isGenerating = true
        errorMessage = nil

        do {
            if apiKey.trimmingCharacters(in: .whitespaces).isEmpty {
                // APIキー未設定時はフォールバック（デモ用）
                try await Task.sleep(nanoseconds: 600_000_000)
                generatedPreview = OpenAIService.shared.fallbackPreview(
                    for: trimmedTitle, style: selectedStyle
                )
            } else {
                generatedPreview = try await OpenAIService.shared.generatePreview(
                    for: trimmedTitle, style: selectedStyle, apiKey: apiKey
                )
            }
            previewGenerated = true
        } catch {
            errorMessage = error.localizedDescription
            showError = true
            // エラー時はフォールバック予告文を使用
            generatedPreview = OpenAIService.shared.fallbackPreview(
                for: trimmedTitle, style: selectedStyle
            )
            previewGenerated = true
        }

        isGenerating = false
    }

    func save(context: ModelContext) {
        let item = TaskItem(title: trimmedTitle, dueDate: dueDate, style: selectedStyle)
        item.generatedPreview = generatedPreview
        context.insert(item)
        try? context.save()
    }

    func reset() {
        title = ""
        dueDate = Date()
        selectedStyle = .shonen
        generatedPreview = ""
        isGenerating = false
        errorMessage = nil
        showError = false
        previewGenerated = false
    }
}
