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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
  
      // Check if this is the first launch after installation
      let defaults = UserDefaults.standard
      if !defaults.bool(forKey: "HasLaunchedOnce") {
          // This is the first launch after installation
          defaults.set(true, forKey: "HasLaunchedOnce")
          defaults.synchronize()
          
          // Clear Keychain items
          deleteKeychainItems()
          
          // Optionally, force log out the user if needed (Firebase specific)
          do {
              try Auth.auth().signOut()
          } catch let error {
              print("Error signing out: \(error)")
          }
      }

      return true
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

    init() {
        // Customizing back button appearance
        UINavigationBar.appearance().tintColor = .red // Changes the color of the back button
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "custom_back_icon")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "custom_back_icon")
    }

    var body: some Scene {
        WindowGroup {
          //  SplashScreen()
           RootView(authViewModel: authService, expenses: ExpensesViewModel(cardID: ""))
            .environmentObject(authService) // Pass the authService to your views
                .environmentObject(ExpensesViewModel(cardID: "")) // Pass ExpensesViewModel here if it's needed globally
            .onAppear {
                authService.checkCurrentUser()
            }
        }
    }
}
