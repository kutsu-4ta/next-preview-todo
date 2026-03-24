import Foundation

final class OpenAIService {
    static let shared = OpenAIService()
    private init() {}

    private let endpoint = "https://api.openai.com/v1/chat/completions"

    func generatePreview(
        for taskTitle: String,
        style: PreviewStyle,
        apiKey: String
    ) async throws -> String {
        guard !apiKey.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw OpenAIError.noAPIKey
        }
        guard let url = URL(string: endpoint) else {
            throw OpenAIError.invalidURL
        }

        var request = URLRequest(url: url, timeoutInterval: 30)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "system", "content": style.systemPrompt],
                ["role": "user", "content": "タスク名: \(taskTitle)"]
            ],
            "max_tokens": 300,
            "temperature": 0.9
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw OpenAIError.invalidResponse
        }
        switch http.statusCode {
        case 200:
            break
        case 401:
            throw OpenAIError.unauthorized
        default:
            throw OpenAIError.httpError(http.statusCode)
        }

        let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        guard let content = decoded.choices.first?.message.content else {
            throw OpenAIError.emptyResponse
        }
        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func fallbackPreview(for title: String, style: PreviewStyle) -> String {
        style.fallbackPreview(title)
    }
}

// MARK: - Errors
enum OpenAIError: LocalizedError {
    case noAPIKey, invalidURL, invalidResponse, unauthorized, emptyResponse, httpError(Int)

    var errorDescription: String? {
        switch self {
        case .noAPIKey:       return "OpenAI APIキーが設定されていません"
        case .invalidURL:     return "無効なURLです"
        case .invalidResponse: return "サーバーからの応答が無効です"
        case .unauthorized:   return "APIキーが無効です。設定を確認してください"
        case .emptyResponse:  return "AIからの応答が空でした"
        case .httpError(let c): return "HTTPエラー: \(c)"
        }
    }
}

// MARK: - Response
private struct OpenAIResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable { let content: String }
        let message: Message
    }
    let choices: [Choice]
}
