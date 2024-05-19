//
//  ChartViewViewModel.swift
//  Wasilaah
//
//  Created by sumaiya on 18/05/2567 BE.
//


import Foundation
import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift





class ChartViewViewModel: ObservableObject {
    
    @Published var expenses = [Expenses]()
    @Published var cardID: String
    @ObservedObject var cardViewModel: CardViewModel = CardViewModel()
    
    private var db = Firestore.firestore()
   
     
    init(cardID: String) {
        self.cardID = cardID
        print("Initialized ViewModel with cardID: \(cardID)")
        addInitialExpense() // Add an initial expense on initialization
        setupDataListeners() // Setup listeners to keep data updated
        
        
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
    
    private func addInitialExpense() {
        let initialExpense = Expenses(id: UUID(), cardID: self.cardID, name: "", type: .fixed, currency: .dollar, paymentDate: .monthly, amount: 0.0, range: nil, dateCreated: Date())
        expenses.append(initialExpense)
    }
    
    func monthBounds(forYear year: Int, month: Int) -> (start: Timestamp, end: Timestamp) {
        var components = DateComponents()
        components.year = year
        components.month = month
        let calendar = Calendar.current
        let startDate = calendar.date(from: components)!
        let endDate = calendar.date(byAdding: DateComponents(month: 1, second: -1), to: startDate)!
        
        return (start: Timestamp(date: startDate), end: Timestamp(date: endDate))
    }
    
    
    func fetchFixedExpensesByMonth(forCardIDs cardIDs: [String], year: Int, month: Int, completion: @escaping ([Expenses]) -> Void) {
        // Access Firestore
        let db = Firestore.firestore()
        
        // Calculate the start and end of the month
        let (startOfMonth, endOfMonth) = monthBounds(forYear: year, month: month)
        
        let expensesRef = db.collection("expenses")
        
        // Create a compound query to fetch expenses for multiple card IDs and within the specified month
        let query = expensesRef
            .whereField("type", isEqualTo: "Fixed")
            .whereField("cardID", in: cardIDs)
            .whereField("dateCreated", isGreaterThanOrEqualTo: startOfMonth)
            .whereField("dateCreated", isLessThanOrEqualTo: endOfMonth)
        
        // Fetch documents
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching expenses: \(error.localizedDescription)")
                completion([])
            } else {
                // Array to hold fetched expenses
                var expensesArray = [Expenses]()
                
                // Iterate through documents
                for document in querySnapshot!.documents {
                    do {
                        // Convert Firestore data to Expense object
                        let expense = try document.data(as: Expenses.self)
                        expensesArray.append(expense)
                        print("Fetched expense: \(expense)")
                        
                    } catch {
                        print("Error decoding expense: \(error.localizedDescription)")
                    }
                }
                
                // Call completion handler with fetched expenses
                completion(expensesArray)
            }
        }
    }
    enum ExpenseType: String {
        case fixed = "Fixed"
        case changable = "Changable"
        // Add more types as needed
    }
    
    func fetchFixedExpenses(forCardIDs cardIDs: [String], userMonth: Int, expenseType: ExpenseType, completion: @escaping ([Expenses]) -> Void) {
        // Access Firestore
        let db = Firestore.firestore()
        
        let expensesRef = db.collection("expenses")
        
        // Get the raw value of the expense type enum
        let expenseTypeRawValue = expenseType.rawValue
        
        // Create a compound query to fetch expenses for multiple card IDs
        let query = expensesRef.whereField("type", isEqualTo: expenseTypeRawValue) // Filter by expense type
            .whereField("cardID", in: cardIDs)
        
        // Fetch documents
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching expenses: \(error.localizedDescription)")
                completion([])
            } else {
                // Array to hold fetched expenses
                var expensesArray = [Expenses]()
                
                // Iterate through documents
                for document in querySnapshot!.documents {
                    // Convert Firestore data to Expense object
                    do {
                        let expense = try document.data(as: Expenses.self)
                        
                        // Extracting only the month from dateCreated
                        let calendar = Calendar.current
                        let month = calendar.component(.month, from: expense.dateCreated)
                        
                        // Compare the extracted month with the user-supplied month
                        if month == userMonth {
                            expensesArray.append(expense)
                            print("Fetched expense: 🧬\(expense)")
                        } else {
                            print("Expense does not match the user-supplied month.🧲")
                        }
                        
                    } catch {
                        print("Error decoding expense: \(error.localizedDescription)")
                    }
                }
                
                // Call completion handler with fetched expenses
                completion(expensesArray)
            }
        }
    }
    
    
    
    func fetchCards(userID: String, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("cards")
            .whereField("userID", isEqualTo: userID)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching cards: \(error)")
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                // Map documents to Card objects and assign to cardViewModel.cards
                self.cardViewModel.cards = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Card.self)
                }
                
                // Call completion handler after populating cards
                completion()
            }
    }
    
    
    func fetchAllExpenses(forCardIDs cardIDs: [String], userMonth: Int, week: String?, completion: @escaping (Double?) -> Void) {
        // Access Firestore
        let db = Firestore.firestore()
        
        let expensesRef = db.collection("expenses")
        
        // Create a compound query to fetch expenses for multiple card IDs
        let query = expensesRef.whereField("cardID", in: cardIDs)
        
        // Variable to hold the total expenses for the selected month
        var totalExpensesForMonth: Double = 0.0
        
        // Fetch documents
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching expenses: \(error.localizedDescription)")
                completion(nil)
            } else {
                // Dictionary to hold total expenses for each week
                var weeklyExpenses = [String: Double]()
                
                // Iterate through documents
                for document in querySnapshot!.documents {
                    // Convert Firestore data to Expense object
                    do {
                        let expense = try document.data(as: Expenses.self)
                        
                        // Extracting month and day from dateCreated
                        let calendar = Calendar.current
                        let month = calendar.component(.month, from: expense.dateCreated)
                        let day = calendar.component(.day, from: expense.dateCreated)
                        
                        // Determine the week based on the day
                        var expenseWeek = ""
                        switch day {
                        case 1...7:
                            expenseWeek = "Week 1"
                        case 8...15:
                            expenseWeek = "Week 2"
                        case 16...23:
                            expenseWeek = "Week 3"
                        case 24...31:
                            expenseWeek = "Week 4"
                        default:
                            break
                        }
                        
                        // Compare the extracted month with the user-supplied month
                        if month == userMonth {
                            // Print individual expenses with month, day, and week
                            print("Fetched expense: 🧱 Month: \(month)💊, Day: \(day), Week: 🧿\(expenseWeek), Expense: \(expense)")
                            
                            // Add expense amount to the corresponding week
                            if let amount = weeklyExpenses[expenseWeek] {
                                weeklyExpenses[expenseWeek] = amount + expense.amount
                            } else {
                                weeklyExpenses[expenseWeek] = expense.amount
                            }
                            
                            // Accumulate expense amount for the selected month
                            totalExpensesForMonth += expense.amount
                        } else {
                            print("Expense does not match the user-supplied month.")
                        }
                        
                    } catch {
                        print("Error decoding expense: \(error.localizedDescription)")
                    }
                }
                
                // Print weekly expenses
                for (week, amount) in weeklyExpenses {
                    print("Week: \(week), Total Amount: \(amount)")
                }
                
                // Print total expenses for the selected month
                print("Total Expenses for Month🚵🏼 \(userMonth): \(totalExpensesForMonth)")
                
                // If a specific week is provided, return the total amount for that week
                if let requestedWeek = week {
                    if let totalAmount = weeklyExpenses[requestedWeek] {
                        print("Requested Week: \(requestedWeek), Total Amount: \(totalAmount)")
                        completion(totalAmount)
                    } else {
                        // Week not found
                        completion(nil)
                    }
                } else {
                    // If no specific week is provided, return nil
                    completion(nil)
                }
            }
        }
    }
}

