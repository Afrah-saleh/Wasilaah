//
//  WasilaahApp.swift
//  Wasilaah
//
//  Created by Afrah Saleh on 08/11/1445 AH.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    @ObservedObject var appState = AppState()

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Show passcode entry screen when the app becomes active
        appState.showPasscodeEntry = true
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "HasLaunchedOnce") {
            defaults.set(true, forKey: "HasLaunchedOnce")
            defaults.synchronize()

            deleteKeychainItems()

            do {
                try Auth.auth().signOut()
            } catch let error {
                print("Error signing out: \(error)")
            }
        }
        requestNotificationPermission()
        return true
    }

    func requestNotificationPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

    func deleteKeychainItems() {
        let secItemClasses = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
        for secItemClass in secItemClasses {
            let dictionary = [kSecClass as String: secItemClass]
            SecItemDelete(dictionary as CFDictionary)
        }
    }
}
@main
struct WasilaahApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authService = sessionStore()
    @StateObject var transactionViewModel = TransactionViewModel()
    @StateObject var expensesViewModel = ExpensesViewModel(cardID: "")
    @StateObject var appState = AppState()

    init() {
        UINavigationBar.appearance().tintColor = .red
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "custom_back_icon")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "custom_back_icon")
    }

    var body: some Scene {
        WindowGroup {
            if appState.showSplashScreen {
                SplashScreen()
                    .environmentObject(appState)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Adjust time as needed
                            withAnimation {
                                appState.showSplashScreen = false
                                appState.showPasscodeEntry = true
                            }
                        }
                    }
            } else if appState.showPasscodeEntry {
                PasscodeEntryView()
                    .environmentObject(authService)
                    .environmentObject(transactionViewModel)
                    .environmentObject(expensesViewModel)
                    .environmentObject(appState)
            } else {
                RootView(authViewModel: authService, expenses: ExpensesViewModel(cardID: ""))
                    .environmentObject(authService)
                    .environmentObject(transactionViewModel)
                    .environmentObject(expensesViewModel)
            }
        }
    }
}
//           RootView(authViewModel: authService, expenses: ExpensesViewModel(cardID: ""))
//            .environmentObject(authService) // Pass the authService to your views
//                //.environmentObject(ExpensesViewModel(cardID: "")) // Pass ExpensesViewModel here if it's needed globally
//                .environmentObject(transactionViewModel)
//                .environmentObject(expensesViewModel)
//            .onAppear {
//                authService.checkCurrentUser()
//            }
//        }
//    }
//}
class AppState: ObservableObject {
    @Published var showPasscodeEntry: Bool = false
    @Published var showSplashScreen: Bool = true
}
