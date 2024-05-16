//
//  updateExpensesViewModel.swift
//  Namaa
//
//  Created by Afrah Saleh on 21/10/1445 AH.
//

import SwiftUI
import Combine
import Firebase
import PDFKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

class SMSVM: ObservableObject {
    @Published var transactions: [SMS] = []
    @Published var transactionNames: [String] = [] // Store fetched names
    var session: sessionStore  // Assuming you pass this in the initializer or some other method
    private var db = Firestore.firestore()
    @Published var transactionName: String = ""
    @Published var companyName: String = ""
    @Published var amount: String = ""
    @Published var currency1: Currency2 = .dollar
    @Published var dateTime: String = ""
   // @Published var customTransactionName: String = "" // For custom input
    @Published var isOtherSelected: Bool = false // Track if "Other" is selected
    private var expenseIdsByName: [String: UUID] = [:]
    
    private var cardID: String

    init(cardID: String) {
        self.cardID = cardID
        self.session = sessionStore()
        fetchTransactions()
    }
    
    func fetchTransactions() {
         db.collection("transactions")
             .whereField("cardID", isEqualTo: cardID)
             .getDocuments { [weak self] (querySnapshot, error) in
                 if let error = error {
                     print("Error fetching transactions: \(error)")
                     return
                 }
                 self?.transactions = querySnapshot?.documents.compactMap { document -> SMS? in
                     try? document.data(as: SMS.self)
                 } ?? []
             }
     }
    
    
    
    func saveTransactions() {
        if transactions.isEmpty {
            print("No transactions to save")
            return
        }

        for transaction in transactions {
            let docRef = db.collection("newTransactions").document(transaction.id)
            do {
                try docRef.setData(from: transaction) { error in
                    if let error = error {
                        print("Error saving transaction: \(error.localizedDescription)")
                    } else {
                        print("Transaction successfully saved to Firestore with ID: \(docRef.documentID)")
                    }
                }
            } catch {
                print("Error preparing transaction for Firestore: \(error)")
            }
        }
    }
    


    func parseAndSaveSMS(smsText: String, cardID: String) {
           if let currentUserID = session.session?.uid {
               let parsedData = self.parseSMS(smsText: smsText)
               fetchAndMatchExpenses(parsedData: parsedData, cardID: cardID, userID: currentUserID)
           } else {
               print("No user ID available")
           }
       }
    
    
    func fetchClipboardContent() -> String {
        UIPasteboard.general.string ?? ""
    }
    // Extract and process data from the clipboard
    func pasteFromClipboard() {
        let pasteboard = UIPasteboard.general
        if let smsText = pasteboard.string {
            pasteSMS(smsText: smsText)
        }
    }
    // Simulated function to parse SMS text

    func pasteSMS(smsText: String) {
        let lines = smsText.components(separatedBy: "\n").filter { !$0.isEmpty }
        
        if lines.count > 3 {
            if lines[3].hasPrefix("لدى:") {
                if let index = lines[3].firstIndex(of: ":") {
                    transactionName = String(lines[3][lines[3].index(after: index)...]).trimmingCharacters(in: .whitespaces)
                }
            }
        }
        
        if lines.count > 2 {
            if let range = lines[2].range(of: "SAR") {
                let amountString = lines[2][range.upperBound...].trimmingCharacters(in: .whitespaces)
                let filteredAmountString = amountString.filter("0123456789.".contains)
                if let parsedAmount = Double(filteredAmountString) {
                    amount = String(format: "%.2f", parsedAmount)
                }
            }
        }
        
        if lines.count > 3 {
            if let index = lines[3].firstIndex(of: ":") {
                companyName = String(lines[3][lines[3].index(after: index)...]).trimmingCharacters(in: .whitespaces)
            }
        }
        
        if lines.count > 4 {
            if let index = lines[4].firstIndex(of: ":") {
                let dateString = String(lines[4][lines[4].index(after: index)...])
                if let date = parseDate(dateString: dateString) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm" // Define your desired date format
                    dateTime = dateFormatter.string(from: date)
                } else {
                    dateTime = "Invalid date" // Handle the case where date parsing fails
                }
            }
        }
    }
    func parseDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: dateString)
    }
    
    
     func parseSMS(smsText: String) -> [String: Any] {
        let numberPattern = #"مبلغ:\s*(SAR|Dollar|\$)?\s*(\d+(\.\d+)?)\b"#
        let datePattern = #"(?:\d{1,2}\/\d{1,2}\/\d{2,4})|(?:\d{1,2}-\d{1,2}-\d{2,4})"#
        let transactionNamePattern = #"شراء\s+انترنت\b"#
        let companyNamePattern = #"لدى:\s*([\w\s]+)"#

        var parsedData: [String: Any] = [:]

        do {
            let regexNumbers = try NSRegularExpression(pattern: numberPattern)
            let regexDates = try NSRegularExpression(pattern: datePattern)
            let regexTransactionNames = try NSRegularExpression(pattern: transactionNamePattern)
            let regexCompanyName = try NSRegularExpression(pattern: companyNamePattern)

            // Extract company name
            let companyNameMatches = regexCompanyName.matches(in: smsText, range: NSRange(smsText.startIndex..., in: smsText))
            let companyName = companyNameMatches.compactMap { match -> String? in
                guard let range = Range(match.range(at: 1), in: smsText) else { return nil }
                return String(smsText[range]).trimmingCharacters(in: .whitespacesAndNewlines)
            }.first

            print("Extracted company name: \(companyName ?? "None")")

            // Extract numbers and currency
            let numberMatches = regexNumbers.matches(in: smsText, range: NSRange(smsText.startIndex..., in: smsText))
            let extractedNumber = numberMatches.compactMap { match -> Double? in
                guard let numberRange = Range(match.range(at: 2), in: smsText) else { return nil }
                return Double(smsText[numberRange])
            }.first

            let currency = numberMatches.compactMap { match -> String? in
                guard let currencyRange = Range(match.range(at: 1), in: smsText) else { return nil }
                return String(smsText[currencyRange])
            }.first

            // Extract date
            let dateMatches = regexDates.matches(in: smsText, range: NSRange(smsText.startIndex..., in: smsText))
            let date = dateMatches.compactMap { match -> String? in
                guard let range = Range(match.range, in: smsText) else { return nil }
                return String(smsText[range])
            }.first

            // Extract transaction name
            let transactionNameMatches = regexTransactionNames.matches(in: smsText, range: NSRange(smsText.startIndex..., in: smsText))
            let transactionName = transactionNameMatches.compactMap { match -> String? in
                guard let range = Range(match.range, in: smsText) else { return nil }
                return String(smsText[range])
            }.first

            // Populate parsed data
            parsedData["companyName"] = companyName
            parsedData["amount"] = extractedNumber
            parsedData["currency"] = currency
            parsedData["date"] = date
            parsedData["transactionName"] = transactionName ?? "Unknown Transaction"

        } catch {
            print("Regex error: \(error)")
        }

        return parsedData
    }

    private func fetchAndMatchExpenses(parsedData: [String: Any], cardID: String, userID: String) {
        db.collection("expenses").whereField("cardID", isEqualTo: cardID).getDocuments { [weak self] (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching expenses: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            let expenses = snapshot.documents.compactMap { doc -> Expenses? in
                try? doc.data(as: Expenses.self)
            }
            
            DispatchQueue.main.async {
                if let transactionName = parsedData["companyName"] as? String,
                   let amount = parsedData["amount"] as? Double,
                   let date = parsedData["date"] as? String,
                   let companyName = parsedData["companyName"] as? String {
                   
                    // Attempt to find a direct match for the expense
                    var matchingExpense = expenses.first { $0.name == companyName }

                    // If no direct match, search for an expense named "Other"
                    if matchingExpense == nil {
                        matchingExpense = expenses.first { $0.name == "Other" }
                    }
                    
                    // Create the transaction with the found expense ID or nil
                    let transaction = SMS(
                        id: UUID().uuidString,
                        cardID: cardID,
                        userID: userID,
                        transactionName: transactionName,
                        companyName: companyName,
                        amount: amount,
                        date: date,
                        expenseID: matchingExpense?.id
                    )
                    
                    self?.transactions.append(transaction)
                    self?.saveTransactions()
                    print("Transaction appended and save triggered with Expense ID: \(String(describing: matchingExpense?.id))")
                } else {
                    print("Required data missing from parsed SMS")
                }
            }
        }
    }

        func saveTransaction(cardID: String) {
            let expenseID = (transactionName == "Other") ? nil : expenseIdsByName[transactionName]
            let newTransaction = SMS(
                id: UUID().uuidString,
                cardID: cardID,
                transactionName: transactionName,
                amount: Double(amount) ?? 0.0,
                date: Date().formatted(),
                expenseID: expenseID,
                currency: currency1
            )
            
            do {
                try db.collection("newTransactions").document(newTransaction.id).setData(from: newTransaction)
            } catch {
                print("Error saving transaction: \(error)")
            }
        }
    
    // Fetch expenses and extract names
    func fetchExpenseNames(cardID: String) {
        db.collection("expenses").whereField("cardID", isEqualTo: cardID).getDocuments { [weak self] (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching documents: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            var names = snapshot.documents.compactMap { doc -> String? in
                let expense = try? doc.data(as: Expenses.self)
                if let name = expense?.name, let id = expense?.id {
                    self?.expenseIdsByName[name] = id
                }
                return expense?.name
            }
            names.append("Other")
            self?.transactionNames = names
        }
    }
    }


