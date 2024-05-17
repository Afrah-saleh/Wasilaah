//
//  NotificationsListView.swift
//  Wasilaah
//
//  Created by Afrah Saleh on 09/11/1445 AH.
//

import SwiftUI
import UserNotifications

struct NotificationsListView: View {
    @ObservedObject var notificationManager = NotificationManager()

    var body: some View {
        NavigationView {
            List(notificationManager.notifications, id: \.request.identifier) { notification in
                VStack(alignment: .leading) {
                    Text(notification.request.content.title)
                        .font(.headline)
                    Text(notification.request.content.body)
                        .font(.subheadline)
                }
            }
            .navigationTitle("Delivered Notifications")
            .onAppear {
                notificationManager.refreshNotifications()
            }
        }
    }
}

#Preview {
    NotificationsListView()
}
