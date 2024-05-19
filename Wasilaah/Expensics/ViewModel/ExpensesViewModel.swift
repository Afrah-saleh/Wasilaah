//
//  ExpensesViewModel.swift
//  Namaa
//
//  Created by Afrah Saleh on 19/10/1445 AH.
//

import SwiftUI
import Firebase
import FirebaseStorage
import PDFKit


class ExpensesViewModel: ObservableObject {
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
    @Published var expenses: [Expenses] = []
    var conversionRates: [String: Double] = ["Dollar": 3.75, "EUR": 4.05, "SAR": 1.0]  // Example rates
    
    init(cardID: String) {
        self.cardID = cardID
        print("Initialized ViewModel with cardID: \(cardID)")
        addInitialExpense() // Add an initial expense on initialization
        fetchExpenses(forCardID: cardID) // Ensure expenses are fetched on initialization
        setupDataListeners() // Setup listeners to keep data updated

        
    }
    
    
    // Computed property to get sorted expenses
    var sortedExpenses: [Expenses] {
        expenses.sorted { $0.dateCreated > $1.dateCreated }
    }

    // Computed property to calculate total expenses converted to SAR
    var totalExpensesInSAR: Double {
        expenses.reduce(0) { total, expense in
            let rate = conversionRates[expense.currency.rawValue] ?? 1.0
            let convertedAmount = expense.amount * rate
            print("Converting \(expense.amount) \(expense.currency.rawValue) to \(convertedAmount) SAR using rate \(rate)")
            return total + convertedAmount
        }
    }
 
    // Computed property to calculate total for "Other" expenses
    var totalOtherExpenses: Double {
        expenses.filter { $0.type == .other }.reduce(0) { total, expense in
            let rate = conversionRates[expense.currency.rawValue] ?? 1.0
            return total + (expense.amount * rate)
        }
    }

    // Computed property to calculate total for all expenses except "Other"
    var totalNonOtherExpenses: Double {
        expenses.filter { $0.type != .other }.reduce(0) { total, expense in
            let rate = conversionRates[expense.currency.rawValue] ?? 1.0
            return total + (expense.amount * rate)
        }
    }
    
    
    func validateRange() {
        if selectedType == .changeable {
            if let fromValue = Double(rangeFrom), let toValue = Double(rangeTo) {
                isRangeValid = toValue > fromValue
            } else {
                // Handle non-numeric or empty input if needed
                isRangeValid = true // or false, depending on your validation rules
            }
        }
    }
    
    func validateDayOfPurchase() {
           if let day = Int(dayOfPurchase), day >= 1 && day <= 30 {
               dayOfPurchaseIsValid = true
           } else {
               dayOfPurchaseIsValid = false
           }
       }
    func addExpense() {
        print("Adding expense with cardID: \(cardID)")
           let newExpense = Expenses(
               id: UUID(),
               cardID: cardID,
               name: name,
               type: selectedType,
               currency: selectedCurrency,
               paymentDate: selectedPaymentDate,
               dayOfPurchase: Int(dayOfPurchase), // Convert string to Int
               amount: Double(amount) ?? 0.0,
               range: selectedType == .changeable ? Range1(from: Double(rangeFrom) ?? 0.0, to: Double(rangeTo) ?? 0.0) : nil,
               dateCreated: Date()
           )

        do {
            try db.collection("expenses").document(newExpense.id.uuidString).setData(from: newExpense) { error in
                if let error = error {
                    print("Error saving to Firestore: \(error)")
                } else {
                    self.clearFields()
                }
            }
        } catch let error {
            print("Error preparing the data: \(error)")
        }
    }
    
    func NewExpense() {

        let NewExpense = Expenses(id: UUID(), cardID: cardID, name: "", type: .fixed, currency: .dollar, paymentDate: .monthly, amount: 0.0, range: nil, dateCreated: Date())
        expenses.append(NewExpense)
    }

    private func addInitialExpense() {
        let initialExpense = Expenses(id: UUID(), cardID: self.cardID, name: "", type: .fixed, currency: .dollar, paymentDate: .monthly, amount: 0.0, range: nil, dateCreated: Date())
        expenses.append(initialExpense)
    }

    func clearFields() {
        name = ""
        amount = ""
        rangeFrom = ""
        rangeTo = ""
        selectedType = .fixed // Reset to default or keep user choice
        dayOfPurchase = ""
    }
    func fetchExpenses(forCardID cardID: String) {
        db.collection("expenses")
            .whereField("cardID", isEqualTo: cardID)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No documents or error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self?.expenses = documents.compactMap { document in
                    try? document.data(as: Expenses.self)
                }
            }
    }
    
    

    // This function handles the upload of expenses from a PDF file
    func uploadExpensesFromPDF(url: URL) {
        let text = extractTextFromPDF(url: url)
        print("Extracted Text: \(text)") // Log the extracted text
        let parsedExpenses = parseTextToExpenses(text: text)
        print("Parsed Expenses: \(parsedExpenses)") // Log the parsed expenses
        uploadExpenses(expenses: parsedExpenses)
    }

    // This function extracts text from a PDF document
    func extractTextFromPDF(url: URL) -> String {
        guard let document = PDFDocument(url: url) else {
            print("Failed to load PDF")
            return ""
        }
        var fullText = ""
        for i in 0..<document.pageCount {
            guard let page = document.page(at: i) else { continue }
            fullText += page.string ?? ""
        }
        return fullText
    }

    // This function parses the text extracted from a PDF into an array of Expenses objects
    private func parseTextToExpenses(text: String) -> [Expenses] {
        let lines = text.components(separatedBy: .newlines)
        var expenses = [Expenses]()
        
        for line in lines.dropFirst(2) { // Skip header and sub-header
            let components = line.split(whereSeparator: { $0.isWhitespace }).map(String.init)
            if components.count >= 5 {
                let name = components[0]
                let typeString = components[1]
                let currencyString = components[2]
                let paymentDateString = components[3]
                
                guard let amount = Double(components[4]) else {
                    print("Failed to parse amount in line: \(line)")
                    continue
                }
                
                var from: Double = 0
                var to: Double = 0
                if components.count >= 7 {
                    from = Double(components[5]) ?? 0
                    to = Double(components[6]) ?? 0
                }
                
                let expense = Expenses(
                    id: UUID(),
                    cardID: self.cardID,
                    name: name,
                    type: ExpenseType(rawValue: typeString) ?? .fixed,
                    currency: Currency(rawValue: currencyString) ?? .dollar,
                    paymentDate: PaymentDate(rawValue: paymentDateString) ?? .monthly,
                    amount: amount,
                    range: Range1(from: from, to: to),
                    dateCreated: Date()
                )
                expenses.append(expense)
            } else {
                print("Insufficient data in line: \(line)")
            }
        }
        return expenses
    }

    // This function uploads an array of Expenses objects to Firestore
    private func uploadExpenses(expenses: [Expenses]) {
        for expense in expenses {
            do {
                try db.collection("expenses").document(expense.id.uuidString).setData(from: expense) { error in
                    if let error = error {
                        print("Error uploading expense: \(error)")
                    } else {
                        print("Expense successfully uploaded: \(expense)")
                    }
                }
            } catch let error {
                print("Error preparing data for Firestore: \(error)")
            }
        }
    }
    
    
    var selectedCurrencyString: Binding<String> {
        Binding<String>(
            get: { self.selectedCurrency.rawValue },
            set: {
                if let newCurrency = Currency(rawValue: $0) {
                    self.selectedCurrency = newCurrency
                }
            }
        )
    }
    
    var selectedTypeString: Binding<String> {
        Binding<String>(
            get: { self.selectedType.rawValue },
            set: {
                if let newType = ExpenseType(rawValue: $0) {
                    self.selectedType = newType
                }
            }
        )
    }
    
    var selectedPaymentDateString: Binding<String> {
        Binding<String>(
            get: { self.selectedPaymentDate.rawValue },
            set: {
                if let newDate = PaymentDate(rawValue: $0) {
                    self.selectedPaymentDate = newDate
                }
            }
        )
    }
    
    
    
    func addOtherExpense() {
           let newExpense = Expenses(
               id: UUID(),
               cardID: cardID,
               name: "Other",
               type: .other,  // Assuming 'Other' is a other type expense
               currency: .SAR,
               paymentDate: nil,  // Assuming no specific payment date
               dayOfPurchase: nil,  // Assuming no specific purchase day
               amount: Double(amount) ?? 0.0,
               range: nil,
               dateCreated: Date()
           )

           do {
               try db.collection("expenses").document(newExpense.id.uuidString).setData(from: newExpense) { error in
                   if let error = error {
                       print("Error saving to Firestore: \(error)")
                   } else {
                       self.clearFields()
                   }
               }
           } catch let error {
               print("Error preparing the data: \(error)")
           }
       }

       private func clearField() {
           amount = ""
       }
    func setupDataListeners() {
           subscribeToExpensesUpdates()
           // Add other data listeners as needed
       }

       func subscribeToExpensesUpdates() {
           db.collection("expenses").whereField("cardID", isEqualTo: self.cardID)
               .addSnapshotListener { [weak self] querySnapshot, error in
                   guard let documents = querySnapshot?.documents else {
                       print("No documents or error: \(error?.localizedDescription ?? "Unknown error")")
                       return
                   }
                   self?.expenses = documents.compactMap { document in
                       try? document.data(as: Expenses.self)
                   }
               }
       }
    
    
}
extension ExpensesViewModel {
    // Load an existing expense into the ViewModel
    func loadExpense(_ expense: Expenses) {
        name = expense.name
        amount = String(expense.amount)
        selectedType = expense.type ?? .fixed
        selectedCurrency = expense.currency
        selectedPaymentDate = expense.paymentDate ?? .monthly
        dayOfPurchase = expense.dayOfPurchase != nil ? String(expense.dayOfPurchase!) : ""
        if let range = expense.range {
            rangeFrom = String(range.from)
            rangeTo = String(range.to)
        }
    }
    
    // Update an existing expense in Firestore
    func updateExpense(_ expense: Expenses) {
        let updatedExpense = Expenses(
            id: expense.id,
            cardID: cardID,
            name: name,
            type: selectedType,
            currency: selectedCurrency,
            paymentDate: selectedPaymentDate,
            dayOfPurchase: Int(dayOfPurchase) ?? 0,
            amount: Double(amount) ?? 0.0,
            range: selectedType == .changeable ? Range1(from: Double(rangeFrom) ?? 0.0, to: Double(rangeTo) ?? 0.0) : nil,
            dateCreated: expense.dateCreated
        )

        do {
            try db.collection("expenses").document(expense.id.uuidString).setData(from: updatedExpense) { error in
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
    
    func deleteExpense(_ expense: Expenses) {
        db.collection("expenses").document(expense.id.uuidString).delete { [self] error in
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    print("Document successfully removed!")
                    fetchExpenses(forCardID: cardID) // Refresh the list after deletion
                }
            }
        }
}
