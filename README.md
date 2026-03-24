# 次回予告リマインダー

> 「次回、燃えないゴミ出し！逃げ場なし！ぜってぇ見てくれよな！」

地味なタスクを、アニメ・映画の次回予告風に読み上げてくれるスケジュール管理アプリ。
「やらなきゃ」を「楽しみ」に変える、ちょっとおかしなリマインダーです。

---

## スクリーンショット

| 今日の予告 | タスク追加 | 設定 |
|:-:|:-:|:-:|
| *(PreviewPlayer)* | *(TaskAdd)* | *(Settings)* |

---

## 機能

### 予告スタイル

タスクごとに5つのスタイルから選べます。

| スタイル | イメージ |
|---|---|
| 🔥 熱血少年漫画風 | 「ぜってぇ見てくれよな！」 |
| 🌸 少女漫画風 | 「絶対に見てね♡」 |
| 🔍 ミステリーアニメ風 | 「真実はいつもひとつ！」 |
| 🎬 壮大な映画予告風 | 「全米が泣いた」 |
| 🎭 海外ドラマ吹き替え風 | 「冗談はやめてくれよ、ボブ」 |

### AI 予告文生成

入力した素っ気ないタスク名を、OpenAI (GPT-4o-mini) が選択スタイルに合わせて予告文に変換します。

```
入力:  歯医者
出力:  「歯医者！鳴り響くドリルの咆哮！
        だが俺はまだ諦めない——次回、決戦の診察台！
        ぜってぇ見てくれよな！」
```

APIキー未設定でもフォールバック予告文が生成されるので、まずはお試しいただけます。

### 音声読み上げ

AVSpeechSynthesizer（日本語）でスタイルごとに声のピッチと速度を調整して読み上げます。
複数タスクを「全部まとめて再生」でメドレー再生も可能。

### 毎朝の通知

設定した時刻に毎日通知が届きます。タップするとその日のタスク予告がまとめて表示されます。

### To Be Continued...

昨日できなかったタスクは「To Be Continued...」セクションに自動移動。
明日こそ、という気持ちにさせてくれます。

---

## 技術スタック

| カテゴリ | 採用技術 |
|---|---|
| 言語・UI | Swift / SwiftUI |
| アーキテクチャ | MVVM |
| データ永続化 | SwiftData |
| 通知 | UserNotifications |
| AI 予告文生成 | OpenAI API (GPT-4o-mini) |
| 音声合成 | AVSpeechSynthesizer |
| 最低 iOS バージョン | iOS 18.2 |

---

## セットアップ

### 1. リポジトリをクローン

```bash
git clone https://github.com/your-username/nextpreview.git
cd nextpreview
```

### 2. Xcode で開く

```bash
open nextpreview.xcodeproj
```

### 3. OpenAI APIキーを設定（任意）

アプリを起動後、**設定タブ** から OpenAI APIキーを入力します。
未設定でもフォールバック予告文でアプリを使えます。

APIキーは [OpenAI Platform](https://platform.openai.com) で取得できます。

---

## 使い方

1. **タスクタブ** の `+` ボタンからタスクを追加
2. タスク名・日付・予告スタイルを選択
3. 「予告文を生成する」ボタンで AI が予告文を作成
4. 「読み上げ」で音声確認してから保存
5. **今日の予告タブ** で「全部まとめて再生」を押す
6. 毎朝、設定した時刻に通知が届く

---

## ファイル構成

```
nextpreview/
├── Models/
│   ├── TaskItem.swift          # SwiftData モデル
│   └── PreviewStyle.swift      # スタイル定義（UI・音声・プロンプト）
├── Services/
│   ├── OpenAIService.swift     # GPT-4o-mini API クライアント
│   ├── NotificationService.swift # 通知スケジュール管理
│   └── SpeechService.swift     # 音声合成（キュー対応）
├── ViewModels/
│   ├── TaskListViewModel.swift
│   ├── TaskAddViewModel.swift
│   └── SettingsViewModel.swift
└── Views/
    ├── PreviewPlayerView.swift  # 今日の予告（メイン画面）
    ├── TaskListView.swift
    ├── TaskAddView.swift
    ├── SettingsView.swift
    └── Components/
        ├── PreviewCardView.swift      # スタイル別グラデーションカード
        ├── ToBeContinuedSection.swift
        └── SoundWaveBar.swift         # 再生中アニメーション
```

---

## 今後のアイデア

- **ElevenLabs API 対応** — より豪華でキャラクター性の高い声に
- **BGM 自動生成** — スタイルに合わせた効果音・BGM の再生
- **ウィジェット** — ホーム画面に今日の予告を表示
- **Apple Watch 対応** — 手首で予告を受け取る

---

## ライセンス

MIT License

---

> *「やれやれ……また月曜日だって？冗談はやめてくれよ、まったく。」*
