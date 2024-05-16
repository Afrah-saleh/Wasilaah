//
//  TViewModel.swift
//  Namaa
//
//  Created by Afrah Saleh on 02/11/1445 AH.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation


class TViewModel: ObservableObject {
    
    @Published var transactions: [TransactionEntry] = []
    @Published var expenses: [Expenses] = []
    // Additional properties to hold the summary data
    @Published var summaryIncrease: (name: String, percentage: Double)?
    @Published var summaryDecrease: (name: String, percentage: Double)?
    @Published var totalTransactionAmount: Double = 0.0
     @Published var totalExpenseAmount: Double = 0.0
    var conversionRates: [String: Double] = ["Dollar": 3.75, "EUR": 4.05, "SAR": 1.0]  // Example rates

    // Firestore database instance
    private var db = Firestore.firestore()
    
    
    // Fetch transactions for a specific card ID
    func fetchTransactions(cardID: String) {
        db.collection("newTransactions").whereField("cardID", isEqualTo: cardID).getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching transactions: \(error.localizedDescription)")
            } else {
                self.transactions = querySnapshot?.documents.compactMap { document -> TransactionEntry? in
                    try? document.data(as: TransactionEntry.self)
                } ?? []
                self.matchTransactionsWithExpenses()
                self.calculateTotalTransactionAmount()

            }
        }
    }
    
    // Fetch expenses for a specific card ID
    func fetchExpenses(cardID: String) {
        db.collection("expenses").whereField("cardID", isEqualTo: cardID).getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching expenses: \(error.localizedDescription)")
            } else {
                self.expenses = querySnapshot?.documents.compactMap { document -> Expenses? in
                    try? document.data(as: Expenses.self)
                } ?? []
                self.matchTransactionsWithExpenses()
                self.calculateTotalExpenseAmount()

            }
        }
    }
    // Calculate the total amount of transactions
        private func calculateTotalTransactionAmount() {
            totalTransactionAmount = transactions.reduce(0) { $0 + $1.amount }
        }

        // Calculate the total amount of expenses
//        private func calculateTotalExpenseAmount() {
//            totalExpenseAmount = expenses.reduce(0) { $0 + $1.amount }
//        }
    private func calculateTotalExpenseAmount() {
        totalExpenseAmount = expenses.reduce(0) { total, expense in
            let rate = conversionRates[expense.currency.rawValue] ?? 1.0
            let convertedAmount = expense.amount * rate
            print("Converting \(expense.amount) \(expense.currency.rawValue) to \(convertedAmount) SAR using rate \(rate)")
            return total + convertedAmount
        }
    }

    private func matchTransactionsWithExpenses() {
        DispatchQueue.main.async {
            for transaction in self.transactions {
                if let index = self.expenses.firstIndex(where: { $0.name == transaction.transactionName }) {
                    self.expenses[index].lastTransactionDate = transaction.dateCreated
                }
            }
        }
    }

    
    // Function to fetch and display matching transactions
    func fetchAndDisplayMatchingTransactions(cardID: String) {
        fetchExpenses(cardID: cardID)
        fetchTransactions(cardID: cardID)
        calculateSummaries()
    }
    
    // Method to return matching expense for a given transaction
    func matchingExpense(for transaction: TransactionEntry) -> Expenses? {
        return expenses.first { $0.name == transaction.transactionName }
    }
    
    
    // Assuming that differenceAndPercentage returns a tuple (diff: Double, percentage: Double)
    func differenceAndPercentage(for transaction: TransactionEntry) -> (diff: Double, percentage: Double)? {
        guard let expense = expenses.first(where: { $0.name == transaction.transactionName }) else {
            return nil
        }
        let diff = transaction.amount - expense.amount
        let percentage = (diff / expense.amount) * 100
        return (diff, percentage)
    }
    
    // Calculate the transaction with the highest percentage increase
    func transactionWithLargestPercentageIncrease() -> (transaction: TransactionEntry, percentage: Double)? {
        return transactions.compactMap { transaction -> (TransactionEntry, Double)? in
            guard let result = differenceAndPercentage(for: transaction), result.percentage > 0 else {
                return nil
            }
            return (transaction, result.percentage)
        }.max(by: { $0.percentage < $1.percentage })
    }
    
    // Calculate the transaction with the highest percentage decrease
    func transactionWithLargestPercentageDecrease() -> (transaction: TransactionEntry, percentage: Double)? {
        return transactions.compactMap { transaction -> (TransactionEntry, Double)? in
            guard let result = differenceAndPercentage(for: transaction), result.percentage < 0 else {
                return nil
            }
            return (transaction, result.percentage)
        }.min(by: { $0.percentage < $1.percentage })
    }
    
    // Calculate summaries based on the transactions with the largest percentage changes
    func calculateSummaries() {
        if let increase = transactionWithLargestPercentageIncrease() {
            summaryIncrease = (increase.transaction.transactionName, increase.percentage)
        }
        
        if let decrease = transactionWithLargestPercentageDecrease() {
            summaryDecrease = (decrease.transaction.transactionName, decrease.percentage)
        }
    }
    func hasTransactionsFor(cardID: String) -> Bool {
        // Check if there are any transactions for the given card ID
        return transactions.contains(where: { $0.cardID == cardID })
    }
    
    // Function to fetch and display transactions and expenses for a selected month
    func fetchTransactionsAndExpensesForMonth(cardID: String, monthYear: String) {
        // Clear existing data
        transactions.removeAll()
        expenses.removeAll()
        
        // Fetch expenses
        db.collection("expenses").whereField("cardID", isEqualTo: cardID).getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error fetching expenses: \(error.localizedDescription)")
            } else {
                self?.expenses = querySnapshot?.documents.compactMap { document -> Expenses? in
                    guard let expense = try? document.data(as: Expenses.self),
                          expense.dateCreated.monthYearString() == monthYear else {
                        return nil
                    }
                    return expense
                } ?? []
            }
        }
        
        // Fetch transactions
        db.collection("newTransactions").whereField("cardID", isEqualTo: cardID).getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error fetching transactions: \(error.localizedDescription)")
            } else {
                self?.transactions = querySnapshot?.documents.compactMap { document -> TransactionEntry? in
                    guard let transaction = try? document.data(as: TransactionEntry.self),
                          let date = transaction.date.toDate(with: .transactionFormatter),
                          date.monthYearString() == monthYear else {
                        return nil
                    }
                    return transaction
                } ?? []
            }
        }
    }
    
    // Method to check if the amount of a new transaction matches the expense or has changed
    func checkAmountChangeForNewTransaction(transaction: TransactionEntry) -> String? {
        guard let expense = matchingExpense(for: transaction) else {
            return nil // No matching expense found
        }
        if transaction.amount != expense.amount {
            return transaction.transactionName // Amount has changed
        }
        return nil // Amount is the same as the expense
    }
    func transactionWithHighestAmount() -> TransactionEntry? {
        return transactions.max(by: { $0.amount < $1.amount })
    }
    
    func getSortedExpenses() -> [Expenses] {
        // Log the original list of all expenses for debugging purposes.
        print("Original Expenses: \(expenses)")
        
        // Filter out any expenses with the name "Other".
        let filteredExpenses = expenses.filter { $0.name != "Other" }
        print("After Name Filter: \(filteredExpenses)")
        
        // Further filter the expenses based on the days left until their next payment.
        let dateFilteredExpenses = filteredExpenses.filter { expense in
            let daysLeft = daysUntilNextPayment(for: expense)
            // Log each expense and the days left for its next payment.
            print("Expense: \(expense.name), Days until next payment: \(daysLeft)")
            switch expense.paymentDate {
            case .weekly where daysLeft <= 3:
                return true
            case .monthly where daysLeft <= 10:
                return true
            case .yearly where daysLeft <= 20:
                return true
            default:
                return false
            }
        }
        print("After Date Filter: \(dateFilteredExpenses)")
        
        // Sort the filtered expenses by the number of days until the next payment, in ascending order.
        let sortedExpenses = dateFilteredExpenses.sorted {
            daysUntilNextPayment(for: $0) < daysUntilNextPayment(for: $1)
        }
        print("Sorted Expenses: \(sortedExpenses)")
        
        // Return the sorted and filtered list of expenses.
        return sortedExpenses
    }
    
    func getActionableExpenses(from expenses: [Expenses]) -> [Expenses] {
        let today = Date()
        return expenses.filter { expense in
            let daysLeft = daysUntilNextPayment(for: expense)
            let hasRecentTransaction = expense.lastTransactionDate.map {
                Calendar.current.isDate($0, inSameDayAs: today) || $0 > today
            } ?? false
            // Check if days left is between -5 (5 days past due) and 5 (due within next 5 days)
            let isActionable = !hasRecentTransaction && expense.name != "Other"
            print("Expense: \(expense.name), Days Left: \(daysLeft), Has Recent Transaction: \(hasRecentTransaction), Is Actionable: \(isActionable)")
            return isActionable
        }
    }
    
    func daysUntilNextPayment(for expense: Expenses) -> Int {
        let calendar = Calendar.current
        
        // Safely unwrap `dayOfPurchase`
        guard let dayOfPurchase = expense.dayOfPurchase else {
            print("Day of Purchase is not set")
            return 0
        }
        
        // Get the `dateCreated` from expense
        let dateCreated = expense.dateCreated
        
        // Set initial `nextPaymentDate` to `dayOfPurchase` of the month of `dateCreated`
        var components = calendar.dateComponents([.year, .month], from: dateCreated)
        components.day = dayOfPurchase
        var nextPaymentDate = calendar.date(from: components) ?? dateCreated
        
        // Check if `nextPaymentDate` is before or the same as `dateCreated`, and adjust based on payment frequency
        if let paymentDate = expense.paymentDate {
            if nextPaymentDate <= dateCreated {
                switch paymentDate {
                case .weekly:
                    // Find the next weekly payment from `dateCreated`
                    nextPaymentDate = calendar.date(byAdding: .day, value: 7, to: dateCreated)!
                case .monthly:
                    // Set to the same day next month
                    nextPaymentDate = calendar.date(byAdding: .month, value: 1, to: nextPaymentDate)!
                case .yearly:
                    // Set to the same day next year
                    nextPaymentDate = calendar.date(byAdding: .year, value: 1, to: nextPaymentDate)!
                    
                }
            } else if nextPaymentDate == dateCreated {
                // Adjust to the next respective period if due today
                nextPaymentDate = calendar.date(byAdding: paymentDate.dateComponent(), value: 1, to: nextPaymentDate)!
            }
        } else {
            print("Payment Date type is not set")
            return 0
        }
        
        // Calculate days until `nextPaymentDate`
        let today = Date()
        let daysLeft = calendar.dateComponents([.day], from: today, to: nextPaymentDate).day ?? 0
        return daysLeft
    }
    
    func calculateTotalExpensesInSAR(expenses: [Expenses], conversionRates: [String: Double]) -> Double {
        return expenses.reduce(0) { total, expense in
            let rate = conversionRates[expense.currency.rawValue] ?? 1.0
            let convertedAmount = expense.amount * rate
            print("Converting \(expense.amount) \(expense.currency.rawValue) to \(convertedAmount) SAR using rate \(rate)")
            return total + convertedAmount
        }
    }
}



    // Helper extension to map `PaymentDate` to `Calendar.Component`
    extension PaymentDate {
        func dateComponent() -> Calendar.Component {
            switch self {
            case .weekly:
                return .weekOfYear
            case .monthly:
                return .month
            case .yearly:
                return .year
      
            }
        }
    }
    





extension DateFormatter {
    static let transactionFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, hh:mm a"
        return formatter
    }()
    
    static let expensesFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}

extension String {
    func toDate(with formatter: DateFormatter) -> Date? {
        return formatter.date(from: self)
    }
}

extension Date {
    func monthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter.string(from: self)
    }
}
