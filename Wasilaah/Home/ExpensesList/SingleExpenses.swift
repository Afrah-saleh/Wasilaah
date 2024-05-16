
//
//  SingleExpenses.swift
//  Namaa
//
//  Created by sumaiya on 06/05/2567 BE.
//

import SwiftUI

struct SingleExpenses: View {
    var expense: Expenses
    var circleColor: Color
    var viewIcon: String?
    
    var body: some View {
        HStack {
            Circle()
                .fill(circleColor)
                .frame(width: 25, height: 25)
                .padding()

            VStack(alignment: .leading) {
               // Text(expense.name)
                Text(NSLocalizedString(expense.name, comment: ""))
                Text(expense.dateCreated, formatter: itemFormatter)
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
            Spacer()
            Text("\(expense.amount, specifier: "%.2f")")
            //Text(expense.currency.rawValue)
            Text(NSLocalizedString(expense.currency.rawValue, comment: ""))
                .font(.footnote)
                .foregroundColor(Color.gray)
                .padding(.trailing, 9)
            
            if let icon = viewIcon {
                NavigationLink(destination: DetailSingleExpenses(expenses: expense, circleColor: circleColor, transactionViewModel: TransactionViewModel(), expensesViewModel: ExpensesViewModel(cardID: expense.cardID))) {
                    Image(systemName: icon)
                        .padding(.trailing, 12)
                }
            }
            
        }
        .frame(width: 360, height: 55)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray, lineWidth: 1)
                .opacity(0.3)
        )
        .padding(.bottom, 3) // For the list spacing
    }

    private var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
}

#Preview {
    SingleExpenses(expense: Expenses(id: UUID(), cardID: "123", name: "Coffee", type: .other, currency: .dollar, paymentDate: .monthly, dayOfPurchase: 23, amount: 3.50, range: nil, dateCreated: Date()), circleColor: .blue, viewIcon: "arrow.right")
}
