//
//  nextpreviewApp.swift
//  nextpreview
//
//  Created by Masafumi Yamashita on 2026/03/24.
//

import SwiftUI
import SwiftData

@main
struct nextpreviewApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: TaskItem.self)
        } catch {
            fatalError("SwiftData の初期化に失敗しました: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await NotificationService.shared.requestPermission()
                }
        }
        .modelContainer(container)
    }
}
