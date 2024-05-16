//
//  Edit_Expenses.swift
//  Namaa
//
//  Created by Afrah Saleh on 06/11/1445 AH.
//

import SwiftUI

struct EditExpenseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expensesViewModel: ExpensesViewModel
    var expenses: Expenses
    @State private var showingDeleteAlert = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
                Text("Expenses Name")
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Name", text: $expensesViewModel.name)
                .padding()
                .frame(height: 44)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                
                Text("Expenses Amount")
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Amount", text: $expensesViewModel.amount)
                .padding()
                .frame(height: 44)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                
                Text("Expenses Type")
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            SegmentedControlButton(selection: $expensesViewModel.selectedType, options: ExpenseType.allCases)
                
            Text("Expenses Currency")
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
            SegmentedControlButton(selection: $expensesViewModel.selectedCurrency, options: Currency.allCases)

            Text("Expenses Payment period")
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
            SegmentedControlButton(selection: $expensesViewModel.selectedPaymentDate, options: PaymentDate.allCases)

            
            
            // Day of Purchase for monthly or yearly payments
            if expensesViewModel.selectedPaymentDate == .monthly || expensesViewModel.selectedPaymentDate == .yearly {
                Text("Add day of payment")
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Day of Purchase (1-30)", text: $expensesViewModel.dayOfPurchase)
                    .keyboardType(.numberPad)
                    .padding()
                    .frame(height: 44)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .border(expensesViewModel.dayOfPurchaseIsValid ? Color.clear : Color.red, width: 2)
                    .onChange(of: expensesViewModel.dayOfPurchase) { _ in
                        expensesViewModel.validateDayOfPurchase()
                    }
                
                if !expensesViewModel.dayOfPurchaseIsValid {
                    Text("Day should be between 1 to 30")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
                // Day of Purchase when payment is weekly
                if expensesViewModel.selectedPaymentDate == .weekly {
                    HStack{
                        Text("Day of Purchase")
                            .font(.callout)
                        
                        Text("(Optional)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    SegmentedControlButton(
                        selection: $expensesViewModel.dayOfPurchase,
                        options: ["Sunday","Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"])
                }
                
                //codition to display range
                if expensesViewModel.selectedType == .changeable {
                    Section(header: Text("Range")) {
                        
                        HStack{
                            TextField("From", text: $expensesViewModel.rangeFrom)
                                .keyboardType(.decimalPad)
                                .padding()
                                .frame(height: 44)
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                                .border(expensesViewModel.isRangeValid ? Color.clear : Color.clear, width: 2)
                            
                            TextField("To", text: $expensesViewModel.rangeTo)
                                .keyboardType(.decimalPad)
                                .padding()
                                .frame(height: 44)
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                                .border(expensesViewModel.isRangeValid ? Color.clear : Color.red, width: 1)
                        }
                        if !expensesViewModel.isRangeValid {
                            Text("Enter the bigger amount here")
                                .foregroundColor(.red)
                                .font(.caption2)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                        }
                    }
                }
            Button("Save") {
                expensesViewModel.updateExpense(expenses)
                presentationMode.wrappedValue.dismiss()
                
            }
            .foregroundColor(.white)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(Color.pprl)
            .cornerRadius(12)
            
        }
        .padding(.all)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 1)
                .opacity(0.5)
        )
        .alert(isPresented: $showingDeleteAlert) {
                    Alert(
                        title: Text("Are you sure you want to delete this expense?"),
                        message: Text("This action cannot be undone."),
                        primaryButton: .destructive(Text("Delete")) {
                            expensesViewModel.deleteExpense(expenses)
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
        
        
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                            Image(systemName: "chevron.left") // Customize your icon
                        .foregroundColor(.black11) // Customize the color
                    })
        
        
        
        .navigationBarTitle("Edit Expenses" , displayMode: .inline)
        
        
        .navigationBarItems(trailing: Button(action: {
            showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
        
        
        
        .onAppear {
            expensesViewModel.loadExpense(expenses)
        } .padding(.all)
    }
    
    private func deleteExpense(at offsets: IndexSet) {
            offsets.forEach { index in
                let expense = expensesViewModel.sortedExpenses[index]
                expensesViewModel.deleteExpense(expense)
            }
        }
}

#Preview {
    EditExpenseView(expensesViewModel: ExpensesViewModel(cardID: "12"), expenses: Expenses(id: UUID(uuidString: "1")!, cardID: "12", name: "123", currency: .SAR, amount: 200.0, dateCreated: Date()))
}


