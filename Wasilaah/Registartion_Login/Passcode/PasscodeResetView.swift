////
////  PasscodeResetView.swift
////  Namaa
////
////  Created by Afrah Saleh on 07/11/1445 AH.
////
//
//import SwiftUI
//
//import SwiftUI
//
//struct PasscodeResetView: View {
//    @ObservedObject var userProfileRepository = UserProfileRepository()
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var errorMessage: String?
//    @State private var showPasscodeResetField = false
//    @State private var newPasscode: String = ""
//
//    var body: some View {
//        NavigationView {
//            Form {
//                // Section for user credentials verification
//                Section(header: Text("Verify Your Credentials")) {
//                    TextField("Email", text: $email)
//                    SecureField("Password", text: $password)
//                    if let message = errorMessage {
//                        Text(message).foregroundColor(.red)
//                    }
//                    Button("Verify and Reset Passcode") {
//                        verifyCredentialsAndResetPasscode()
//                    }
//                }
//                
//                // Conditionally show the section for setting a new passcode
//                if showPasscodeResetField {
//                    Section(header: Text("Set New Passcode")) {
//                        SecureField("New Passcode", text: $newPasscode)
//                        Button("Set New Passcode") {
//                            setNewPasscode()
//                        }
//                    }
//                }
//            }
//            .navigationBarTitle("Reset Passcode", displayMode: .inline)
//        }
//    }
//
//    private func verifyCredentialsAndResetPasscode() {
//        // Simulate credential verification
//        if email == userProfileRepository.email && password == userProfileRepository.password {
//            do {
//                let exists = KeychainHelper.checkPasscodeExists(account: email)
//                if exists {
//                    try KeychainHelper.deletePasscode(account: email)
//                }
//                // Enable the field to set a new passcode
//                self.showPasscodeResetField = true
//                self.errorMessage = nil
//            } catch let error {
//                print("Error during passcode deletion: \(error.localizedDescription)")
//                self.errorMessage = "Failed to delete existing passcode."
//            }
//        } else {
//            self.errorMessage = "Invalid credentials. Please try again."
//            self.showPasscodeResetField = false
//        }
//    }
//
//    private func setNewPasscode() {
//        do {
//            try KeychainHelper.savePasscode(passcode: newPasscode, account: email)
//            self.errorMessage = "Passcode has been reset successfully."
//            self.showPasscodeResetField = false // Optionally hide after successful reset
//        } catch {
//            self.errorMessage = "Failed to set new passcode."
//        }
//    }
//}
//
//struct PasscodeResetView_Previews: PreviewProvider {
//    static var previews: some View {
//        PasscodeResetView()
//    }
//}
