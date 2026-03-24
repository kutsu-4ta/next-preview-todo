import SwiftUI

enum PreviewStyle: String, CaseIterable, Identifiable {
    case shonen = "shonen"
    case shojo = "shojo"
    case mystery = "mystery"
    case movie = "movie"
    case overseas = "overseas"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .shonen:  return "熱血少年漫画風"
        case .shojo:   return "少女漫画風"
        case .mystery: return "ミステリーアニメ風"
        case .movie:   return "壮大な映画予告風"
        case .overseas: return "海外ドラマ吹き替え風"
        }
    }

    var emoji: String {
        switch self {
        case .shonen:  return "🔥"
        case .shojo:   return "🌸"
        case .mystery: return "🔍"
        case .movie:   return "🎬"
        case .overseas: return "🎭"
        }
    }

    var accentColor: Color {
        switch self {
        case .shonen:  return Color(red: 1.0, green: 0.27, blue: 0.0)
        case .shojo:   return Color(red: 1.0, green: 0.41, blue: 0.71)
        case .mystery: return Color(red: 0.28, green: 0.24, blue: 0.55)
        case .movie:   return Color(red: 0.85, green: 0.65, blue: 0.13)
        case .overseas: return Color(red: 0.18, green: 0.55, blue: 0.34)
        }
    }

    var gradientColors: [Color] {
        switch self {
        case .shonen:  return [Color(red: 0.6, green: 0.1, blue: 0.0), Color(red: 0.15, green: 0.05, blue: 0.0)]
        case .shojo:   return [Color(red: 0.5, green: 0.1, blue: 0.3), Color(red: 0.15, green: 0.05, blue: 0.1)]
        case .mystery: return [Color(red: 0.1, green: 0.1, blue: 0.3), Color(red: 0.03, green: 0.03, blue: 0.1)]
        case .movie:   return [Color(red: 0.3, green: 0.25, blue: 0.0), Color(red: 0.1, green: 0.08, blue: 0.0)]
        case .overseas: return [Color(red: 0.05, green: 0.25, blue: 0.15), Color(red: 0.02, green: 0.08, blue: 0.05)]
        }
    }

    var systemPrompt: String {
        switch self {
        case .shonen:
            return """
            あなたは熱血少年漫画の次回予告ナレーターです。
            ユーザーのタスクを熱血少年漫画風の次回予告に変換してください。
            戦いや友情・限界突破などの要素を絡め、「次回、〇〇！ぜってぇ見てくれよな！」のような熱いセリフで締めてください。
            全体で3〜4文、テンションMAXで！日本語のみで回答。
            """
        case .shojo:
            return """
            あなたは少女漫画の次回予告ナレーターです。
            ユーザーのタスクをときめきと感動あふれる少女漫画風の次回予告に変換してください。
            恋や運命・心のときめきを絡め、「次回、〇〇。絶対に見てね♡」のような甘くドラマチックなセリフで締めてください。
            全体で3〜4文、キラキラと輝く表現で！日本語のみで回答。
            """
        case .mystery:
            return """
            あなたはミステリーアニメの次回予告ナレーターです（某有名探偵アニメ風）。
            ユーザーのタスクを謎めいたミステリー風の次回予告に変換してください。
            謎や推理の要素を絡め、「真実はいつもひとつ！」の決め台詞を必ず入れてください。
            全体で3〜4文、謎と驚きに満ちた表現で！日本語のみで回答。
            """
        case .movie:
            return """
            あなたはハリウッド大作映画の予告ナレーターです。
            ユーザーのタスクを壮大で感動的な映画予告風に変換してください。
            「全米が泣いた」「今、伝説が始まる」「一人の男の命がけの戦い」のような大げさな表現を使ってください。
            全体で3〜4文、壮大なスケールで！日本語のみで回答。
            """
        case .overseas:
            return """
            あなたは海外ドラマの吹き替えナレーターです。
            ユーザーのタスクを海外ドラマの吹き替え風の次回予告に変換してください。
            「やれやれ」「冗談はやめてくれよ、ボブ」「信じられない…」などの吹き替えっぽい口調でシュールな感じにしてください。
            全体で3〜4文！日本語のみで回答。
            """
        }
    }

    var speechRate: Float {
        switch self {
        case .shonen:  return 0.57
        case .shojo:   return 0.48
        case .mystery: return 0.50
        case .movie:   return 0.43
        case .overseas: return 0.52
        }
    }

    var speechPitch: Float {
        switch self {
        case .shonen:  return 1.2
        case .shojo:   return 1.25
        case .mystery: return 0.85
        case .movie:   return 0.75
        case .overseas: return 1.0
        }
    }

    var fallbackPreview: (String) -> String {
        switch self {
        case .shonen:
            return { title in "次回、\(title)との死闘！俺の魂、燃え尽きるまで諦めねぇ！ぜってぇ見てくれよな！" }
        case .shojo:
            return { title in "次回、\(title)……運命の糸が、今、絡まりはじめる。ドキドキが止まらない……絶対に見てね♡" }
        case .mystery:
            return { title in "次回、\(title)の謎が今、明かされる！一見単純なこの事件、しかし落とし穴があった！真実はいつもひとつ！" }
        case .movie:
            return { title in "全米が泣いた。\(title)——今、伝説が始まる。" }
        case .overseas:
            return { title in "やれやれ……また\(title)だって？冗談はやめてくれよ、まったく。" }
        }
    }
}
