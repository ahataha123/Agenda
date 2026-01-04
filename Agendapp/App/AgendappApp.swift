//
//  AgendappApp.swift
//  Agendapp
//
//  Created by Muhammad Taha Imran on 03.12.25.
//
import SwiftUI
import SwiftData
import UserNotifications

@main
struct AgendaappApp: App {

    
    @AppStorage("forceDarkMode") private var forceDarkMode = false

    init() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { _, _ in }

        scheduleMorningIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Apply dark mode globally
                .preferredColorScheme(forceDarkMode ? .dark : nil)
        }
        .modelContainer(for: Todo.self)
    }

    private func scheduleMorningIfNeeded() {
        Task {
            let container = try ModelContainer(for: Todo.self)
            let context = container.mainContext

            let todayTodos = try context.fetch(
                FetchDescriptor<Todo>()
            ).filter {
                $0.isDueToday && $0.completedAt == nil
            }

            NotificationManager.shared.scheduleMorningReminder(
                taskCount: todayTodos.count
            )
        }
    }
}


