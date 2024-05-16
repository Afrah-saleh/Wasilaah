
//
//  AllExpensesView.swift
//  Namaa
//
//  Created by Afrah Saleh on 20/10/1445 AH.
//

import SwiftUI

struct AllExpensesView: View {
    @ObservedObject var expensesViewModel: ExpensesViewModel
    @Environment(\.presentationMode) var presentationMode

    var cardID: String
    @State private var showDeleteAlert = false
    @State private var expenseToDelete: Expenses?
    
    var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var body: some View {
        List {
            ForEach (expensesViewModel.sortedExpenses) { expense in
                NavigationLink(destination: DetailSingleExpenses(expenses: expense, circleColor: .pprl , transactionViewModel: TransactionViewModel(), expensesViewModel: expensesViewModel)) {
                    VStack(alignment: .leading) {
                        HStack{
                            Text(expense.name)
                            Spacer()
                            HStack{
                                Text("\(expense.amount, specifier: "%.2f")")
                                Text("\(expense.currency.rawValue)")
                                    .font(.custom(String(), size: 10))
                                    .foregroundColor(.gray)
                                    .padding(.top, 5)
                            }
                            .fixedSize()
                        }
                        Text("\(expense.dateCreated, formatter: itemFormatter)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }   .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Are you sure you want to delete this expense?"),
                message: Text("This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let expense = expenseToDelete {
                        expensesViewModel.deleteExpense(expense)
                    }
                },
                secondaryButton: .cancel {
                    expenseToDelete = nil
                }
            )
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                            Image(systemName: "chevron.left") // Customize your icon
                        .foregroundColor(.black11) // Customize the color
                    })
                    .navigationBarTitle("All Expenses", displayMode: .inline)
                    .foregroundColor(.black11)
 
    }
}

struct AllExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock ExpensesViewModel
        let mockExpensesViewModel = ExpensesViewModel(cardID: Card.sample.cardID)

        let sampleCardID = "12345"
        
        AllExpensesView(expensesViewModel: mockExpensesViewModel, cardID: sampleCardID)
    }
}
