//
//  ExpenseFormViewModel.swift
//  Namaa
//
//  Created by Afrah Saleh on 27/10/1445 AH.
//

import Foundation
import Firebase
import FirebaseStorage

class ExpenseFormViewModel: ObservableObject {
    @Published var cardID: String
    @Published var name: String = ""
    @Published var selectedType: ExpenseType = .fixed
    @Published var selectedCurrency: Currency = .SAR
    @Published var selectedPaymentDate: PaymentDate = .monthly
    @Published var dayOfPurchase: String = "" {
            didSet {
                validateDayOfPurchase()
            }
        }
    @Published var dayOfPurchaseIsValid: Bool = true

    @Published var amount: String = ""
    @Published var rangeFrom: String = "" {
        didSet {
            validateRange()
        }
    }
    @Published var rangeTo: String = "" {
        didSet {
            validateRange()
        }
    }
    @Published var isRangeValid: Bool = true
    
    private var db = Firestore.firestore()
//    init(cardID: String) {
//        self.cardID = cardID
//        print("Initialized ViewModel with cardID: \(cardID)")
//    }
    init(expense: Expenses) {
        self.cardID = expense.cardID
        self.name = expense.name
        self.selectedType = expense.type ?? .fixed
        self.selectedCurrency = expense.currency
        self.selectedPaymentDate = expense.paymentDate ?? .monthly
        self.dayOfPurchase = String(expense.dayOfPurchase ?? 1)
        self.amount = String(expense.amount)
        self.rangeFrom = String(expense.range?.from ?? 0.0)
        self.rangeTo = String(expense.range?.to ?? 0.0)
//        
    }

    func validateDayOfPurchase() {
        if let day = Int(dayOfPurchase), day >= 1 && day <= 30 {
            dayOfPurchaseIsValid = true
        } else {
            dayOfPurchaseIsValid = false
        }
    }

    func validateRange() {
        if let from = Double(rangeFrom), let to = Double(rangeTo), from <= to {
            isRangeValid = true
        } else {
            isRangeValid = false
        }
    }
    
    func saveExpense() {
        guard let amountDouble = Double(amount) else { return }
        print("Adding expense with cardID: \(cardID)")
        let newExpense = Expenses(
            id: UUID(),
            cardID: cardID,
            name: name,
            type: selectedType,
            currency: selectedCurrency,
            paymentDate: selectedPaymentDate,
            dayOfPurchase: Int(dayOfPurchase),
            amount: amountDouble,
            range: selectedType == .changeable ? Range1(from: Double(rangeFrom) ?? 0.0, to: Double(rangeTo) ?? 0.0) : nil,
            dateCreated: Date()
        )

        do {
            try db.collection("expenses").document(newExpense.id.uuidString).setData(from: newExpense) { error in
                if let error = error {
                    print("Error saving to Firestore: \(error)")
                } else {
                    print("Expense saved successfully")
                }
            }
        } catch let error {
            print("Error preparing the data: \(error)")
        }
    }

}
