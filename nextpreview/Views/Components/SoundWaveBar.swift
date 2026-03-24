import SwiftUI

/// 音声再生中に表示するサウンドウェーブアニメーション
struct SoundWaveBar: View {
    let delay: Double
    @State private var isAnimating = false

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .frame(width: 4, height: isAnimating ? 20 : 6)
            .animation(
                .easeInOut(duration: 0.5)
                    .repeatForever(autoreverses: true)
                    .delay(delay),
                value: isAnimating
            )
            .onAppear { isAnimating = true }
    }
}

struct SoundWaveView: View {
    var color: Color = .accentColor
    var barCount: Int = 5

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<barCount, id: \.self) { i in
                SoundWaveBar(delay: Double(i) * 0.15)
                    .foregroundStyle(color)
            }
        }
        .frame(height: 24)
    }
}

#Preview {
    SoundWaveView()
        .padding()
}
