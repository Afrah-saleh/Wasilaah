////
////  Edit transaction.swift
////  Namaa
////
////  Created by Afrah Saleh on 06/11/1445 AH.
////
//
//import Foundation
//import SwiftUI
//
//struct EditTransaction: View {
//    @Environment(\.presentationMode) var presentationMode
//    @ObservedObject var viewModel: TransactionViewModel
//    @ObservedObject var expensesViewModel: ExpensesViewModel
//    var transaction: TransactionEntry
//    @State private var showingDeleteAlert = false
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10){
//            Text("Expenses Name")
//                .font(.callout)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            TextField("Name", text: $viewModel.transactionName)
//                .padding()
//                .frame(height: 44)
//                .background(Color(UIColor.systemGray6))
//                .cornerRadius(8)
//            
//            Text("Expenses Amount")
//                .font(.callout)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            TextField("Amount", text: $viewModel.amount)
//                .padding()
//                .frame(height: 44)
//                .background(Color(UIColor.systemGray6))
//                .cornerRadius(8)
//            
//            
//            
//            Button("Update Expenses") {
//                viewModel.updateTransactions(transaction)
//                viewModel.loadExpense(transaction)
//                presentationMode.wrappedValue.dismiss()
//            }
//            .foregroundColor(.white)
//            .frame(minWidth: 0, maxWidth: .infinity)
//            .padding()
//            .background(Color.pprl)
//            .cornerRadius(12)
//            
//            
//        }
//        .onAppear {
//            viewModel.loadExpense(transaction)
//        }
//        .alert(isPresented: $showingDeleteAlert) {
//                    Alert(
//                        title: Text("Are you sure you want to delete this expense?"),
//                        message: Text("This action cannot be undone."),
//                        primaryButton: .destructive(Text("Delete")) {
//                            viewModel.deleteTransaction(transaction)
//                            presentationMode.wrappedValue.dismiss()
//                        },
//                        secondaryButton: .cancel()
//                    )
//                }
//        .navigationBarItems(leading: Button(action: {
//            self.presentationMode.wrappedValue.dismiss()
//        }) {
//            Image(systemName: "chevron.left") // Customize your icon
//                .foregroundColor(.black11) // Customize the color
//        })
//        .navigationBarItems(trailing: Button(action: {
//            showingDeleteAlert = true
//        }) {
//            Image(systemName: "trash")
//        })
//        .navigationBarTitle("\(transaction.transactionName)", displayMode: .inline)
//        .foregroundColor(.black11)
//        
//        .navigationBarBackButtonHidden(true)
//    
//        
//        
//        .padding(.all)
//    
//        
//    }
//    
//    private func deleteExpense(at offsets: IndexSet) {
//            offsets.forEach { index in
//                viewModel.deleteTransaction(transaction)
//            }
//        }
//}
//#Preview{
//    EditTransaction(viewModel: TransactionViewModel(), expensesViewModel: ExpensesViewModel(cardID: "11"), transaction: TransactionEntry.init(id: "12", cardID: "11", userID: "11", transactionName: "ss", amount: 200.0, date: "12-2-24"))
//}
