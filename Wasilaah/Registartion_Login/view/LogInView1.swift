//
//  LogInView1.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 16/10/1445 AH.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import Firebase
import AuthenticationServices

struct LogInView1: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var authViewModel: sessionStore
    @Environment(\.dismiss) var dismiss
    @State private var shouldNavigate = false
    @State private var navigateToResetPassword = false
    @State private var errorMessage: String?
    @State private var shouldNavigateHome = false
    
    var body: some View {
        NavigationStack{
            ScrollView{
                Spacer(minLength: 40)
                VStack{
                    
                    Text("Login")
                        .font(.title)
                        .bold()
                        .padding(.leading, -160)
                    VStack{
                        TextField("Email", text: $email)
                        SecureField("Password", text: $password)
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .frame(width: 340)
                        }
                    }
                    .frame(width: 340, height: 94)
                    .textFieldStyle(.roundedBorder)
                    
                    
                    
                    Button("Forgot Password?") {
                        navigateToResetPassword = true
                    }
                    .padding(.leading,200)
                    
                    
                    Button("Login") {
                        authViewModel.signIn(email: email, password: password) { profile, error in
                            if let e = error {
                                self.errorMessage = e.localizedDescription
                                self.shouldNavigate = false  // Ensure navigation does not occur
                            } else {
                                self.shouldNavigate = true  // Navigate on success
                            }
                        }
                    }
                    .frame(width: 300, height: 48)
                    .background(Color.pprl)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    
                    
//                    HStack{
//                        Rectangle()
//                        Text("OR Continue With")
//                            .foregroundColor(.gray)
//                            .frame(width: 140)
//                        Rectangle()
//                        
//                    }
//                    .frame(height: 0.33)
//                    
//                    .padding()
                    
//                    VStack(spacing:50){
//                        
//                        Button(action:{
//                            print("Tapped google sign in")
//                            
//                            authViewModel.signinWithGoogle(presenting: getRootViewController()) { error in
//                                if let error = error {
//                                    print("Error signing in with Google: \(error.localizedDescription)")
//                                } else {
//                                    self.shouldNavigate = true  // Navigate on success
//                                }
//                            }
//                        }){
//                            HStack{
//                                Image("Google")
//
//                                Text("Continue with Google")
//                                    .foregroundColor(.white11)
//                            }
//                            .background(
//                                RoundedRectangle(cornerRadius: 12)
//                                    .foregroundColor(.black11)
//                                    .frame(width: 300,height: 48)
//                            )
//                        }

                        
//                        Button(action:{
//                            print("Tapped apple sign in")
//                            authViewModel.startSignInWithAppleFlow()
//                            self.shouldNavigate = true  // Navigate on success
//                        }){
//                            Image("apple")
//
//                            Text("Continue with Apple")
//                                .foregroundColor(.white11)
//                        }
//                        .background(
//                            RoundedRectangle(cornerRadius: 12)
//                                .foregroundColor(.black11)
//                                .frame(width: 300,height: 48)
//                        )
//                        
//                       }
//                    .padding(50)

                    
                    HStack {
                        Text("Don't have an account?")
                        
                        NavigationLink(destination: CreateAccount()) {
                            Text("Create Account").foregroundColor(.blue)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.bottom, 190)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $shouldNavigate) {
                Home(expensesViewModel: ExpensesViewModel(cardID: ""),cardViewModel: CardViewModel())
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToResetPassword) {
                ResetPassView()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    LogInView1(authViewModel: sessionStore())
}
