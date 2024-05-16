//
//  User.swift
//  firebaseLogin
//
//  Created by Berkay Yaman on 2.05.2023.
//

import Foundation

// Define a struct `User` that conforms to the Codable protocol for easy encoding and decoding.
struct User: Codable {
    var uid: String       // Unique identifier for the user
    var email: String
   // var companyName: String?  // Optional since it's added post-registration
    var fullName : String?
   // var Capitalofmoney : Double?

}

// var password: String
// var firstName: String
extension User {
    static var sampleUser: User {
        User(uid: "user1",
             email: "user1@gmail.com")
    }
}

