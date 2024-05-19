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
import UserNotifications


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
    
    
    private func calculateTotalExpenseAmount() {
        totalExpenseAmount = expenses.reduce(0) { total, expense in
            let rate = conversionRates[expense.currency.rawValue] ?? 1.0
            let convertedAmount = expense.amount * rate
            print("Converting \(expense.amount) \(expense.currency.rawValue) to \(convertedAmount) SAR using rate \(rate)")
            return total + convertedAmount
        }
    }
    
    
    private func matchTransactionsWithExpenses() {
        updateExpensesPaymentStatus()  // Ensure statuses are up to date
        DispatchQueue.main.async {
            for transaction in self.transactions {
                if let index = self.expenses.firstIndex(where: { $0.name == transaction.transactionName }) {
                    self.expenses[index].lastTransactionDate = transaction.dateCreated
                    self.expenses[index].isPaid = true  // Mark as paid upon matching transaction
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
        print("Original Expenses: \(expenses)")
        
        let filteredExpenses = expenses.filter { $0.name != "Other" }
        print("After Name Filter: \(filteredExpenses)")
        
        let dateFilteredExpenses = filteredExpenses.filter { expense in
            let daysLeft = daysUntilNextPayments(for: expense)
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
        
        let sortedExpenses = dateFilteredExpenses.sorted {
            daysUntilNextPayments(for: $0) < daysUntilNextPayments(for: $1)
        }
        print("Sorted Expenses: \(sortedExpenses)")
        
        return sortedExpenses
    }
    func daysUntilNextPayments(for expense: Expenses) -> Int {
        let calendar = Calendar.current
        let today = Date()
        
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
        
        // Check if `nextPaymentDate` is before or the same as `today`, and adjust based on payment frequency
        while nextPaymentDate <= today {
            if let paymentDate = expense.paymentDate {
                switch paymentDate {
                case .weekly:
                    nextPaymentDate = calendar.date(byAdding: .weekOfYear, value: 1, to: nextPaymentDate)!
                case .monthly:
                    nextPaymentDate = calendar.date(byAdding: .month, value: 1, to: nextPaymentDate)!
                case .yearly:
                    nextPaymentDate = calendar.date(byAdding: .year, value: 1, to: nextPaymentDate)!
                }
            } else {
                print("Payment Date type is not set")
                return 0
            }
        }
        
        // Calculate days until `nextPaymentDate`
        let daysLeft = calendar.dateComponents([.day], from: today, to: nextPaymentDate).day ?? 0
        return daysLeft
    }
    func getActionableExpenses(from expenses: [Expenses]) -> [Expenses] {
        let today = Date()
        return expenses.filter { expense in
            let daysLeft = daysUntilNextPayment(for: expense)
            let hasRecentTransaction = expense.lastTransactionDate.map {
                Calendar.current.isDate($0, inSameDayAs: today) || $0 > today
            } ?? false
            // Check if the expense is not paid, is not of type "Other", and is within the actionable range
            let isActionable = !hasRecentTransaction && expense.name != "Other" && !(expense.isPaid ?? false)
            //  print("Expense: \(expense.name), Days Left: \(daysLeft), Has Recent Transaction: \(hasRecentTransaction), Is Actionable: \(isActionable), Is Paid: \(expense.isPaid)")
            return isActionable
        }
    }
    func getUnpaidExpenses() -> [Expenses] {
        return expenses.filter { !($0.isPaid ?? false) }
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
    func updateExpensesPaymentStatus() {
        let today = Date()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.expenses = self.expenses.map { expense in
                var updatedExpense = expense
                let daysUntilNextPayment = self.daysUntilNextPayment(for: expense)
                // If the next payment is due today or past, mark as unpaid
                if daysUntilNextPayment <= 0 {
                    updatedExpense.isPaid = false
                }
                return updatedExpense
            }
        }
    }
    func scheduleNotifications() {
        let expenses = getSortedExpenses()
        let notificationCenter = UNUserNotificationCenter.current()

        // Remove all previous notifications to avoid duplicates
        notificationCenter.removeAllPendingNotificationRequests()
        
        print("Scheduling notifications for expenses with days left <= 10")
        
        // Determine the current locale
        let currentLanguageCode = Locale.current.language.languageCode?.identifier

        // Schedule new notifications
        for expense in expenses {
            let daysLeft = daysUntilNextPayment(for: expense)
            print("Expense: \(expense.name), Days Left: \(daysLeft)")

            if daysLeft <= 10 {
                let content = UNMutableNotificationContent()
                // Set title and body based on the current locale
                         if currentLanguageCode == "ar" {
                             content.title = "الدفعة القادمة"
                             content.body = "دفعتك لـ \(expense.name) من \(expense.amount) \(expense.currency.rawValue) مستحقة في \(daysLeft) أيام"
                         } else {
                             content.title = "Upcoming Payment Due"
                             content.body = "Your payment for \(expense.name) of \(expense.amount) \(expense.currency.rawValue) is due in \(daysLeft) days."
                         }
                         
                         content.sound = UNNotificationSound.default

//                content.title = "Upcoming Payment Due"
//                content.body = "Your payment for \(expense.name) of \(expense.amount) \(expense.currency.rawValue) is due in \(daysLeft) days."
  //              content.sound = UNNotificationSound.default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                notificationCenter.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification for \(expense.name): \(error)")
                    } else {
                        print("Notification scheduled for \(expense.name), \(daysLeft) days ahead.")
                    }
                }
            }
        }
    }
    func scheduleUpdateReminder() {
        let content = UNMutableNotificationContent()
//        content.title = "Update Your Expenses"
//        content.body = "It's time to update your expenses to stay on top of things"
        // Fetching title and body from Localizable.strings based on current locale
        content.title = NSLocalizedString("update_expenses", comment: "Title for updating expenses reminder")
        content.body = NSLocalizedString("update_body", comment: "Body text for expenses update reminder")
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // Fire after 5 seconds for demo
        
        // Fire every 7 days
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 604800, repeats: true)
        let request = UNNotificationRequest(identifier: "updateReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling update reminder: \(error)")
            }
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
