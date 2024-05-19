//
//  ModalView.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 01/11/1445 AH.
//
//
//import SwiftUI
//
//struct DeleteAccountAlert: View {
//    @ObservedObject var authViewModel: sessionStore
//    @EnvironmentObject var session: sessionStore
//    @State private var showSheet = false // State to control sheet visibility
//    @State private var showingAlert = false
//    @State private var alertMessage = ""
//        @State private var password: String = ""
//    @State private var email: String = ""
//        @State private var alertTitle = "Account Deletion"
//    @Binding var showDeleteAccountAlert: Bool
//
//    var body: some View {
//        
//        VStack(spacing:-5){
//            HStack {
//                          Spacer()
//                          Button(action: {
//                              showDeleteAccountAlert = false
//                          }) {
//                              Image(systemName: "xmark.circle.fill")
//                                  .foregroundColor(.gray)
//                                  .imageScale(.large)
//                                  .padding(.trailing, 10)
//                                  .padding(.top, 5)
//                          }
//                      }
//            
//                Text("Please enter your email & password to confirm account deletion:")
//                .foregroundColor(.black)
//                .padding()
//
//                
//                TextField("Email", text: $email)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .keyboardType(.emailAddress)
//                    .autocapitalization(.none)
//                    .padding()
//                
//                SecureField("Password", text: $password)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//
//
//                
//            Spacer()
//                Button(action: {
//                    guard !password.isEmpty else {
//                        alertTitle = "Validation Error"
//                        alertMessage = "Password cannot be empty."
//                        showingAlert = true
//                        return
//                    }
//                    session.deleteUser(email: email, password: password) { success, message in
//                        alertTitle = success ? "Success" : "Error"
//                        alertMessage = message
//                        showingAlert = true
//                    }
//                })
//                {
//                        Text("Done")
//                }
//                .background(
//                    RoundedRectangle(cornerRadius: 12)
//                        .stroke( lineWidth: 1)
//                        .frame(width: 100, height: 48)
//                    
//                )
//                .foregroundColor(.red)
//            
//
//        }
//        .padding(.bottom,50)
//        .navigationBarTitleDisplayMode(.inline)
//        .background(Color.white11)
//    }
//}
//




import SwiftUI

struct DeleteAccountAlert: View {
    @ObservedObject var authViewModel: sessionStore
    @EnvironmentObject var session: sessionStore
    @State private var showSheet = false // State to control sheet visibility
    @State private var showingAlert = false
    @State private var alertMessage = ""
        @State private var password: String = ""
    @State private var email: String = ""
        @State private var alertTitle = "Account Deletion"
    @Binding var showDeleteAccountAlert: Bool

    var body: some View {
        
        VStack(spacing:-5){
            HStack {
                          Spacer()
                          Button(action: {
                              showDeleteAccountAlert = false
                          }) {
                              Image(systemName: "xmark.circle.fill")
                                  .foregroundColor(.gray)
                                  .imageScale(.large)
                                  .padding(.trailing, 10)
                                  .padding(.top, 5)
                          }
                      }
            
                Text("Please enter your email & password to confirm account deletion:")
                .foregroundColor(.black11)
                .padding()

            VStack(alignment:.leading){
                Text("Email:")
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                
                Text("Password:")
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

                
            Spacer()
                Button(action: {
                    guard !password.isEmpty else {
                        alertTitle = "Validation Error"
                        alertMessage = "Password cannot be empty."
                        showingAlert = true
                        return
                    }
                    session.deleteUser(email: email, password: password) { success, message in
                        alertTitle = success ? "Success" : "Error"
                        alertMessage = message
                        showingAlert = true
                    }
                })
                {
                        Text("Done")
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke( lineWidth: 1)
                        .frame(width: 100, height: 48)
                    
                )
                .foregroundColor(.red)
            

        }
        .padding(.bottom,50)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.white11)
    }
}

