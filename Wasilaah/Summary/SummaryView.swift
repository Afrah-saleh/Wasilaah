//
//  SummaryView2.swift
//  Namaa
//
//  Created by sumaiya on 12/05/2567 BE.
//




import SwiftUI
import Charts

struct SummaryView: View {
    @EnvironmentObject var authViewModel: sessionStore
    @StateObject var expensesViewModel = ExpensesViewModel(cardID: "yourCardID")
    @StateObject var cardViewModel = CardViewModel()

    var body: some View {
        ScrollView {
            VStack {
                Text("Quick view of all expenses")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 18)
                    .padding(.bottom, 18)

                VStack(alignment: .leading) {
                    Text("Expenses This Month vs. Last Month")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.leading, -20)
                    CompareExpenses(expensesViewModel: expensesViewModel, cardViewModel: cardViewModel)
                }
                .frame(width: 400, height: 400)

                Divider()

                VStack(alignment: .leading) {
                    Text("Fixed Expenses")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.leading, 15)
                    SingleChart(expensesViewModel: expensesViewModel, cardViewModel: cardViewModel)
                }
                .frame(width: 400, height: 400)

                Divider()

                VStack(alignment: .leading) {
                    Text("Changeable Expenses")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.leading, 15)
                    ChangeableExpenses(expensesViewModel: expensesViewModel, cardViewModel: cardViewModel)
                }
                .frame(width: 400, height: 400)
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            fetchInitialData()
        }
    }

    private func fetchInitialData() {
        if let userId = authViewModel.session?.uid {
            cardViewModel.fetchCards(userID: userId)
            expensesViewModel.fetchExpenses(forCardID: "") // Make sure this method exists and is suitable
        }
    }
}

//    struct SummaryView: View {
//        @EnvironmentObject var authViewModel: sessionStore
//        @StateObject var expensesViewModel = ExpensesViewModel(cardID: "yourCardID")
//        @StateObject var cardViewModel = CardViewModel()
//
//        var body: some View {
//            ScrollView {
//                VStack {
//                    Text("Quick view of all expenses")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .multilineTextAlignment(.center)
//                        .padding(.top, 18)
//                        .padding(.bottom, 18)
//
//                    VStack {
//                        Text("Expenses This Month vs. Last Month")
//                            .font(.title3)
//                            .fontWeight(.medium)
//                            .multilineTextAlignment(.leading)
//
//                        CompareExpenses(expensesViewModel: expensesViewModel, cardViewModel: cardViewModel)
//                    }
//                    .frame(width: 400, height: 400)
//
//                    Divider()
//
//                    VStack {
//                        Text("Fixed Expenses")
//                            .font(.title3)
//                            .fontWeight(.medium)
//
//                        SingleChart(expensesViewModel: expensesViewModel, cardViewModel: cardViewModel)
//                    }
//                    .frame(width: 400, height: 400)
//
//                    Divider()
//
//                    VStack {
//                        Text("Changeable Expenses")
//                            .font(.title3)
//                            .fontWeight(.medium)
//
//                        ChangeableExpenses(expensesViewModel: expensesViewModel, cardViewModel: cardViewModel)
//                    }
//                    .frame(width: 400, height: 400)
//                }
//                .padding(.horizontal, 20)
//            }
//            .onAppear {
//                fetchInitialData()
//            }
//        }
//
//        private func fetchInitialData() {
//            if let userId = authViewModel.session?.uid {
//                cardViewModel.fetchCards(userID: userId)
//                expensesViewModel.fetchExpenses(forCardID: "") // Make sure this method exists and is suitable
//            }
//        }
//    }

#Preview {
    SummaryView()
}
