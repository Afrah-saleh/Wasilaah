////
////  AllTransactionsView.swift
////  Namaa
////
////  Created by Afrah Saleh on 29/10/1445 AH.
////
//
import SwiftUI
import FirebaseFirestore
struct AllTransactionsView: View {
    @ObservedObject var transactionsViewModel: TransactionViewModel
    @ObservedObject var expensesViewModel: ExpensesViewModel
    @Environment(\.presentationMode) var presentationMode
    var cardID: String
    @ObservedObject var authViewModel: sessionStore // Ensure this is provided

    var body: some View {
        if let user = authViewModel.session {
            // Filter transactions for the current user and specific card ID
            let filteredTransactions = transactionsViewModel.transactions.filter { transaction in
                transaction.userID == user.uid && transaction.cardID == cardID
            }
            
            NavigationView {
                List(filteredTransactions, id: \.id) { transaction in
                    NavigationLink(destination: TransactionDetailView(viewModel: transactionsViewModel, transaction: transaction, expensesViewModel: expensesViewModel)) {
                        VStack(alignment: .leading) {
                            HStack(spacing: 190) {
                                Text(transaction.transactionName)
                                HStack {
                                    Text("\(transaction.amount, specifier: "%.2f")")
                                    Text(transaction.currency?.rawValue ?? "Unknown")
                                        .font(.custom("", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.top, 5)
                                }
                            }
                            Text(transaction.date) // Assuming date is a string.
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                })
                .navigationBarTitle("All Transactions", displayMode: .inline)
            }
        } else {
            Text("User not logged in")
        }
    }
}
