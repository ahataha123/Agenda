//
//  NotificationManager.swift
//  Agendapp
//
//  Created by Muhammad Taha Imran on 25.12.25.
//


import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    // MARK: - Permission
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, _ in
            if granted {
                print("Notifications allowed")
            }
        }
    }

    // MARK: - Morning reminder
    func scheduleMorningReminder(taskCount: Int) {
        guard taskCount > 0 else { return }

        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Today's tasks"
        content.body = "You have \(taskCount) tasks to do today"
        content.sound = .default

        var date = DateComponents()
        date.hour = 09
        date.minute = 00

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: date,
            repeats: true   // 🔁 DAILY
        )

        let request = UNNotificationRequest(
            identifier: "morning-reminder",
            content: content,
            trigger: trigger
        )

        center.add(request)
    }


    // MARK: - Overdue notification 
    func scheduleOverdueNotification(for todo: Todo) {
        let center = UNUserNotificationCenter.current()

        let identifier = "overdue-\(todo.persistentModelID)"

        let content = UNMutableNotificationContent()
        content.title = "Task overdue"
        content.body = "\"\(todo.title)\" is overdue"
        content.sound = .default

        // 🔔 Fire at start of NEXT day (overdue moment)
        let triggerDate = Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: Calendar.current.startOfDay(for: todo.dueDate)
        )!

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: triggerDate
            ),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )

        center.add(request)
    }

}


