import Foundation
import Combine

final class SettingsViewModel: ObservableObject {
    private let defaults = UserDefaults.standard

    // MARK: - Keys
    private enum Keys {
        static let apiKey              = "openai_api_key"
        static let notificationEnabled = "notification_enabled"
        static let notificationHour    = "notification_hour"
        static let notificationMinute  = "notification_minute"
        static let defaultStyle        = "default_style"
    }

    // MARK: - Published Properties
    @Published var apiKey: String {
        didSet { defaults.set(apiKey, forKey: Keys.apiKey) }
    }

    @Published var notificationEnabled: Bool {
        didSet {
            defaults.set(notificationEnabled, forKey: Keys.notificationEnabled)
            refreshNotification()
        }
    }

    @Published var notificationTime: Date {
        didSet {
            let c = Calendar.current.dateComponents([.hour, .minute], from: notificationTime)
            defaults.set(c.hour   ?? 7, forKey: Keys.notificationHour)
            defaults.set(c.minute ?? 0, forKey: Keys.notificationMinute)
            refreshNotification()
        }
    }

    @Published var defaultStyle: PreviewStyle {
        didSet { defaults.set(defaultStyle.rawValue, forKey: Keys.defaultStyle) }
    }

    // MARK: - Init
    init() {
        apiKey              = defaults.string(forKey: Keys.apiKey) ?? ""
        notificationEnabled = defaults.bool(forKey: Keys.notificationEnabled)
        defaultStyle        = PreviewStyle(
            rawValue: defaults.string(forKey: Keys.defaultStyle) ?? ""
        ) ?? .shonen

        let hour   = defaults.object(forKey: Keys.notificationHour)   as? Int ?? 7
        let minute = defaults.object(forKey: Keys.notificationMinute) as? Int ?? 0
        var components = DateComponents()
        components.hour = hour; components.minute = minute
        notificationTime = Calendar.current.date(from: components) ?? Date()
    }

    // MARK: - Actions
    func sendTestNotification() {
        NotificationService.shared.scheduleTestNotification()
    }

    // MARK: - Private
    private func refreshNotification() {
        if notificationEnabled {
            let c = Calendar.current.dateComponents([.hour, .minute], from: notificationTime)
            NotificationService.shared.scheduleDailyReminder(
                hour: c.hour ?? 7, minute: c.minute ?? 0
            )
        } else {
            NotificationService.shared.cancelDailyReminder()
        }
    }
}
