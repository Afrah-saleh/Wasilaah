//
//
//  CompareExpenses.swift
//  Namaa
//
//  Created by sumaiya on 07/05/2567 BE.
//


import SwiftUI
import Charts

import FirebaseFirestore




struct CircleShapeChart: View {
    let color: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 25, height: 25)
            .padding()
    }
}

struct CircleComparation: View {
    let totalAmountThisMonth: Int
    let totalAmountLastMonth: Int

    var body: some View {
        HStack(alignment: .center) {
            HStack {
                CircleShapeChart(color: .customBlue)
                VStack(alignment: .leading) {
                    Text("\(totalAmountThisMonth)")
                    Text("This Month")
                        .font(.caption)
                        .foregroundColor(Color("TextGray"))
                }
            }
            HStack {
                CircleShapeChart(color: .strokYallow)
                VStack(alignment: .leading) {
                    Text("\(totalAmountLastMonth)")
                    Text("Last Month")
                        .foregroundColor(Color("TextGray"))
                        .font(.caption)
                }
            }
        }
        .frame(width: 300, height: 60)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.stork, lineWidth: 1)
        )
    }
}


struct CompareExpensesList: Identifiable {
    let id = UUID()
    let expensesName: String
    var amount: Int
    
    init(expensesName: String, amount: Int) {
        self.expensesName = expensesName
        self.amount = amount
    }
}

struct CompareExpenses: View {
    @State private var expensesThisMonth: [CompareExpensesList] = [
        CompareExpensesList(expensesName: "Week 1", amount: 0),
        CompareExpensesList(expensesName: "Week 2", amount: 0),
        CompareExpensesList(expensesName: "Week 3", amount: 0),
        CompareExpensesList(expensesName: "Week 4", amount: 0),
    ]
    @State private var expensesLastMonth: [CompareExpensesList] = [
        CompareExpensesList(expensesName: "Week 1", amount: 0),
        CompareExpensesList(expensesName: "Week 2", amount: 0),
        CompareExpensesList(expensesName: "Week 3", amount: 0),
        CompareExpensesList(expensesName: "Week 4", amount: 0),
    ]
    
    var expensesData: [(period: String, data: [CompareExpensesList])] {
        [(period: "This Month", data: expensesThisMonth),
         (period: "Last Month", data: expensesLastMonth)]
    }
    
   
     
   

    @State private var selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    @State private var currentYear = Calendar.current.component(.year, from: Date())
    @State private var selectedPreviousMonthIndex = Calendar.current.component(.month, from: Date()) - 2
    @State private var previousYear = Calendar.current.component(.year, from: Date())
    
    @State private var totalAmountThisMonth: Int = 0
    @State private var totalAmountLastMonth: Int = 0
    @ObservedObject var chartviewModel = ChartViewViewModel(cardID: "")
    @EnvironmentObject var authViewModel: sessionStore
    @ObservedObject var expensesViewModel: ExpensesViewModel
    @ObservedObject var cardViewModel = CardViewModel()
    @StateObject var viewModel = TViewModel()
    @State private var expenses: [Expenses] = []
    @State private var selectedCard: Card?
    @State private var currentCard: Card? = nil
    @State private var weekToFetch = "Week 2"
   
        
    var filteredExpenses: [Expenses] {
        guard let selectedCard = selectedCard else { return [] }
        return expenses.filter { $0.cardID == selectedCard.cardID }
    }
    
    var selectedMonthText: String {
        let currentMonth = selectedMonthIndex + 1
        let currentYear = self.currentYear
        
        let lastDayOfMonth = getLastDayOfMonth(month: currentMonth, year: currentYear)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let lastDayString = dateFormatter.string(from: lastDayOfMonth)
        
        return " \(lastDayString)"
    }

    var previousMonthText: String {
        let previousMonth = selectedPreviousMonthIndex + 1
        let previousYear = self.previousYear
        
        let firstDayOfMonth = getFirstDayOfMonth(month: previousMonth, year: previousYear)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let firstDayString = dateFormatter.string(from: firstDayOfMonth)
        
        return firstDayString
    }

    func getFirstDayOfMonth(month: Int, year: Int) -> Date {
        let startDateComponents = DateComponents(year: year, month: month, day: 1)
        guard let firstDayOfMonth = Calendar.current.date(from: startDateComponents) else { return Date() }
        return firstDayOfMonth
    }

    func getLastDayOfMonth(month: Int, year: Int) -> Date {
        let startDateComponents = DateComponents(year: year, month: month, day: 1)
        guard let startDate = Calendar.current.date(from: startDateComponents) else { return Date() }
        
        let lastDayOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!
        return lastDayOfMonth
    }

    var body: some View {
        VStack {
            // Display the month text
            HStack {
            

                Text("\(previousMonthText) - \(selectedMonthText)")
                    .fontWeight(.regular)
                    .foregroundColor(Color("TextGray"))
                    .font(.system(size: 14))
                
                
            }
            .padding(.leading,-180)
            .padding(.bottom,30)
            
            
            Chart(expensesData, id: \.period) { dataEx in
                ForEach(dataEx.data) {
                    BarMark(x: .value("Expenses Name", $0.expensesName),
                            y: .value("Amount", $0.amount),
                            width: .fixed(20))
                    .foregroundStyle(by: .value("Expenses", dataEx.period))
                    .position(by: .value("Expenses", dataEx.period),
                              axis: .horizontal,
                              span: .ratio(1))
                    .cornerRadius(7)
                }
            }
            .frame(width: 300, height: 200)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                            if intValue < 1000 {
                                Text("\(intValue)").font(.body)
                            } else {
                                Text("\(intValue / 1000)\(intValue == 0 ? "" : "k")").font(.body)
                            }
                        }
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .chartForegroundStyleScale([
                "This Month": Color(.customBlue),
                "Last Month": Color(.strokYallow)
            ])
            
            CircleComparation(totalAmountThisMonth: totalAmountThisMonth, totalAmountLastMonth: totalAmountLastMonth)
                .chartXAxis {
                    AxisMarks(position: .bottom)
                }
        }
        .padding()
        .onAppear {
            fetchData()
           
        }
        .onChange(of: selectedMonthIndex) { _ in
            fetchData()
            
          
        }
    }
    
    private func fetchData() {
        // Reset total amounts
        totalAmountThisMonth = 0
        totalAmountLastMonth = 0
        
        currentYear = Calendar.current.component(.year, from: Date())
        previousYear = Calendar.current.component(.year, from: Calendar.current.date(byAdding: .month, value: -1, to: Date())!)
        
        guard let userId = authViewModel.session?.uid else { return }
        
        cardViewModel.fetchCards(userID: userId)
        
        if cardViewModel.cards.isEmpty {
            print("No cards found with the current user ID: \(userId)")
        } else {
            let cardIDs = cardViewModel.cards.map { $0.cardID }
            
            // Fetch expenses for the current month
            for weekToFetch in ["Week 1", "Week 2", "Week 3", "Week 4"] {
                chartviewModel.fetchAllExpenses(forCardIDs: cardIDs, userMonth: selectedMonthIndex + 1, week: weekToFetch) { fetchedExpenses in
                    if let totalAmountForWeek = fetchedExpenses {
                        if let index = expensesThisMonth.firstIndex(where: { $0.expensesName == weekToFetch }) {
                            expensesThisMonth[index].amount = Int(totalAmountForWeek)
                        }
                        
                        // Update the total amount for the current month
                        totalAmountThisMonth += Int(totalAmountForWeek)
                    } else {
                        print("No expenses fetched for \(weekToFetch)")
                    }
                    
                    // Check if all weeks are processed for the current month and print the total amount
                    if weekToFetch == "Week 4" {
                        print("Total amount for current month:⛅️ \(totalAmountThisMonth)")
                    }
                }
            }
            
            // Fetch expenses for the last month
            let lastMonthStartDate = Calendar.current.date(byAdding: DateComponents(month: -1), to: Date())!
            let lastMonthEndDate = Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())!
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            for weekToFetch in ["Week 1", "Week 2", "Week 3", "Week 4"] {
                let lastMonthStartDateString = formatter.string(from: lastMonthStartDate)
                let lastMonthEndDateString = formatter.string(from: lastMonthEndDate)
                
                chartviewModel.fetchAllExpenses(forCardIDs: cardIDs, userMonth: Calendar.current.component(.month, from: lastMonthStartDate), week: weekToFetch) { fetchedExpenses in
                    if let totalAmountForWeek = fetchedExpenses {
                        if let index = expensesLastMonth.firstIndex(where: { $0.expensesName == weekToFetch }) {
                            expensesLastMonth[index].amount = Int(totalAmountForWeek)
                        }
                        
                        // Update the total amount for the last month
                        totalAmountLastMonth += Int(totalAmountForWeek)
                    } else {
                        print("No expenses fetched for \(weekToFetch)")
                    }
                    
                    // Check if all weeks are processed for the last month and print the total amount
                    if weekToFetch == "Week 4" {
                        print("Total amount for last month:🌕 \(totalAmountLastMonth)")
                    }
                }
            }
        }
    }


    }

