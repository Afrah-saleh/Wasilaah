//
//  updateExpenses.swift
//  Namaa
//
//  Created by Afrah Saleh on 21/10/1445 AH.
//

import Foundation

struct TransactionEntry: Codable, Identifiable {
    var id: String
    var cardID: String
    var userID: String  // Adding User ID
    var transactionName: String
    var companyName: String?
    var amount: Double
    var date: String
    var expenseID: UUID?  // Link to the matched expense if any
    var currency: Currency1?  // Currency used, enum for fixed options
    var dateCreated: Date?
    var fileURL: URL?  // URL to the uploaded file

}



enum Currency1: String, Codable, CaseIterable {
    case dollar = "Dollar"
    case SAR = "SAR"
}
