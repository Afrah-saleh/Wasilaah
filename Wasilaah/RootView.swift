//
//
////
////  RootView.swift
////  Namaa
////
////  Created by Afrah Saleh on 10/10/1445 AH.
////
//
//import Foundation
//import SwiftUI
//import FirebaseAuth
//import GoogleSignIn
//import GoogleSignInSwift
//
//struct RootView: View {
//    @StateObject var authViewModel: sessionStore
//    @StateObject var expenses: ExpensesViewModel
//    @State private var currentCard: Card? = nil
//    
//    var body: some View {
//        NavigationStack {
//            if authViewModel.signedIn {
//                if authViewModel.showPasscode {
//                    PasscodeEntryView()
//                        .environmentObject(authViewModel)
//                } else if authViewModel.needsCompanyInfo {
//                    CardsFirstTime(authViewModel: authViewModel, cardViewModel: CardViewModel(), card: $currentCard)
//                } else {
//                    Home(expensesViewModel: expenses, cardViewModel: CardViewModel())
//                }
//            } else {
//                SignUpView(authViewModel: authViewModel)
//            }
//        }
//        .onAppear {
//            setupNotifications()
//        }
//    }
//
//
//
//    private func setupNotifications() {
//        NotificationCenter.default.addObserver(
//            forName: UIApplication.didEnterBackgroundNotification,
//            object: nil,
//            queue: .main
//        ) { _ in
//            self.authViewModel.appDidEnterBackground()
//        }
//
//        NotificationCenter.default.addObserver(
//            forName: UIApplication.didBecomeActiveNotification,
//            object: nil,
//            queue: .main
//        ) { _ in
//            self.authViewModel.appDidBecomeActive()
//        }
//    }
//}
//





//
//  RootView.swift
//  Namaa
//
//  Created by Afrah Saleh on 10/10/1445 AH.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct RootView: View {
    @StateObject var authViewModel: sessionStore
    @StateObject var expenses: ExpensesViewModel
    @State private var currentCard: Card? = nil
    @State private var showSplashScreen = true  // State to control the display of the SplashScreen

    var body: some View {
        NavigationStack {
            // Check if the splash screen should be shown
            if showSplashScreen {
                SplashScreen()
                    .onAppear {
                        // Hide the splash screen after a delay (e.g., 3 seconds)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showSplashScreen = false
                        }
                    }
            } else {
                // Your existing conditions and views
                if authViewModel.signedIn {
                    if authViewModel.showPasscode {
                        PasscodeEntryView()
                            .environmentObject(authViewModel)
                    } else if authViewModel.needsCompanyInfo {
                        CardsFirstTime(authViewModel: authViewModel, cardViewModel: CardViewModel(), card: $currentCard)
                    } else {
                        Home(expensesViewModel: expenses, cardViewModel: CardViewModel())
                    }
                } else {
                    // Show SignUpView if not signed in
                    SignUpView(authViewModel: authViewModel)
                }
            }
        }
        .onAppear {
            setupNotifications()
        }
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.authViewModel.appDidEnterBackground()
        }

        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.authViewModel.appDidBecomeActive()
        }
    }
}

