import AVFoundation

final class SpeechService: NSObject, ObservableObject {
    static let shared = SpeechService()

    @Published var isSpeaking = false
    @Published var progress: Double = 0

    private let synthesizer = AVSpeechSynthesizer()

    private override init() {
        super.init()
        synthesizer.delegate = self
    }

    /// 単体のテキストを読み上げる（キューをクリアしてから開始）
    func speak(_ text: String, style: PreviewStyle) {
        stop()
        configureAudioSession()
        enqueue(text, style: style)
        isSpeaking = true
    }

    /// 複数テキストを順番に読み上げる
    func speakAll(_ items: [(text: String, style: PreviewStyle)]) {
        stop()
        configureAudioSession()
        for item in items {
            enqueue(item.text, style: item.style)
        }
        isSpeaking = true
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
        progress = 0
    }

    func togglePause() {
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
        } else {
            synthesizer.pauseSpeaking(at: .word)
        }
    }

    // MARK: - Private

    private func enqueue(_ text: String, style: PreviewStyle) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = style.speechRate
        utterance.pitchMultiplier = style.speechPitch
        utterance.volume = 1.0
        utterance.postUtteranceDelay = 0.6
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        synthesizer.speak(utterance)
    }

    private func configureAudioSession() {
#if os(iOS)
        try? AVAudioSession.sharedInstance().setCategory(
            .playback,
            mode: .spokenAudio,
            options: .duckOthers
        )
        try? AVAudioSession.sharedInstance().setActive(true)
#endif
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension SpeechService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // キューが空になったら終了
        if !synthesizer.isSpeaking {
            DispatchQueue.main.async {
                self.isSpeaking = false
                self.progress = 1.0
            }
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.progress = 0
        }
    }

    func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        willSpeakRangeOfSpeechString characterRange: NSRange,
        utterance: AVSpeechUtterance
    ) {
        let total = Double(utterance.speechString.count)
        guard total > 0 else { return }
        let current = Double(characterRange.location + characterRange.length)
        DispatchQueue.main.async {
            self.progress = min(current / total, 1.0)
        }
    }
}
