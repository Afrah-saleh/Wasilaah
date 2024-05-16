//
//  CircleChartView.swift
//  Namaa
//
//  Created by sumaiya on 06/05/2567 BE.
//

import SwiftUI


struct PieChartView: View {
    var expenses: [Expenses]  // Assume Expense is the correct model name
    var strokeColors: [Color]  // Fixed color palette

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Pie chart visualization with dynamic color mapping based on expenses
                    StrokeChart(spendingPercentages: calculateSpendingPercentages(), colors: mapColorsToExpenses())
                    
                    VStack {
                        // Displaying total spent amount
                        let totalSpent = expenses.reduce(0) { $0 + $1.amount }
                        Text("\(totalSpent, specifier: "%.2f") \(expenses.first?.currency.rawValue ?? "Currency")")
                            .font(.headline)
                        Text("Total Spent out of the budget")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    // Assuming ExpensesSection is modified to use these expenses and colors
                    ExpensesSection(authViewModel: sessionStore(), expenses: expenses, strokeColors: strokeColors)
                }
            }
        }
    }

    func calculateSpendingPercentages() -> [CGFloat] {
        let total = expenses.reduce(0) { $0 + $1.amount }
        return expenses.map { CGFloat($0.amount / total) }
    }

    func mapColorsToExpenses() -> [Color] {
        return expenses.map { expense in
            if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
                return strokeColors[index % strokeColors.count]
            }
            return .clear  // Fallback color
        }
    }
}

