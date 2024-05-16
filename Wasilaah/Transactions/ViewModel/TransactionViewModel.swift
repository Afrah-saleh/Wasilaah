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

class TransactionViewModel: ObservableObject {
    @Published var transactions: [TransactionEntry] = []

    @Published var transactionNames: [String] = [] // Store fetched names
    private var db = Firestore.firestore()
    @Published var transactionName: String = ""
    @Published var companyName: String = ""
    @Published var matchedTransactions: [(TransactionEntry, Expenses)] = []
    @Published var expenses: [Expenses] = []
    @Published var fileURL: URL?
    @Published var amount: String = ""
    @Published var currency: Currency1 = .SAR  // Adjust to Currency1
    @Published var customTransactionName: String = "" // For custom input
    @Published var isOtherSelected: Bool = false // Track if "Other" is selected
    private var expenseIdsByName: [String: UUID] = [:]
    @Published var matchingTransactions: [TransactionEntry] = []

    
    init() {
        fetchTransactions()
    }
    
    func loadMatchingTransactions(for expense: Expenses) {
           self.matchingTransactions = self.transactions.filter {
               $0.transactionName.lowercased() == expense.name.lowercased() &&
               $0.cardID == expense.cardID
           }
       }
    func fetchTransactions() {
        db.collection("newTransactions").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching transactions: \(error.localizedDescription)")
            } else if let snapshot = querySnapshot {
                self.transactions = snapshot.documents.compactMap { document -> TransactionEntry? in
                    try? document.data(as: TransactionEntry.self)
                }
            }
        }
    }
    
    func fetchMatchingTransactions(from pdfData: [[String]], cardID: String) {
        db.collection("cards").document(cardID).getDocument { [weak self] (document, error) in
            if let document = document, let card = try? document.data(as: Card.self) {
                self?.processTransactions(pdfData: pdfData, cardID: cardID, userID: card.userID)
            } else {
                print("Error fetching card: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    private func processTransactions(pdfData: [[String]], cardID: String, userID: String) {
        let db = Firestore.firestore() // Ensure Firestore instance is initialized

        db.collection("expenses")
            .whereField("cardID", isEqualTo: cardID)
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                let expenses = snapshot.documents.compactMap { doc -> Expenses? in
                    try? doc.data(as: Expenses.self)
                }
                let expenseNames = Set(expenses.map { $0.name })

                self?.transactions = pdfData.compactMap { row -> TransactionEntry? in
                    guard row.count >= 4, let amount = Double(row[3]), expenseNames.contains(row[1]) else { return nil }

                    let singleName = row[1]
                    let expenseID = expenses.first(where: { $0.name == singleName })?.id

                    // Use the ID of "Other" if no matching name is found
                    let otherExpenseID = expenses.first(where: { $0.name == "Other" })?.id
                    let useExpenseID = expenseID ?? otherExpenseID

                    return TransactionEntry(
                        id: UUID().uuidString,
                        cardID: cardID,
                        userID: userID,
                        transactionName: singleName,
                        amount: amount,
                        date: row[0],
                        expenseID: useExpenseID
                    )
                }
                self?.saveTransactions()
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
                        print("Transaction successfully saved to Firestore with ID: \(docRef.documentID), Card ID: \(transaction.cardID)")
                    }
                }
            } catch {
                print("Error preparing transaction for Firestore: \(error)")
            }
        }
    }
    

    func findMatchingExpense(for companyName: String, cardID: String, completion: @escaping (UUID?) -> Void) {
        db.collection("expenses")
            .whereField("cardID", isEqualTo: cardID)
            .getDocuments { (querySnapshot, error) in
                if let snapshot = querySnapshot {
                    for document in snapshot.documents {
                        let expense = try? document.data(as: Expenses.self)
                        if expense?.name == companyName {
                            completion(expense?.id)
                            return
                        }
                    }
                }
                completion(nil)
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
    
    var showCustomNameField: Bool {
        return transactionName == "Other"
    }
    
    
    
    func saveTransaction(cardID: String, userID: String) {
        let expenseID = (transactionName == "Other") ? nil : expenseIdsByName[transactionName]
        let newTransaction = TransactionEntry(
            id: UUID().uuidString,
            cardID: cardID,
            userID: userID,
            transactionName: transactionName,
            amount: Double(amount) ?? 0.0,
            date: Date().formatted(),
            expenseID: expenseID,
            currency: currency,
            fileURL: fileURL
        )
        
        do {
            try db.collection("newTransactions").document(newTransaction.id).setData(from: newTransaction) { error in
                if let error = error {
                    print("Error saving transaction: \(error.localizedDescription)")
                } else {
                    // Call to update the related expense
                    self.updateExpenseAfterTransaction(transaction: newTransaction)
                }
            }
        } catch {
            print("Error saving transaction: \(error)")
        }
    }

    
    func fetchExpenses(cardID: String) {
        db.collection("expenses").whereField("cardID", isEqualTo: cardID).getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching expenses: \(error.localizedDescription)")
            } else {
                self.expenses = querySnapshot?.documents.compactMap { document -> Expenses? in
                    try? document.data(as: Expenses.self)
                } ?? []
            }
        }
    }
    func fetchAndDisplayMatchingTransactions(cardID: String) {
        fetchExpenses(cardID: cardID)
        
        db.collection("newTransactions").whereField("cardID", isEqualTo: cardID).getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self, !self.expenses.isEmpty else { return }
            
            if let error = error {
                print("Error fetching transactions: \(error.localizedDescription)")
            } else {
                let transactions = querySnapshot?.documents.compactMap { document -> TransactionEntry? in
                    try? document.data(as: TransactionEntry.self)
                } ?? []
                
                self.transactions = transactions.filter { transaction in
                    self.expenses.contains { expense in
                        expense.name == transaction.transactionName
                    }
                }
            }
        }
    }
    func updateExpenseAfterTransaction(transaction: TransactionEntry) {
        guard let expenseID = transaction.expenseID else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, hh:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let expenseRef = db.collection("expenses").document(expenseID.uuidString)
        expenseRef.getDocument { (document, error) in
            guard let document = document, document.exists,
                  var expense = try? document.data(as: Expenses.self) else {
                print("Error fetching expense: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let transactionDate = formatter.date(from: transaction.date),
               expense.lastTransactionDate == nil || expense.lastTransactionDate! < transactionDate {
                expense.lastTransactionDate = transactionDate
                try? expenseRef.setData(from: expense)
            }
        }
    }
    
}

extension TransactionViewModel{
    
    // Load an existing expense into the ViewModel
    func loadExpense(_ transaction: TransactionEntry) {
        DispatchQueue.main.async {
            self.transactionName = transaction.transactionName
            self.amount = String(transaction.amount)
            self.fileURL = transaction.fileURL
        }
    }
    func updateTransaction(transaction: TransactionEntry) {
            let docRef = db.collection("newTransactions").document(transaction.id)
            do {
                try docRef.setData(from: transaction) {
                    error in
                    if let error = error {
                        print("Error updating transaction: \(error.localizedDescription)")
                    } else {
                        print("Transaction successfully updated")
                    }
                }
            } catch {
                print("Error preparing transaction for Firestore: \(error)")
            }
        }
    func updateTransactions(_ trans: TransactionEntry) {
        let updatedtrans = TransactionEntry(
            id: trans.id,
            cardID: trans.cardID,
            userID: trans.userID,
            transactionName: transactionName,
            amount: Double(amount) ?? 0.0,
            date : trans.date

        )
        do {
            try db.collection("newTransactions").document(trans.id).setData(from: updatedtrans) { error in
                if let error = error {
                    print("Error updating Firestore: \(error)")
                } else {
                    print("Expense successfully updated")
                }
            }
        } catch let error {
            print("Error preparing the data: \(error)")
        }
    }


    func deleteTransaction(_ transaction: TransactionEntry) {
        db.collection("newTransactions").document(transaction.id).delete { [self] error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
                fetchtransaction(forCardID: transaction.cardID) // Refresh the list after deletion
            }
        }
    }

    func fetchtransaction(forCardID cardID: String) {
        db.collection("newTransactions")
            .whereField("cardID", isEqualTo: cardID)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No documents or error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self?.transactions = documents.compactMap { document in
                    try? document.data(as: TransactionEntry.self)
                }
            }
    }
    
    
   }
