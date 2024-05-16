//
//  sessionStore.swift
//  sign
//
//  Created by Afrah Saleh on 10/10/1445 AH.
//
import Foundation
import Combine
import Firebase
import SwiftUI
import FirebaseCore
import FirebaseAuth
import CryptoKit
import AuthenticationServices
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

class sessionStore: NSObject, ObservableObject, ASAuthorizationControllerDelegate  {
    @Published var session: User?
    @Published var profile: User?
    @Published var signedIn: Bool = false
    @Published var needsCompanyInfo: Bool = false  // New state to control navigation post-signup
    @Published var isCompanyNameSet: Bool = false  // New state to check if company name is set
    @State private var progress: CGFloat = 0.0  // Represents the current progress
    @Published var showPasscode: Bool = false
    private var wasOpenedFromBackground = false
    private var passcodeTimer: Timer?

    // Call this when app goes to background
    func appDidEnterBackground() {
        wasOpenedFromBackground = true
        passcodeTimer = Timer.scheduledTimer(withTimeInterval: 120, repeats: false) { [weak self] _ in
            self?.showPasscode = true
        }
    }

    // Call this when app becomes active
    func appDidBecomeActive() {
        if signedIn {
            if wasOpenedFromBackground {
                // Timer will handle showing the passcode if necessary
            } else {
                // App was force quit and reopened
                showPasscode = true
            }
        }
        wasOpenedFromBackground = false
        passcodeTimer?.invalidate()
        passcodeTimer = nil
    }
//      func appEnteredForeground() {
//          if signedIn {
//              showPasscode = true
//          }
//      }
    // Unhashed nonce.
     var currentNonce: String?
    
    private var profileRepository = UserProfileRepository()
    
    override init() {
        super.init()
        checkCurrentUser()
    }

    func checkCurrentUser() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if let user = user {
                // User is signed in
                self?.signedIn = true
                self?.fetchAndUpdateProfile(userId: user.uid)
                self?.session = User(uid: user.uid, email: user.email ?? "none")
            } else {
                // No user is signed in
                self?.signedIn = false
                self?.session = nil
            }
        }
    }

    
    func signUp(email: String, password: String, fullName: String, completion: @escaping (_ profile: User?, _ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let user = result?.user else {
                completion(nil, NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user data after sign-up"]))
                return
            }
            
            let newUser = User(uid: user.uid, email: email, fullName: fullName)
            Firestore.firestore().collection("users").document(user.uid).setData([
                "uid": newUser.uid,
                "email": newUser.email,
                "fullName": newUser.fullName ?? ""
            ]) { error in
                if let error = error {
                    completion(nil, error)
                } else {
                    self.session = newUser
                    self.profile = newUser
                    self.needsCompanyInfo = true  // Set this instead of signedIn
                    completion(newUser, nil)
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (_ profile: User?, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let user = result?.user else {
                completion(nil, NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user data after sign-in"]))
                return
            }
            self.profileRepository.fetchProfile(userId: user.uid) { (profile, error) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.profile = profile
                    self.session = profile
                    self.signedIn = true
                    completion(profile, nil)
                }
            }
        
        }
    }

    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.session = nil
            self.profile = nil
            self.signedIn = false
            print("Logged out, signedIn is now \(self.signedIn)")
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
    
    func skipSignIn() {
         self.signedIn = false
     }
        // Method to send password reset email
        func sendPasswordReset(email: String, completion: @escaping (Bool, String) -> Void) {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    completion(true, "Reset password link sent successfully. Check your email.")
                }
            }
        }
    
//    func updateCompanyInfo(uid: String, companyName: String, capitalOfMoney: String, completion: @escaping (Error?) -> Void) {
//        profileRepository.updateCompanyInfo(userId: uid, companyName: companyName, capitalOfMoney: capitalOfMoney, completion: completion)
//    }
    
    func fetchAndUpdateProfile(userId: String) {
         profileRepository.fetchProfile(userId: userId) { profile, error in
             DispatchQueue.main.async {
                 if let profile = profile {
                     self.session = profile
                     self.profile = profile
                     self.signedIn = true
                 } else {
                     print("Error fetching profile: \(error?.localizedDescription ?? "No profile found")")
                 }
             }
         }
     }
    func signinWithGoogle(presenting: UIViewController, completion: @escaping (Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { result, error in
            if let error = error {
                completion(error)
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString,
                  let email = user.profile?.email,
                  let uid = user.userID,
                  let fullName = user.profile?.name else {
                completion(NSError(domain: "LoginError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve all necessary user info from Google."]))
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(error)
                    return
                }
                // Check if user exists
                self.profileRepository.fetchProfile(userId: uid) { profile, error in
                    if let profile = profile {
                        DispatchQueue.main.async {
                            self.session = profile
                            self.profile = profile
                            self.signedIn = true
                            self.needsCompanyInfo = false  // Assuming there's a needsSetup flag in your user model
                            completion(nil)
                        }
                    } else {  // New user scenario
                        let newUser = User(uid: uid, email: email, fullName: fullName)
                        self.profileRepository.createProfile(profile: newUser) { profile, error in
                            if let profile = profile {
                                DispatchQueue.main.async {
                                    self.session = profile
                                    self.profile = profile
                                    self.signedIn = true
                                    self.needsCompanyInfo = true
                                    completion(nil)
                                }
                            } else {
                                print("Error creating profile: \(error!.localizedDescription)")
                                completion(error)
                            }
                        }
                    }
                }
            }
        }
    }
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential, let nonce = currentNonce, let appleIDToken = appleIDCredential.identityToken, let idTokenString = String(data: appleIDToken, encoding: .utf8) {
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            Auth.auth().signIn(with: credential) { authResult, error in
                
                if let error = error {
                    print("Firebase sign in error: (error.localizedDescription)")
                } else if let uid = authResult?.user.uid {
                    print("Signed in with Firebase using Apple ID.")
                    if appleIDCredential.email != nil {
                        // New user
                        print("Detected new user.")
                        let newUser = User(uid: uid, email: appleIDCredential.email ?? "", fullName: appleIDCredential.fullName?.formatted())
                        self.profileRepository.createProfile(profile: newUser) { profile, error in
                            if let profile = profile {
                                DispatchQueue.main.async {
                                    self.session = profile
                                    self.profile = profile
                                    self.signedIn = true
                                    self.needsCompanyInfo = true  // Indicate this is a new user
                                }
                            } else {
                                print("Error creating profile: (error!.localizedDescription)")
                            }
                        }
                    } else {
                        // Existing user
                        print("Detected existing user.")
                        self.profileRepository.fetchProfile(userId: uid) { profile, error in
                            if let profile = profile {
                                DispatchQueue.main.async {
                                    self.session = profile
                                    self.profile = profile
                                    self.signedIn = true
                                    self.needsCompanyInfo = false
                                    //  self.needsCompanyInfo = profile.companyName == nil  // Check if company info is set
                                }
                            } else {
                                print("Error fetching profile: \(error?.localizedDescription ?? "No profilefound")")
                            }
                        }
                    }
                }
            }
        }
    }
           func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print("Sign in with Apple errored: (error)")
    }

       private func randomNonceString(length: Int = 32) -> String {
           precondition(length > 0)
           let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
           var result = ""
           var remainingLength = length

           while remainingLength > 0 {
               let randoms = (0..<16).map { _ in UInt8.random(in: 0...255) }
              for random in randoms {
                   if remainingLength == 0 {
                       break
                   }
                   if random < charset.count {
                       result.append(charset[Int(random)])
                       remainingLength -= 1
                   }
               }
           }
           return result
       }

       private func sha256(_ input: String) -> String {
           let inputData = Data(input.utf8)
           let hashedData = SHA256.hash(data: inputData)
           let hashString = hashedData.map { String(format: "%02x", $0) }.joined()
           return hashString
       }
    
     func incrementProgress() {
         let stepSize = 1.0 / 5.0
         progress += CGFloat(stepSize)
     }

        func deleteUser(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
            guard let user = Auth.auth().currentUser, user.email == email else {
                completion(false, "The provided email does not match the current signed-in user.")
                return
            }

            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            user.reauthenticate(with: credential) { _, error in
                if let error = error {
                    completion(false, "Re-authentication failed: \(error.localizedDescription)")
                    return
                }

                user.delete { error in
                    if let error = error {
                        completion(false, "Failed to delete user: \(error.localizedDescription)")
                    } else {
                        self.signOut() // Make sure to clean up the local session.
                        completion(true, "User deleted successfully.")
                    }
                }
            }
        }
    
    
    
        func changePassword(currentPassword: String, newPassword: String, completion: @escaping (Bool, String) -> Void) {
            guard let currentUser = Auth.auth().currentUser, let email = currentUser.email else {
                completion(false, "User not logged in or email not available.")
                return
            }

            // Correctly create a re-authentication credential
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            currentUser.reauthenticate(with: credential) { authResult, error in
                if let error = error {
                    completion(false, "Re-authentication failed: \(error.localizedDescription)")
                    return
                }

                // Proceed to update the password
                currentUser.updatePassword(to: newPassword) { error in
                    if let error = error {
                        completion(false, "Password update failed: \(error.localizedDescription)")
                    } else {
                        completion(true, "Password updated successfully.")
                    }
                }
            }
        }
    
    
    
   }
