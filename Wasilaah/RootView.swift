

//
//  RootView.swift
//  Namaa
//
//  Created by Afrah Saleh on 10/10/1445 AH.
//

import Foundation
import SwiftUI
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct RootView: View {
    @StateObject var authViewModel: sessionStore
    @StateObject var expenses: ExpensesViewModel
    @State private var currentCard: Card? = nil
    
    var body: some View {
        NavigationStack {
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
                SignUpView(authViewModel: authViewModel)
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

