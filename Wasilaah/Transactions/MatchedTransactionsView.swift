//
//  MatchedTransactionsView.swift
//  Namaa
//
//  Created by Afrah Saleh on 02/11/1445 AH.
//

import SwiftUI

struct MatchedTransactionsView: View {
    @ObservedObject var viewModel: TViewModel
    var cardID: String
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Transactions")) {
                    ForEach(viewModel.transactions, id: \.id) { transaction in
                        TransactionRow(viewModel: viewModel, transaction: transaction)
                    }
                }
                Section(header: Text("Highlights")) {
                    if let increase = viewModel.transactionWithLargestPercentageIncrease() {
                        VStack(alignment: .leading) {
                            Text("Largest Increase: \(increase.transaction.transactionName)")
                            Text("Amount: \(increase.transaction.amount, specifier: "%.2f"), Increase: \(String(format: "%.2f", increase.percentage))%")
                        }
                    }
                    if let decrease = viewModel.transactionWithLargestPercentageDecrease() {
                        VStack(alignment: .leading) {
                            Text("Largest Decrease: \(decrease.transaction.transactionName)")
                            Text("Amount: \(decrease.transaction.amount, specifier: "%.2f"), Decrease: \(String(format: "%.2f", decrease.percentage))%")
                        }
                    }
                }
            }
            .navigationTitle("Matched Transactions")
            .onAppear {
                viewModel.fetchAndDisplayMatchingTransactions(cardID: cardID)
            }
        }
    }
}

struct TransactionRow: View {
    @ObservedObject var viewModel: TViewModel
    var transaction: TransactionEntry

    var body: some View {
        VStack(alignment: .leading) {
            Text(transaction.transactionName)
                .font(.headline)
            Text(transaction.companyName ?? "")
                .font(.subheadline)
            HStack {
                Text("Transaction Amount: \(transaction.amount, specifier: "%.2f")")
                Spacer()
                if let expense = viewModel.matchingExpense(for: transaction) {
                    Text("Expense Amount: \(expense.amount, specifier: "%.2f")")
                } else {
                    Text("No corresponding expense")
                }
                Spacer()
                Text("Currency: \(transaction.currency!.rawValue)")
            }
            if let result = viewModel.differenceAndPercentage(for: transaction) {
                HStack {
                    Text("Difference: \(result.diff)")
                    Spacer()
                    Text("Percentage: \(String(format: "%.2f", result.percentage))%")
                }
            }
        }
    }
}


#Preview {
    MatchedTransactionsView(viewModel: TViewModel(), cardID: "12")
}
