//
////
////  MoreView.swift
////  Namaa
////
////  Created by Muna Aiman Al-hajj on 21/10/1445 AH.
////
//
//import SwiftUI
//import Firebase
//
//struct MoreView: View {
//    @ObservedObject var authViewModel: sessionStore
//    @EnvironmentObject var session: sessionStore
//    @State private var showingLogoutAlert = false
//    @State private var showRootView = false
//    @State private var showingAlert = false
//    @State private var alertMessage = ""
//    @State private var password: String = ""
//    @State private var email: String = ""
//    @State private var alertTitle = "Account Deletion"
//    @State private var showDeleteAccountAlert = false
//    @State private var showingSignUp = false  // State to show SignUp View
//    @State private var showingChangePasswordPopup = false
//
//
//    var body: some View {
//        NavigationView {
//            ScrollView{
//                GeometryReader { geometry in
//                VStack {
////                                        if let profile = authViewModel.session {
//                    
//                    VStack(alignment:.leading, spacing: 20){
//                        Text("Account")
//                            .bold()
//                            .font(.title3)
//                            .padding(.leading,-160)
//                        VStack(alignment:.leading){
//                            Text("fghiuhrtgr")
////                                                            Text("\(profile.fullName ?? "")!")
//                                .font(.headline)
//                                .padding(.leading,-150)
//                                .foregroundColor(.black)
//                            Text("fghiuhrtgr")
////                                                            Text("\(profile.email)")
//                                .foregroundColor(.gray)
//                                .font(.caption)
//                                .padding(.leading,-150)
//                        }
//                        .background(
//                            RoundedRectangle(cornerRadius: 12)
//                                .foregroundColor(.gry)
//                            //                            .stroke(Color.gry, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
//                                .frame(width: 350,height: 60)
//                        )
//                    }
//                    .padding()
//                    
//                    
//                    VStack{
//                        Text("Reset Password")
//                            .bold()
//                            .font(.title3)
//                            .padding(.leading,-160)
//                        
//                        Button(action:{
//                            showingChangePasswordPopup = true
//                        }){
//                            ZStack{
//                                RoundedRectangle(cornerRadius: 12)
//                                    .foregroundColor(.gry)
//                                    .frame(width: 350,height: 60)
//                                HStack(spacing: 160){
//                                    Text("Change Password")
//                                        .foregroundColor(.black)
//                                    Image(systemName: "chevron.forward")
//                                        .foregroundColor(.gray)
//                                }
//                            }
//                        }
//                        if showingChangePasswordPopup {
//                            ChangePasswordPopup(isPresented: $showingChangePasswordPopup)
//                        }
//                        
//                    }
//                    
//                    Spacer()
//                    
//                    
//                    
//                    VStack(spacing: 40){
//                        if showDeleteAccountAlert {
//                            DeleteAccountAlert(authViewModel: sessionStore(), showDeleteAccountAlert: $showDeleteAccountAlert)
//                                .frame(width: 350, height: 320) // Adjusted height for better spacing
//                                .background(Color.white)
//                                .cornerRadius(20)
//                                .shadow(radius: 10)
//                                .padding()
//                        }
//                        
//                        Button(action: {
//                            showingLogoutAlert = true
//                        }){
//                            HStack{
//                                Image(systemName: "rectangle.portrait.and.arrow.right")
//                                Text("Logout")
//                            }
//                            .background(
//                                RoundedRectangle(cornerRadius: 12)
//                                    .stroke( lineWidth: 1)
//                                    .frame(width: 300, height: 48)
//                                
//                            )
//                        }
//                        .foregroundColor(.pprl)
//                        
//                        Button(action:{
//                            showDeleteAccountAlert = true
//                            
//                        }){
//                            HStack{
//                                Image(systemName: "trash")
//                                Text("Delete Account")
//                            }
//                            .background(
//                                RoundedRectangle(cornerRadius: 12)
//                                    .stroke( lineWidth: 1)
//                                    .frame(width: 300, height: 48)
//                            )
//                        }
//                        .foregroundColor(.red)
//                        .disabled(showDeleteAccountAlert)
//                        
//                        
//                    }
//                    
//                    //                    Spacer()
//                    .padding()
//                    
//                    
////                    
////                                        } else {
////                                            MoreViewBlocked()
////                                                .onTapGesture {
////                                                    showingSignUp = true
////                                                }
////                    //
////                                                .navigationDestination(isPresented: $showingSignUp) {
////                                                    SignUpView(authViewModel: sessionStore())
////                    
////                                                }
////                    //
////                                        }
//                }
//                .frame(maxWidth: .infinity,maxHeight: .infinity)
//            }
//                
//            }
//            .alert(alertTitle, isPresented: $showingAlert) {
//                Button("OK", role: .cancel) { }
//            } message:{
//                Text(alertMessage)
//            }
//            .alert("Confirm Logout", isPresented: $showingLogoutAlert) {
//                Button("Log Out", role: .destructive) {
//                    authViewModel.signOut()
//                    showingSignUp = true
//                }
//                .onTapGesture {
//                    showingSignUp = true
//                }
//                Button("Cancel", role: .cancel) {}
//            }
////            .navigationDestination(isPresented: $showingSignUp) {
////                SignUpView(authViewModel: sessionStore())
////
////            }
//            .navigationTitle("More")
//            .navigationBarTitleDisplayMode(.inline)
//            .fullScreenCover(isPresented: $showingSignUp) {
//                RootView(authViewModel: sessionStore(), expenses: ExpensesViewModel(cardID: "cardID" ))
//            }
//            
//        
//    }
//    }
//   }
//
//
//struct ChangePasswordPopup: View {
//    @Binding var isPresented: Bool
//    @EnvironmentObject var session: sessionStore
//    
//    @State private var currentPassword: String = ""
//    @State private var newPassword: String = ""
//    @State private var confirmPassword: String = ""
//    @State private var message: String = ""
//    
//    // State variables to control password visibility
//    @State private var showCurrentPassword = false
//    @State private var showNewPassword = false
//    @State private var showConfirmPassword = false
//    
//    var body: some View {
//        VStack {
//            VStack(alignment: .leading) {
//                HStack {
//                    Text("Current Password")
//                    Spacer()
//                    Button(action: { isPresented = false }) {
//                        Image(systemName: "xmark.circle")
//                            .foregroundColor(.red)
//                    }
//                }
//                
//                // Toggle visibility for current password
//                HStack {
//                    if showCurrentPassword {
//                        TextField("Current Password", text: $currentPassword)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                    } else {
//                        SecureField("Current Password", text: $currentPassword)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                    }
//                    Button(action: { showCurrentPassword.toggle() }) {
//                        Image(systemName: showCurrentPassword ? "eye.slash.fill" : "eye.fill")
//                            .foregroundColor(.gray)
//                    }
//                }
//                
//                Text("New Password")
//                // Toggle visibility for new password
//                HStack {
//                    if showNewPassword {
//                        TextField("New Password", text: $newPassword)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                    } else {
//                        SecureField("New Password", text: $newPassword)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                    }
//                    Button(action: { showNewPassword.toggle() }) {
//                        Image(systemName: showNewPassword ? "eye.slash.fill" : "eye.fill")
//                            .foregroundColor(.gray)
//                    }
//                }
//                
//                Text("Confirm New Password")
//                // Toggle visibility for confirm password
//                HStack {
//                    if showConfirmPassword {
//                        TextField("Confirm New Password", text: $confirmPassword)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                    } else {
//                        SecureField("Confirm New Password", text: $confirmPassword)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                    }
//                    Button(action: { showConfirmPassword.toggle() }) {
//                        Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//            
//            Button("Change Password") {
//                if newPassword == confirmPassword {
//                    session.changePassword(currentPassword: currentPassword, newPassword: newPassword) { success, message in
//                        self.message = message
//                        if success {
//                            self.isPresented = false // Dismiss the popup upon successful change
//                            currentPassword = ""
//                            newPassword = ""
//                            confirmPassword = ""
//                        }
//                    }
//                } else {
//                    self.message = "New password and confirmation do not match."
//                }
//            }
//            .foregroundColor(.pprl)
//            
//            if !message.isEmpty {
//                Text(message)
//                    .foregroundColor(.red)
//                    .padding()
//            }
//        }
//        .padding()
//        .background(Color.white11)
//        .frame(width: 330)
//        .cornerRadius(12)
//        .shadow(radius: 3)
//    }
//}
//
//
//#Preview {
//    MoreView(authViewModel: sessionStore())
//}


import SwiftUI
import Firebase

struct MoreView: View {
    @ObservedObject var authViewModel: sessionStore
    @EnvironmentObject var session: sessionStore
    @State private var showingLogoutAlert = false
    @State private var showRootView = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var alertTitle = "Account Deletion"
    @State private var showDeleteAccountAlert = false
    @State private var showingSignUp = false  // State to show SignUp View
    @State private var showingChangePasswordPopup = false


    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    if let profile = authViewModel.session {
                        
                        VStack(alignment:.leading, spacing: 20){
                            Text("Account")
                                .bold()
                                .font(.title3)
                                .padding(.leading,-160)
                            VStack(alignment:.leading){
                                Text("\(profile.fullName ?? "")!")
                                    .font(.headline)
                                    .padding(.leading,-150)
                                    .foregroundColor(.black)
                                
                                Text("\(profile.email)")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .padding(.leading,-150)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundColor(.gry)
                                //                            .stroke(Color.gry, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                                    .frame(width: 350,height: 60)
                            )
                        }
                        .padding()
                        
                        
                        VStack{
                            Text("Reset Password")
                                .bold()
                                .font(.title3)
                                .padding(.leading,-160)
                            
                            Button(action:{
                                showingChangePasswordPopup = true
                            }){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 12)
                                        .foregroundColor(.gry)
                                        .frame(width: 350,height: 60)
                                    HStack(spacing: 160){
                                        Text("Change Password")
                                            .foregroundColor(.black)
                                        Image(systemName: "chevron.forward")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            if showingChangePasswordPopup {
                                            ChangePasswordPopup(isPresented: $showingChangePasswordPopup)
                                        }
                            
                        }
                        
                        Spacer()

                        
                        
                        VStack(spacing: 40){
                            if showDeleteAccountAlert {
                                DeleteAccountAlert(authViewModel: sessionStore(), showDeleteAccountAlert: $showDeleteAccountAlert)
                                    .frame(width: 350, height: 320) // Adjusted height for better spacing
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .shadow(radius: 10)
                                    .padding()
                            }
                            
                            Button(action: {
                                showingLogoutAlert = true
                            }){
                                HStack{
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                    Text("Logout")
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke( lineWidth: 1)
                                        .frame(width: 300, height: 48)
                                    
                                )
                            }
                            .foregroundColor(.pprl)
                            
                            Button(action:{
                                showDeleteAccountAlert = true
                                
                            }){
                                HStack{
                                    Image(systemName: "trash")
                                    Text("Delete Account")
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke( lineWidth: 1)
                                        .frame(width: 300, height: 48)
                                )
                            }
                            .foregroundColor(.red)
                            .disabled(showDeleteAccountAlert)
                            
                            
                        }
                        
                        //                    Spacer()
                                            .padding()
                        
                        
                        
                    } else {
                        MoreViewBlocked()
                            .onTapGesture {
                                showingSignUp = true
                            }
//
                            .navigationDestination(isPresented: $showingSignUp) {
                                SignUpView(authViewModel: sessionStore())
                                
                            }
//
                    }
                }
                
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message:{
                Text(alertMessage)
            }
            .alert("Confirm Logout", isPresented: $showingLogoutAlert) {
                Button("Log Out", role: .destructive) {
                    authViewModel.signOut()
                    showRootView = true
                }
                Button("Cancel", role: .cancel) {}
            }
            
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showRootView) {
                RootView(authViewModel: authViewModel, expenses: ExpensesViewModel(cardID: ""))
            }
            
        
    }
    }
   }


struct ChangePasswordPopup: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var session: sessionStore
    
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var message: String = ""
    
    // State variables to control password visibility
    @State private var showCurrentPassword = false
    @State private var showNewPassword = false
    @State private var showConfirmPassword = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Current Password")
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                    }
                }
                
                // Toggle visibility for current password
                HStack {
                    if showCurrentPassword {
                        TextField("Current Password", text: $currentPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        SecureField("Current Password", text: $currentPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Button(action: { showCurrentPassword.toggle() }) {
                        Image(systemName: showCurrentPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                
                Text("New Password")
                // Toggle visibility for new password
                HStack {
                    if showNewPassword {
                        TextField("New Password", text: $newPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        SecureField("New Password", text: $newPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Button(action: { showNewPassword.toggle() }) {
                        Image(systemName: showNewPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                
                Text("Confirm New Password")
                // Toggle visibility for confirm password
                HStack {
                    if showConfirmPassword {
                        TextField("Confirm New Password", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        SecureField("Confirm New Password", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Button(action: { showConfirmPassword.toggle() }) {
                        Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            .padding()
            Button("Change Password") {
                if newPassword == confirmPassword {
                    session.changePassword(currentPassword: currentPassword, newPassword: newPassword) { success, message in
                        self.message = message
                        if success {
                            self.isPresented = false // Dismiss the popup upon successful change
                            currentPassword = ""
                            newPassword = ""
                            confirmPassword = ""
                        }
                    }
                } else {
                    self.message = "New password and confirmation do not match."
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.pprl,lineWidth: 1)
                    .frame(width: 200, height: 40)
                
            )
            .foregroundColor(.pprl)
            
            if !message.isEmpty {
                Text(message)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .background(Color.white11)
        .frame(width: 330)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}


#Preview {
    MoreView(authViewModel: sessionStore())
}
