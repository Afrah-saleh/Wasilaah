//
//  ExpensesSection.swift
//  Namaa
//
//  Created by sumaiya on 06/05/2567 BE.
//

import SwiftUI
import Firebase


struct ExpensesSection: View {
    @ObservedObject var authViewModel: sessionStore
    @ObservedObject var transitionviewmodel = TransactionViewModel()
    var expenses: [Expenses]
    var strokeColors: [Color] 

    var body: some View {
        VStack {
            // Check for user session; this might be used for other purposes or can be removed if not needed.
            if let user = authViewModel.session {
                // Display expenses filtered by cardID, sorted by dateCreated, taking the last 4 entries.
                let filteredExpenses = expenses
                    .sorted(by: { $0.dateCreated > $1.dateCreated })
                    .prefix(4)

                if filteredExpenses.isEmpty {
                    SingleExpenses(
                        expense: Expenses(id: UUID(), cardID: "1", name: "No expenses records", currency: .SAR, amount: 0.0, dateCreated: Date()),
                        circleColor: Color.gray,
                        viewIcon: nil
                    )
                } else {
                    ForEach(Array(filteredExpenses), id: \.id) { expense in
                        SingleExpenses(
                            expense: expense,
                            circleColor: getColor(forIndex: filteredExpenses.firstIndex(where: { $0.id == expense.id }) ?? 0),
                            viewIcon: "chevron.right"
                        )
                    }
                }
            } else {
                // Display message when there is no user logged in.
                SingleExpenses(
                    expense: Expenses(id: UUID(), cardID: "default", name: "Logged Out", currency: .SAR, amount: 0.0, dateCreated: Date()),
                    circleColor: Color.gray,
                    viewIcon: nil
                )
                Text("Please log in to view your expenses.")
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            print("ExpensesSection appeared with \(expenses.count) expenses")
        }
    }

    func getColor(forIndex index: Int) -> Color {
        return strokeColors[index % strokeColors.count]
    }
}

