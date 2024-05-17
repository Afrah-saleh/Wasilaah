//
//  NotificationManager.swift
//  Wasilaah
//
//  Created by Afrah Saleh on 09/11/1445 AH.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    @Published var notifications: [UNNotification] = []

    init() {
        fetchDeliveredNotifications()
    }

    func fetchDeliveredNotifications() {
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            DispatchQueue.main.async {
                self.notifications = notifications
            }
        }
    }

    func refreshNotifications() {
        fetchDeliveredNotifications()
    }
}
