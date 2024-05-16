//
//  ExpensesForm.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 28/10/1445 AH.
//

import SwiftUI


struct ExpenseForm: View {
    @ObservedObject var viewModel: ExpenseFormViewModel
    var deleteAction: () -> Void
    var cardID: String
    var body: some View {
        
        VStack{
            //name
            HStack{
                Text("Expenses Name")
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button("Save") {
                         viewModel.saveExpense()
    //                $viewModel.saveAllExpenses()
                     }
                .foregroundColor(.pprl)
            }
            TextField("Expenses Name", text: $viewModel.name)
                .padding()
                .frame(height: 44)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
            //type
            Text("Expenses Type")
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
            SegmentedControlButton(selection: $viewModel.selectedType, options: ExpenseType.allCases)

            
            //ampunt
            Text("Amount")
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Amount", text: $viewModel.amount)
                .keyboardType(.decimalPad)
                .padding()
                .frame(height: 44)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
            
            
            //currency
            Text("Select the currency")
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
            SegmentedControlButton(selection: $viewModel.selectedCurrency, options: Currency.allCases)
            
            
            //date
            Text("Select Payment period")
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack (alignment: .center){
                SegmentedControlButton(selection: $viewModel.selectedPaymentDate, options: PaymentDate.allCases)
                
                
            }
            // Day of Purchase for monthly or yearly payments
            if viewModel.selectedPaymentDate == .monthly || viewModel.selectedPaymentDate == .yearly {
                Text("Add day of payment")
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Day of Purchase (1-30)", text: $viewModel.dayOfPurchase)
                    .keyboardType(.numberPad)
                    .padding()
                    .frame(height: 44)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .border(viewModel.dayOfPurchaseIsValid ? Color.clear : Color.red, width: 2)
                    .onChange(of: viewModel.dayOfPurchase) { _ in
                        viewModel.validateDayOfPurchase()
                    }
                
                if !viewModel.dayOfPurchaseIsValid {
                    Text("Day should be between 1 to 30")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            
            // Day of Purchase when payment is weekly
            if viewModel.selectedPaymentDate == .weekly {
                HStack{
                    Text("Day of Purchase")
                        .font(.callout)
                    
                    Text("(Optional)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }.frame(maxWidth: .infinity, alignment: .leading)
                SegmentedControlButton(
                    selection: $viewModel.dayOfPurchase,
                    options: ["Sunday","Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"])
            }
            
            //codition to display range
            if viewModel.selectedType == .changeable {
                Section(header: Text("Range")) {
                    
                    HStack{
                        TextField("From", text: $viewModel.rangeFrom)
                            .keyboardType(.decimalPad)
                            .padding()
                            .frame(height: 44)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .border(viewModel.isRangeValid ? Color.clear : Color.clear, width: 2)
                        
                        TextField("To", text: $viewModel.rangeTo)
                            .keyboardType(.decimalPad)
                            .padding()
                            .frame(height: 44)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .border(viewModel.isRangeValid ? Color.clear : Color.red, width: 1)
                    }
                    if !viewModel.isRangeValid {
                        Text("Enter the bigger amount here")
                            .foregroundColor(.red)
                            .font(.caption2)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                    }
                }
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray, lineWidth: 1)
                        .opacity(0.5)
                )
                .overlay(
                    HStack {
                        Spacer()
                        Button(action: deleteAction) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.top, -8)
                        }
                    },
                    alignment: .topTrailing
                )

            }
        }

 
