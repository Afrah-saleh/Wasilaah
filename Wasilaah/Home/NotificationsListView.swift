//
//  NotificationsListView.swift
//  Wasilaah
//
//  Created by Afrah Saleh on 09/11/1445 AH.
//
//
//import SwiftUI
//import UserNotifications
//
//struct NotificationsListView: View {
//    @ObservedObject var notificationManager = NotificationManager()
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        NavigationView {
//            VStack{
//            List(notificationManager.notifications, id: \.request.identifier) { notification in
//                VStack(alignment: .leading) {
//                    Text(notification.request.content.title)
//                        .font(.headline)
//                    Text(notification.request.content.body)
//                        .font(.subheadline)
//                }
//            }
//        }
//            .navigationBarItems(leading: Button(action: {
//                self.presentationMode.wrappedValue.dismiss()
//            }) {
//                Image(systemName: "chevron.left") // Customize your icon
//                    .foregroundColor(.black11) // Customize the color
//            })
//            .navigationBarTitle("Notifications", displayMode: .inline)
//            .onAppear {
//                notificationManager.refreshNotifications()
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}
//
//#Preview {
//    NotificationsListView()
//}


import SwiftUI
import UserNotifications

struct NotificationsListView: View {
    @ObservedObject var notificationManager = NotificationManager()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) { // Add spacing between notifications
                    ForEach(notificationManager.notifications, id: \.request.identifier) { notification in
                        HStack {
                            Image(systemName: "info.circle") // icon
                                .foregroundColor(.pprl) // icon color
                                .font(.system(size: 20)) // icon size
                                .padding(.trailing, 10) // space between icon and text

                            VStack(alignment: .leading, spacing: 5) {
                                Text(notification.request.content.title)
                                    .font(.headline)
                                Text(notification.request.content.body)
                                    .font(.subheadline)
                                    .foregroundColor(.gray) // making the body text gray
                            }
                            Spacer() // maintains alignment
                            
                            // Uncomment to show date if needed
                            // Text(notificationDate(notification.request)) // display the date
                            //     .font(.subheadline)
                            //     .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white11) // background color of the card
                        .cornerRadius(16) // rounded corners
                        .shadow(radius: 1) // shadow for 3D effect
                    }
                }
                .padding() // Padding around the entire VStack inside the ScrollView
            }
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            })
            .navigationBarTitle("Notifications", displayMode: .inline)
            .onAppear {
                notificationManager.refreshNotifications()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // Uncomment if using date functionality
    // private func notificationDate(_ request: UNNotificationRequest) -> String {
    //     let dateFormatter = DateFormatter()
    //     dateFormatter.dateFormat = "dd-MM-yyyy"
    //     if let trigger = request.trigger as? UNCalendarNotificationTrigger,
    //        let nextTriggerDate = trigger.nextTriggerDate() {
    //         return dateFormatter.string(from: nextTriggerDate)
    //     }
    //     return "No Date"
    // }
}

struct NotificationsListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsListView()
    }
}
