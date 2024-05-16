//
//  SummarySection.swift
//  Namaa
//
//  Created by sumaiya on 06/05/2567 BE.
//

import SwiftUI
struct SummarySection: View {
    @ObservedObject var viewModel: TViewModel
    var cardID: Card?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Summary")
                .font(.title2)
                .fontWeight(.bold)
            HStack {
                if let cardID = cardID, viewModel.transactions.isEmpty {
                    // Default view for no data
                    HStack{
                        SingleSummary(title: "Increased", expensesName: "", chartTitle: "Increase By", chartPercentage: "0.00%", chartArrow: "", chartColor: Color.gray, percentageColor: Color.gray, prograssStrokColor: Color.gray, textPadding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0), isActive: false)
                        
                        SingleSummary(title: "Less than usual", expensesName: "", chartTitle: "Decrease By", chartPercentage: "0.00%", chartArrow: "", chartColor: Color.gray, percentageColor: Color.gray, prograssStrokColor: Color.gray, textPadding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0), isActive: false)
                    }
                }
                 else {
                    summaryContent
                }
            }
        }
        .onAppear {
            fetchTransactionsIfNeeded()
        }
    }

    private var summaryContent: some View {
        Group {
            if let increase = viewModel.transactionWithLargestPercentageIncrease() {
                SingleSummary(title: "Increased", expensesName: increase.transaction.transactionName, chartTitle: "Increase By", chartPercentage: String(format: "%.2f", increase.percentage), chartArrow: "arrow.up.right", chartColor: Color.customBlue, percentageColor: Color.customBlue, prograssStrokColor: Color.customBlue, textPadding: EdgeInsets(top: 0, leading: -70, bottom: 0, trailing: 0), isActive: true)
            }
            if let decrease = viewModel.transactionWithLargestPercentageDecrease() {
                SingleSummary(title: "Less than usual", expensesName: decrease.transaction.transactionName, chartTitle: "Decrease By", chartPercentage: String(format: "%.2f", decrease.percentage), chartArrow: "arrow.down.right", chartColor: Color.strokgreen, percentageColor: Color.strokgreen, prograssStrokColor: Color.strokgreen, textPadding: EdgeInsets(top: 0, leading: -50, bottom: 0, trailing: 0), isActive: true)
            }
        }
    }

    private func fetchTransactionsIfNeeded() {
        if let cardID = cardID {
            viewModel.fetchAndDisplayMatchingTransactions(cardID: cardID.cardID)
        }
    }
}
#Preview {
    SummarySection(viewModel: TViewModel(), cardID: Card.sample)
}

