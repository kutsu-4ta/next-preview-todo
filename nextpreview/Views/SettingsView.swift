import SwiftUI

struct SettingsView: View {
    @StateObject private var vm = SettingsViewModel()
    @State private var showAPIKey = false
    @State private var notificationStatus = ""

    var body: some View {
        NavigationStack {
            Form {
                apiKeySection
                notificationSection
                styleSection
                aboutSection
            }
            .navigationTitle("設定")
            .task { await checkNotificationStatus() }
        }
    }

    // MARK: - API Key Section
    private var apiKeySection: some View {
        Section {
            HStack {
                Group {
                    if showAPIKey {
                        TextField("sk-...", text: $vm.apiKey)
                            .font(.system(.body, design: .monospaced))
                    } else {
                        SecureField("sk-...", text: $vm.apiKey)
                    }
                }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

                Button {
                    showAPIKey.toggle()
                } label: {
                    Image(systemName: showAPIKey ? "eye.slash" : "eye")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            apiKeyStatus
        } header: {
            Text("OpenAI APIキー")
        } footer: {
            Text("OpenAI Platform でAPIキーを取得してください。設定しない場合はサンプル予告文が表示されます。")
        }
    }

    @ViewBuilder
    private var apiKeyStatus: some View {
        if vm.apiKey.isEmpty {
            Label("APIキー未設定。フォールバック予告文が使われます", systemImage: "info.circle")
                .font(.caption)
                .foregroundStyle(.orange)
        } else {
            Label("APIキーが設定されています", systemImage: "checkmark.circle.fill")
                .font(.caption)
                .foregroundStyle(.green)
        }
    }

    // MARK: - Notification Section
    @ViewBuilder
    private var notificationSection: some View {
        Section("毎朝の通知") {
            Toggle("通知を有効にする", isOn: $vm.notificationEnabled)
            if vm.notificationEnabled {
                DatePicker("通知時刻", selection: $vm.notificationTime, displayedComponents: .hourAndMinute)
                Button("テスト通知を送る（5秒後）") {
                    vm.sendTestNotification()
                }
                .foregroundStyle(Color.accentColor)
            }
            if !notificationStatus.isEmpty {
                Text(notificationStatus)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Style Section
    private var styleSection: some View {
        Section("デフォルト予告スタイル") {
            ForEach(PreviewStyle.allCases) { style in
                HStack {
                    Text(style.emoji)
                    Text(style.displayName)
                    Spacer()
                    if vm.defaultStyle == style {
                        Image(systemName: "checkmark").foregroundStyle(Color.accentColor)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture { vm.defaultStyle = style }
            }
        }
    }

    // MARK: - About Section
    private var aboutSection: some View {
        Section("アプリについて") {
            LabeledContent("バージョン") { Text(appVersion) }
            LabeledContent("ビルド") { Text(buildNumber) }
            Link("OpenAI Platform", destination: URL(string: "https://platform.openai.com")!)
        }
    }

    // MARK: - Helpers
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    private func checkNotificationStatus() async {
        let status = await NotificationService.shared.authorizationStatus()
        switch status {
        case .authorized:    notificationStatus = "通知が許可されています"
        case .denied:        notificationStatus = "通知が拒否されています。システム設定から変更してください"
        case .notDetermined: notificationStatus = "通知の許可が必要です"
        default:             notificationStatus = ""
        }
    }
}
