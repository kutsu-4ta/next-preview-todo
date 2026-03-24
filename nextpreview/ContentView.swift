//
//  ContentView.swift
//  nextpreview
//
//  Created by Masafumi Yamashita on 2026/03/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PreviewPlayerView()
                .tabItem {
                    Label("今日の予告", systemImage: "play.tv.fill")
                }

            TaskListView()
                .tabItem {
                    Label("タスク", systemImage: "checklist")
                }

            SettingsView()
                .tabItem {
                    Label("設定", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TaskItem.self, inMemory: true)
}
