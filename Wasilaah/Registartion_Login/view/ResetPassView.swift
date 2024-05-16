//
//  ResetPassView.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 16/10/1445 AH.
//


import SwiftUI

struct ResetPassView: View {
    @EnvironmentObject var session: sessionStore
    @State private var email: String = ""
    @Environment(\.dismiss) var dismiss
    @State private var message = ""
    @State private var showAlert = false
    var body: some View {
        NavigationView {
            VStack(spacing: 4) {
                
                NavigationLink(destination: LogInView1(authViewModel: sessionStore())){
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .foregroundColor(.gray)
                .padding(.leading,310)
                .padding(50)
                
                Text("Reset Password")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .padding(.leading,-120)
                
                Text("Enter the email the your registered with it")
                    .foregroundColor(.gray)
                    .padding(.leading,-15)
                
                TextField("Enter your email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .frame(width: 340, height: 94)
                
                Button(action: {
                    self.resetPassword()
                }) {
                    Text("Reset Password")
                        .foregroundColor(.white)
                        .frame(width: 300, height: 48)
                        .background(Color.pprl)
                        .cornerRadius(12)
                }
                
                if !message.isEmpty {
                    Text(message)
                        .foregroundColor(.red)
                }
            }
            .padding(.bottom, 480)

        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Password Reset"), message: Text(message), dismissButton: .default(Text("OK")))
            
        }
    }
    
    // Function to handle password reset
    private func resetPassword() {
        session.sendPasswordReset(email: email) { success, message in
            self.message = message
            self.showAlert = true
        }
    }
}


#Preview {
    ResetPassView()
}

