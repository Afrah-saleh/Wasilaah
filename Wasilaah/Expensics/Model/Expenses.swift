//
//  Expenses.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 13/10/1445 AH.
//

import Foundation

struct Range1: Codable {
    var from: Double
    var to: Double
}

struct Expenses: Codable, Identifiable {
    var id: UUID                   // Unique identifier for the expense
    var cardID: String
    var name: String                // Name of the expense
    var type: ExpenseType?        // Type of the expense, enum for fixed options
    var currency: Currency         // Currency used, enum for fixed options
    var paymentDate: PaymentDate?        // Date of payment
    var dayOfPurchase: Int?  // New field for the day of purchase
    var amount: Double              // Amount spent
    var range: Range1?               // Optional range with two decimal values
    var dateCreated: Date        // Date when the expense was created
    var lastTransactionDate: Date?  // New field to track the last transaction date

}

enum ExpenseType: String, Codable, CaseIterable {
    case fixed = "Fixed"
    case changeable = "Changable"
    case other = "Other"
}

enum Currency: String, Codable, CaseIterable {
    case dollar = "Dollar"
    case SAR = "SAR"
}

enum PaymentDate: String, Codable, CaseIterable {
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
}
extension ExpenseType {
    var localized: String {
        NSLocalizedString(self.rawValue, comment: "")
    }
}

extension Currency {
    var localized: String {
        NSLocalizedString(self.rawValue, comment: "")
    }
}

extension PaymentDate {
    var localized: String {
        NSLocalizedString(self.rawValue, comment: "")
    }
}

extension Expenses {
    var localized: String {
        NSLocalizedString(self.name, comment: "")
    }
}
