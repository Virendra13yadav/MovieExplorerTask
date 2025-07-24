//
//  NotificationManager.swift
//  MovieExplorerTask
//
//  Created by Apple on 24/07/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            print("Notifications granted: \(granted)")
        }
    }

    func sendFavoriteNotification(for movieTitle: String) {
        let content = UNMutableNotificationContent()
        content.title = "🎬 Favorited Movie"
        content.body = "\"\(movieTitle)\" was added to your favorites!"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
