//
//  SetPasscodeView.swift
//  Namaa
//
//  Created by Afrah Saleh on 27/10/1445 AH.
//


import SwiftUI

struct SetPasscodeView: View {
    @State private var passcode: String = ""
    @State private var navigateToHome = false
    @State private var errorShowing = false
    @State private var errorMessage = ""
    @EnvironmentObject var authViewModel: sessionStore
    @EnvironmentObject var expensesViewModel: ExpensesViewModel
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    Text("Set Your Password")
                        .font(.title2)
                    
                    // Passcode indicators
                    HStack(spacing: 15) {
                        ForEach(0..<4, id: \.self) { index in
                            Circle()
                                .fill(passcode.count > index ? Color.black : Color.clear)
                                .frame(width: 20, height: 20)
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        }
                    }
                    .padding(.bottom)
                    Spacer()
                    // Custom numeric keypad
                    CustomNumericKeypad(passcode: $passcode, onFaceID: {
                
                    })
                    .frame(height: geometry.size.height * 0.6) // Adjust this value based on your keypad size
                    .padding(.bottom)
                    
                }
                .padding()
                .navigationTitle("Wasilaah")
                .navigationBarTitleDisplayMode(.inline)
                .alert(isPresented: $errorShowing) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
                .onChange(of: passcode) { newValue in
                    if newValue.count == 4 {
                        do {
                            try KeychainHelper.savePasscode(passcode: passcode, account: "userSecondaryPasscode")
                            DispatchQueue.main.async {
                                navigateToHome = true
                            }
                        } catch {
                            print("Failed to save passcode: \(error)")
                            errorMessage = "Failed to save passcode: \(error.localizedDescription)"
                            errorShowing = true
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToHome ) {
                Home(expensesViewModel: expensesViewModel ,cardViewModel: CardViewModel())
                    .environmentObject(expensesViewModel)  // Make sure EnvironmentObject is passed here if needed
                            .environmentObject(CardViewModel())  // Assuming CardViewModel is also required
            }

        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SetPasscodeView_Previews: PreviewProvider {
    static var previews: some View {
        SetPasscodeView()
    }
}
