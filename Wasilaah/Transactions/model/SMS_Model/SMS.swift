//
//  SMS.swift
//  Namaa
//
//  Created by Afrah Saleh on 05/11/1445 AH.
//

import Foundation

struct SMS: Codable, Identifiable {
    var id: String
    var cardID: String
    var userID: String?  // Adding User ID
    var transactionName: String
    var companyName: String?
    var amount: Double
    var date: String
    var expenseID: UUID?  // Link to the matched expense if any
    var currency: Currency2?  // Currency used, enum for fixed options
    var dateCreated: Date?
}



enum Currency2: String, Codable, CaseIterable {
    case dollar = "Dollar"
    case SAR = "SAR"
}
