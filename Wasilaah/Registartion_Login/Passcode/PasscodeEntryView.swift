//import SwiftUI
//import LocalAuthentication
//
//struct PasscodeEntryView: View {
//    @State private var passcode: String = ""
//    @State private var showError: Bool = false
//    @EnvironmentObject var authViewModel: sessionStore
//    @EnvironmentObject var appState: AppState
//    @State private var isUnlocked = false
//    @State private var showingFaceIDAlert = false
//    @State private var shouldShowReset = false
//
//    var body: some View {
//        NavigationView {
//            GeometryReader { geometry in
//                VStack {
//                    VStack(spacing: 10) {
//                        Spacer()
//                        Text("Enter Passcode")
//                            .font(.title)
//                            .padding(.bottom, 40)
//                        HStack(spacing: 15) {
//                            ForEach(0..<4, id: \.self) { index in
//                                Circle()
//                                    .fill(passcode.count > index ? Color.pprl : Color.gray.opacity(0.5))
//                                    .frame(width: 15, height: 15)
//                            }
//                        }
//                    }
//                    .frame(height: geometry.size.height * 0.3)
//                    Spacer()
//                    if showError {
//                        Text("Incorrect passcode. Please try again`")
//                            .foregroundColor(.red)
//                            .padding(.all)
//                    }
//                    CustomNumericKeypad(passcode: $passcode, onFaceID: authenticate)
//                        .frame(height: geometry.size.height * 0.6)
//                        .padding(.bottom)
//                }
//                .navigationTitle("Wasilaah")
//                .navigationBarTitleDisplayMode(.inline)
//                .alert("Face ID Error", isPresented: $showingFaceIDAlert) {
//                    Button("OK", role: .cancel) { }
//                } message: {
//                    Text("Face ID could not authenticate you.")
//                }
//                .onAppear {
//                    authenticate()
//                }
//                .onChange(of: passcode) { newValue in
//                    if newValue.count == 4 {
//                        if let storedPasscode = KeychainHelper.getPasscode(account: "userSecondaryPasscode"), storedPasscode == passcode {
//                            appState.showPasscodeEntry = false // Hide the passcode view
//                            showError = false
//                        } else {
//                            showError = true
//                            passcode = "" // Reset passcode after a failed attempt
//                        }
//                    }
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//
//
//    func authenticate() {
//        let context = LAContext()
//        var error: NSError?
//
//        // Check if Face ID is available
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            let reason = "Authenticate with Face ID to access your account"
//
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//                DispatchQueue.main.async {
//                    if success {
//                        isUnlocked = true
//                        appState.showPasscodeEntry = false // Hide the passcode view
//
//                       // navigateToHome = true
//                    } else {
//                        showingFaceIDAlert = true
//                    }
//                }
//            }
//        } else {
//            // Face ID not available
//        }
//    }
//}
//
//struct CustomNumericKeypad: View {
//    @Binding var passcode: String
//    let onFaceID: () -> Void
//    
//    let buttonBackgroundColor = Color.white11.opacity(0.2)
//    let textColor = Color.pprl
//    let keypadBackgroundColor = Color.white11
//
//    var body: some View {
//        GeometryReader { geometry in
//            let columns = 3
//            let spacing = geometry.size.width / 25
//            let buttonSize = (geometry.size.width - (spacing * CGFloat(columns + 1))) / CGFloat(columns)
//
//            VStack(spacing: spacing) {
//                // Numeric buttons
//                ForEach(0..<3, id: \.self) { row in
//                    HStack(spacing: spacing) {
//                        ForEach(1..<4, id: \.self) { column in
//                            let number = row * 3 + column
//                            Button(action: {
//                                passcode.append(String(number))
//                            }) {
//                                Text("\(number)")
//                                    .font(.title)
//                                    .frame(width: buttonSize, height: buttonSize)
//                                    .background(buttonBackgroundColor)
//                                    .foregroundColor(textColor)
//                                    .cornerRadius(buttonSize / 2)
//                            }
//                        }
//                    }
//                }
//
//                // Face ID and delete buttons
//                HStack(spacing: spacing) {
//                    Button(action: onFaceID) {
//                        Image(systemName: "faceid")
//                            .font(.title)
//                            .frame(width: buttonSize, height: buttonSize)
//                            .background(buttonBackgroundColor)
//                            .foregroundColor(textColor)
//                            .cornerRadius(buttonSize / 2)
//                    }
//
//                    Button("0") {
//                        passcode.append("0")
//                    }
//                    .font(.title)
//                    .frame(width: buttonSize, height: buttonSize)
//                    .background(buttonBackgroundColor)
//                    .foregroundColor(textColor)
//                    .cornerRadius(buttonSize / 2)
//
//                    Button(action: {
//                        if !passcode.isEmpty {
//                            passcode.removeLast()
//                        }
//                    }) {
//                        Image(systemName: "delete.left")
//                            .font(.title)
//                            .frame(width: buttonSize, height: buttonSize)
//                            .background(buttonBackgroundColor)
//                            .foregroundColor(textColor)
//                            .cornerRadius(buttonSize / 2)
//                    }
//                }
//            }
//            .padding(spacing)
//            .frame(width: geometry.size.width, height: geometry.size.height)
//            .background(keypadBackgroundColor)
//            .cornerRadius(12)
//        }
//        .padding(.horizontal)
//        .ignoresSafeArea(edges: .bottom)
//    }
//}
//struct PasscodeEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        PasscodeEntryView().environmentObject(sessionStore())
//    }
//}




import SwiftUI
import LocalAuthentication

struct PasscodeEntryView: View {
    @State private var passcode: String = ""
    @State private var showError: Bool = false
    @EnvironmentObject var authViewModel: sessionStore
    @State private var navigateToHome = false // State to control navigation
    // State to handle Face ID authentication
    @State private var isUnlocked = false
    @State private var showingFaceIDAlert = false
    @State private var shouldShowReset = false

    var body: some View {
            NavigationView {
                GeometryReader { geometry in
                    VStack {
                        VStack(spacing: 10) {
                            Spacer()
                            
                            Text("Enter Passcode")
                                .font(.title)
                                .padding(.bottom,40)
                            
                            // Dots for the passcode
                            HStack(spacing: 15) {
                                ForEach(0..<4, id: \.self) { index in
                                    Circle()
                                        .fill(passcode.count > index ? Color.pprl : Color.gray.opacity(0.5))
                                        .frame(width: 15, height: 15)
                                }
                            }
                        }
                        .frame(height: geometry.size.height * 0.3) // Adjust this value based on your content size
                        
                        Spacer()
                        if showError {
                            Text("Incorrect passcode. Please try again.")
                                .foregroundColor(.red)
                                .padding(.all)
                        }
//                        Button("Reset Passcode") {
//                            // Perform any checks or preparations here
//                            self.shouldShowReset = true
//                        } .buttonStyle(.borderedProminent) // Optional: Styling the button
                        // Custom Keypad
                        CustomNumericKeypad(passcode: $passcode, onFaceID: authenticate)
                            .frame(height: geometry.size.height * 0.6) // Adjust this value based on your keypad size
                            .padding(.bottom)
                            .background(Color.white11)
                        
                    }
                    
//                    .navigationDestination(isPresented: $shouldShowReset) {
//                        PasscodeResetView()
//                    }
                }
                .navigationTitle("Wasilaah")
                .navigationBarTitleDisplayMode(.inline)
                .alert("Face ID Error", isPresented: $showingFaceIDAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Face ID could not authenticate you.")
                }
                .onAppear {
                    // Automatically trigger Face ID authentication
                    authenticate()
                }
                .navigationDestination(isPresented: $navigateToHome) {
                    Home(expensesViewModel: ExpensesViewModel(cardID: ""),cardViewModel: CardViewModel())
                        .environmentObject(authViewModel)
                }
            }
        
            .onChange(of: passcode) { newValue in
                if newValue.count == 4 {
                    // Retrieve the passcode from Keychain and check if it matches the entered passcode
                    if let storedPasscode = KeychainHelper.getPasscode(account: "userSecondaryPasscode"), storedPasscode == passcode {
                        navigateToHome = true
                        showError = false
                    } else {
                        showError = true
                        passcode = "" // Reset passcode after a failed attempt
                    }
                }
            }
        }

    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // Check if Face ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with Face ID to access your account"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isUnlocked = true
                        navigateToHome = true
                    } else {
                        showingFaceIDAlert = true
                    }
                }
            }
        } else {
            // Face ID not available
        }
    }
}

struct CustomNumericKeypad: View {
    @Binding var passcode: String
    let onFaceID: () -> Void
    
    let buttonBackgroundColor = Color.white11
    let textColor = Color.pprl
    let keypadBackgroundColor = Color.white11

    var body: some View {
        GeometryReader { geometry in
            let columns = 3
            let spacing = geometry.size.width / 25
            let buttonSize = (geometry.size.width - (spacing * CGFloat(columns + 1))) / CGFloat(columns)

            VStack(spacing: spacing) {
                // Numeric buttons
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(1..<4, id: \.self) { column in
                            let number = row * 3 + column
                            Button(action: {
                                passcode.append(String(number))
                            }) {
                                Text("\(number)")
                                    .font(.title)
                                    .frame(width: buttonSize, height: buttonSize)
                                    .background(buttonBackgroundColor)
                                    .foregroundColor(textColor)
                                    .cornerRadius(buttonSize / 2)
                            }
                        }
                    }
                }

                // Face ID and delete buttons
                HStack(spacing: spacing) {
                    Button(action: onFaceID) {
                        Image(systemName: "faceid")
                            .font(.title)
                            .frame(width: buttonSize, height: buttonSize)
                            .background(buttonBackgroundColor)
                            .foregroundColor(textColor)
                            .cornerRadius(buttonSize / 2)
                    }

                    Button("0") {
                        passcode.append("0")
                    }
                    .font(.title)
                    .frame(width: buttonSize, height: buttonSize)
                    .background(buttonBackgroundColor)
                    .foregroundColor(textColor)
                    .cornerRadius(buttonSize / 2)

                    Button(action: {
                        if !passcode.isEmpty {
                            passcode.removeLast()
                        }
                    }) {
                        Image(systemName: "delete.left")
                            .font(.title)
                            .frame(width: buttonSize, height: buttonSize)
                            .background(buttonBackgroundColor)
                            .foregroundColor(textColor)
                            .cornerRadius(buttonSize / 2)
                    }
                }
            }
            .padding(spacing)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(keypadBackgroundColor)
            .cornerRadius(12)
        }
        .padding(.horizontal)
        .ignoresSafeArea(edges: .bottom)
    }
}
struct PasscodeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        PasscodeEntryView().environmentObject(sessionStore())
    }
}
