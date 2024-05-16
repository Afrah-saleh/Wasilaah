//
//  UserProfileRepository.swift
//  Namaa
//
//  Created by Afrah Saleh on 10/10/1445 AH.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

class UserProfileRepository: ObservableObject {
    private var db = Firestore.firestore()

       func createProfile(profile: User, completion: @escaping (User?, Error?) -> Void) {
           do {
               try db.collection("users").document(profile.uid).setData(from: profile)
               completion(profile, nil)
           } catch let error {
               print("Error writing user to Firestore: \(error)")
               completion(nil, error)
           }
          }

       func fetchProfile(userId: String, completion: @escaping (User?, Error?) -> Void) {
           db.collection("users").document(userId).getDocument { (document, error) in
               guard let document = document, document.exists else {
                   completion(nil, error)
                   return
               }
               do {
                   let profile = try document.data(as: User.self)
                   completion(profile, nil)
               } catch let error {
                   completion(nil, error)
               }
           }
       }
    
    func verifyUserCredentials(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
           Auth.auth().signIn(withEmail: email, password: password) { result, error in
               if let error = error {
                   completion(false, error)
                   return
               }
               completion(true, nil)
           }
       }
    func updateProfileField(uid: String, field: String, value: Any, completion: @escaping (Error?) -> Void) {
            db.collection("users").document(uid).updateData([field: value]) { error in
                completion(error)
            }
        }
    
    // In UserProfileRepository
    func updateCompanyInfo(userId: String, companyName: String, capitalOfMoney: String, completion: @escaping (Error?) -> Void) {
        let updates = ["companyName": companyName, "capitalOfMoney": capitalOfMoney]
        db.collection("users").document(userId).updateData(updates) { error in
            completion(error)
        }
    }
}
