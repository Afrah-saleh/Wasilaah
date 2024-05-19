//
//  StatusSection.swift
//  Namaa
//
//  Created by sumaiya on 06/05/2567 BE.
//

import SwiftUI


struct StatusButton:View{
    let buttonText: String
    var selectedButtonIndex: Int? = 0
    let buttonIndex: Int
    let onButtonSelected: (Int) -> Void
     let selectedColor: Color
    let unselectedColor: Color
    
    var body: some View {
        Button(action: {
            self.onButtonSelected(self.buttonIndex)
        }) {
           // Text(buttonText)
            Text(NSLocalizedString(buttonText, comment: ""))
                .font(.system(size: 12))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: true)
                .foregroundColor(selectedButtonIndex == buttonIndex ? .white : .black)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(selectedButtonIndex == buttonIndex ? selectedColor : unselectedColor)
                .cornerRadius(12)
        }
    
    }
}

struct StatusSection: View {
    @State var selectedButtonIndex: Int? = 0
    let selectedColors: [Color] = [.customRed, .customRed, .customBlue, .strokYallow ] // Adjust colors as needed
    let unselectedColor: Color = .buttonGray
        @ObservedObject var viewModel: TViewModel // Observing the ViewModel

    var unpaidExpenses: [SingleExpensesStatus] {
        // First, filter the expenses to get only the actionable ones
        let actionableExpenses = viewModel.getActionableExpenses(from: viewModel.expenses)

        // Now, map each filtered expense to a SingleExpensesStatus object
        let unpaidExpenses = actionableExpenses.map { expense in
            // Calculate days until the next payment
//            let daysUntilNextPayment = viewModel.daysUntilNextPayment(for: expense)
            let daysUntilNextPayment = viewModel.daysUntilNextPayment(for: expense)

            return SingleExpensesStatus(
                title: expense.name,
                date: expense.paymentDate?.rawValue ?? "Not set",
                amount: expense.amount,
                currency: expense.currency.rawValue,
                circleColor: .customRed,
                viewIcon: nil,
                status: nil,
                diff: 0.00
            )
        }

        // Debug print to check the mapped results
        print("Filtered Transactions: \(unpaidExpenses)")
        
        return unpaidExpenses
    }
    
    var costChangeExpenses: [SingleExpensesStatus] {
        let filtered = viewModel.transactions.compactMap { transaction in
            if let transactionName = viewModel.checkAmountChangeForNewTransaction(transaction: transaction) {
                let differenceInfo = viewModel.differenceAndPercentage(for: transaction)
                let statusString = differenceInfo.map { info in
                    " \(info.diff) SAR"
                }
                let viewIcon = differenceInfo.map { info -> String in
                           info.diff > 0 ? "arrow.up.right" : "arrow.down.right"
                       }
                let diff = differenceInfo?.diff ?? 0
                return SingleExpensesStatus(
                    title: transactionName,
                    date: transaction.date,
                    amount: transaction.amount,
                    currency: "SAR",
                    circleColor: .customRed,
                    viewIcon: viewIcon,
                    status: statusString,
                    diff: diff
                )
            }
            return nil
        }
        print("Filtered Transactions: (filtered)")
        return filtered
    }
    
    var highestExpenses: [SingleExpensesStatus] {
        // Directly find the transaction with the highest amount.
        if let highestTransaction = viewModel.transactions.max(by: { $0.amount < $1.amount }) {
            let highestExpense = SingleExpensesStatus(
                title: highestTransaction.transactionName,
                date: highestTransaction.date,
                amount: highestTransaction.amount,
                currency: "SAR",
                circleColor: .customBlue,
                viewIcon: nil,
                status: nil,
                diff: 0
            )
            return [highestExpense]
        } else {
            return []
        }
    }
    var dueExpenses: [SingleExpensesStatus] {
           let sortedExpenses = viewModel.getSortedExpenses()
           print("Sorted Expenses: \(sortedExpenses)")
           
           let mappedExpenses = sortedExpenses.map { expense -> SingleExpensesStatus in
               return SingleExpensesStatus(
                   title: expense.name,
                   date: expense.paymentDate?.rawValue ?? "Not set",
                   amount: expense.amount,
                   currency: expense.currency.rawValue,
                   circleColor: .strokYallow,
                   viewIcon: "arrow.up.arrow.down",
                   status: "Days until next payment: \(viewModel.daysUntilNextPayments(for: expense)) days",
                   diff: 0.00
               )
           }
           
           print("Filtered Transactions: \(mappedExpenses)")
           return mappedExpenses
       }

    
    var body: some View {
        VStack(alignment: .leading){
            Text("You Have") .font(.title2)
                .fontWeight(.bold)
                .padding(.leading,20)
            HStack(spacing: 3) {
                StatusButton(buttonText: "Unpaid", selectedButtonIndex: selectedButtonIndex, buttonIndex: 0, onButtonSelected: { index in
                    self.selectedButtonIndex = index
                }, selectedColor: selectedColors[0], unselectedColor: unselectedColor)
                .padding(.leading, 20)
                
                StatusButton(buttonText: "Cost Change", selectedButtonIndex: selectedButtonIndex, buttonIndex: 1, onButtonSelected: {
                                  self.selectedButtonIndex = $0
                              }, selectedColor: selectedColors[1], unselectedColor: unselectedColor)
                
                StatusButton(buttonText: "Due", selectedButtonIndex: selectedButtonIndex, buttonIndex: 2, onButtonSelected: { index in
                    self.selectedButtonIndex = index
                }, selectedColor: selectedColors[3], unselectedColor: unselectedColor)
                
                StatusButton(buttonText: "Highest Price", selectedButtonIndex: selectedButtonIndex, buttonIndex: 3, onButtonSelected: { index in
                    self.selectedButtonIndex = index
                }, selectedColor: selectedColors[2], unselectedColor: unselectedColor)
                .padding(.trailing, 20)
            }
            // Show the list of SingleExpensesStatus based on the selected button index
            switch selectedButtonIndex {
            case 0:
                ForEach(unpaidExpenses.indices, id: \.self) { index in
                    unpaidExpenses[index].padding(.horizontal, 20).padding(.top)
                }
            case 1:
                ForEach(costChangeExpenses.indices, id: \.self) { index in
                    costChangeExpenses[index]
                        .padding(.horizontal, 20)
                        .padding(.top)
                }
            case 2:
                ForEach(dueExpenses.indices, id: \.self) { index in
                    dueExpenses[index]
                        .padding(.horizontal, 20)
                        .padding(.top)
                }
            default:
                ForEach(highestExpenses.indices, id: \.self) { index in
                    highestExpenses[index].padding(.horizontal, 20).padding(.top)
                }
            }
        }
        .onAppear {
            print("StatusSection is appearing with selectedButtonIndex: \(selectedButtonIndex ?? 0)")
                print("Number of transactions: \(viewModel.transactions.count)")
                
            }
    }

}
#Preview {
    StatusSection(viewModel: TViewModel())
}
