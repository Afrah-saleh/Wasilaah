//
//  CreateAccount.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 16/10/1445 AH.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import Firebase
import AuthenticationServices

struct CreateAccount: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var fullName : String = ""
    @State private var shouldNavigate = false // State to control navigation
    @State private var shouldNavigateHome = false
    @State private var currentCard: Card? = nil  // Initialize card as nil

    @ObservedObject var authViewModel = sessionStore()
    var body: some View {
        NavigationStack{
            ScrollView{
            VStack{
                Spacer(minLength: 40)
                
                Text("Create an account")
                    .font(.title)
                    .bold()
                    .padding(.leading, -120)
                VStack{
                    TextField("Full Name", text: $fullName)
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                }
                .frame(width: 340, height: 94)
                .textFieldStyle(.roundedBorder)
                
                
                
                Button("Create an Account") {
                    authViewModel.signUp(email: email, password: password, fullName: fullName) { profile, error in
                        
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }  else if profile != nil {
                            shouldNavigate = true // Trigger navigation on successful sign up
                        }
                    }
                }
                .frame(width: 300, height: 48)
                .background(Color.pprl)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(30)
                
                
                
                HStack{
                    Rectangle()
                    Text("OR Continue With")
                        .foregroundColor(.gray)
                        .frame(width: 140)
                    Rectangle()
                    
                }
                .frame(height: 0.33)
                
                .padding()
                
                VStack(spacing:50){
                    
                    Button(action:{
                        print("Tapped google sign in")
                        
                        authViewModel.signinWithGoogle(presenting: getRootViewController()) { error in
                            if let error = error {
                                print("Error signing in with Google: \(error.localizedDescription)")
                            } else {
                                self.shouldNavigate = true  // Navigate on success
                            }
                        }
                    }){
                        HStack{
                            Image("Google")
                            
                            Text("Continue with Google")
                                .foregroundColor(.white11)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.black11)
                                .frame(width: 300,height: 48)
                        )
                    }
                    
                    
                    
                    
                    //                    Button(action:{
                    //                        print("Tapped apple sign in")
                    //                        authViewModel.startSignInWithAppleFlow()
                    //                        self.shouldNavigate = true  // Navigate on success
                    //                    }){
                    //                        Image("apple")
                    //
                    //                        Text("Continue with Apple")
                    //                            .foregroundColor(.white11)
                    //                    }
                    //                    .background(
                    //                        RoundedRectangle(cornerRadius: 12)
                    //                            .foregroundColor(.black11)
                    //                            .frame(width: 300,height: 48)
                    //                    )
                    //                    
                                        }
                                    .padding(50)
                    
                //}
                
                HStack {
                    Text("Already have an account?")
                    
                    NavigationLink(destination: LogInView1(authViewModel: sessionStore())) {
                        Text("Login").foregroundColor(.blue)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                
            }
            .padding(.bottom, 170)
        }
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $shouldNavigate) {
            CardsFirstTime(authViewModel: authViewModel, cardViewModel: CardViewModel(), card: $currentCard)
        }
    }
}

#Preview {
    CreateAccount()
}
