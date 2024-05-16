
//
//  DetailSingleExpense.swift
//  Namaa
//
//  Created by sumaiya on 06/05/2567 BE.
//

import SwiftUI

struct DetailSingleExpenses: View {
    var expenses: Expenses
    var circleColor: Color
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var transactionViewModel: TransactionViewModel
    @ObservedObject var expensesViewModel: ExpensesViewModel
    // Computed property to find all matching transactions
    private var matchingTransactions: [TransactionEntry] {
           transactionViewModel.transactions.filter {
               $0.transactionName.lowercased() == expenses.name.lowercased() &&
               $0.cardID == expenses.cardID // Ensure that transaction has a cardID attribute and matches the expense's cardID
           }
       }
    
    var body: some View {
        NavigationView{
            VStack{
                VStack(alignment: .leading, spacing: 10) {
                    Spacer()
                    HStack(spacing: 170){
                        Text("Expenses Name")
                            .font(.title3)
                        NavigationLink(destination: EditExpenseView(expensesViewModel: expensesViewModel, expenses: expenses)) {
                            Image(systemName: "pencil.line")
                        }
                    }
                    //Text(expenses.name)
                    Text(NSLocalizedString(expenses.name, comment: ""))

                        .foregroundColor(.gray)
                    Text("Expenses Date")
                    Text(expenses.dateCreated.formatted())
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.pprl, lineWidth: 2)
                            .fill(Color.lightpprl))
                        .foregroundColor(.pprl)
                        .padding(.leading,10)
                    Text("Amount")
                    Text("\(expenses.amount, specifier: "%.2f")")
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.pprl, lineWidth: 2)
                            .fill(Color.lightpprl))
                        .foregroundColor(.pprl)
                        .padding(.leading,10)
                    
                    Text("Currency")
                    //Text(expenses.currency.rawValue)
                    Text(NSLocalizedString(expenses.currency.rawValue, comment: ""))
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.pprl, lineWidth: 2)
                            .fill(Color.lightpprl))
                        .foregroundColor(.pprl)
                        .padding(.leading,10)
                    
                    Text("Payment Date")
                  //  Text("\(String(describing: expenses.paymentDate?.rawValue))")
                    Text(NSLocalizedString(expenses.paymentDate?.rawValue ?? "SAR", comment: ""))                        .padding(10) // Add padding around the text
                        .background(RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.pprl, lineWidth: 2) // Apply a red border with a line width of 2
                            .fill(Color.lightpprl)) // Fill color of the RoundedRectangle
                        .foregroundColor(.pprl)
                    
                    if let range = expenses.range {
                        Text("Range")
                        Text("\(range.from, specifier: "%.2f") to \(range.to, specifier: "%.2f")")
                    }
                }
                .padding(.all)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray,lineWidth: 1.0)
                )
                
                VStack(alignment:.leading){
                    Text("Transaction")
                        .font(.title)
                        .padding(.leading,20)
                    
                    Spacer()
                    ScrollView{
                        
                        //Display the matching transaction name
                        ForEach(matchingTransactions, id: \.id) { transaction in
                            
                            HStack(spacing:5){
                                Circle()
                                    .fill(circleColor)
                                    .frame(width: 25, height: 25)
                                    .padding()
                                VStack(alignment: .leading) {
                                    
                                    HStack(){
                                        Text("\(transaction.transactionName)")
                                            .fixedSize() // This will prevent the text from being compressed or stretched
                                        Spacer()
                                        HStack{
                                            Text("\(transaction.amount, specifier: "%.2f")") // Ensure TransactionEntry has an amount field
                                                .fixedSize() // This will prevent the text from being compressed or stretched
                                            Text("SAR")
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .font(.headline)
                                    Text("\(transaction.date)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    // Add more details as needed
                                }
                                
                                
                                NavigationLink(destination: TransactionDetailView(viewModel: transactionViewModel, transaction: transaction, expensesViewModel: expensesViewModel)) {
                                    Image(systemName: "chevron.forward")
                                        .padding(.trailing, 12)
                                }
                                
                                
                                
                            }
                            .frame(maxWidth: .infinity ,maxHeight: .infinity)
                            //                                .frame(width: 320)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            
                        }
                    }
                    .padding(.all)
                }
                
            }
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left") // Customize your icon
                    .foregroundColor(.black11) // Customize the color
            })
            .navigationBarTitle("\(expenses.name)", displayMode: .inline)
            .foregroundColor(.black11)
        }
        .navigationBarBackButtonHidden(true)

        
    }
}

#Preview {
    DetailSingleExpenses(expenses: Expenses(id: UUID(uuidString: "1")!, cardID: "12", name: "123", currency: .SAR, amount: 200.0, dateCreated: Date()), circleColor: .yellow, transactionViewModel: TransactionViewModel(), expensesViewModel: ExpensesViewModel(cardID: "12"))
}
