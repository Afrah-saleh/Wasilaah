
//
//  SingleChartFixed.swift
//  Namaa
//
//  Created by sumaiya on 06/05/2567 BE.
//
import SwiftUI
import Charts
import Firebase
import FirebaseFirestore


struct DropDownMenuFixed: View {
    @Binding var selectedOption: Int
    
    var body: some View {
        let months = Calendar.current.shortMonthSymbols
        
        VStack {
            Picker("options", selection: $selectedOption) {
                ForEach(0..<months.count, id: \.self) { index in
                    Text(months[index])
                        .tag(index)
                        .font(.system(size: 10))
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(height: 25)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1).cornerRadius(16))
            .padding(.horizontal)
        }
        .frame(width: 140)
    }
}


struct OptionViewFixed: View {
    @Binding var expenses: [Expenses]
    var userId: String?
    var cardViewModel: CardViewModel
    var chartviewModel: ChartViewViewModel
    
    @Binding var selectedMonthIndex: Int
    @Binding var currentYear: Int
    @EnvironmentObject var authViewModel: sessionStore

    let months = Calendar.current.shortMonthSymbols
    
    var selectedMonthText: String {
        let currentMonth = selectedMonthIndex + 1
        let currentYear = self.currentYear
        
        // Get the date components for the current month
        let currentDateComponents = DateComponents(year: currentYear, month: currentMonth)
        guard let currentDate = Calendar.current.date(from: currentDateComponents) else { return "" }
        
        // Get the first day of the current month
        let firstDayOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))!
        
        // Calculate the last day of the current month
        let lastDayOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfMonth)!
        
        // Get the date components for the previous month
        let previousDateComponents = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)
        guard let previousDate = previousDateComponents else { return "" }
        
        // Format the dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let previousDateString = dateFormatter.string(from: previousDate)
        let currentDateString = dateFormatter.string(from: lastDayOfMonth)
        
        return "\(previousDateString) - \(currentDateString)"
    }

    
    var body: some View {
        HStack {
            Text(" \(selectedMonthText)").fontWeight(.regular)
                .foregroundColor(Color("TextGray"))
                .font(.system(size: 14))
                   
            Spacer()
            DropDownMenuFixed(selectedOption: $selectedMonthIndex)
        }
        .padding()
        .onAppear {
            fetchExpenses()
        }
        .onChange(of: selectedMonthIndex) { newValue in
            currentYear = Calendar.current.component(.year, from: Date())
            print("Selected month index: \(newValue)")
            print("Current Year:", currentYear)
            fetchExpenses()
        }
    }
    
    
    private func fetchExpenses() {
        guard let userId = userId else { return }
        
        cardViewModel.fetchCards(userID: userId)
        print("current user id is👹 :\(userId)")

        if cardViewModel.cards.isEmpty {
            print("No cards found with the current user ID: \(userId)")
        } else {
            let cardIDs = cardViewModel.cards.map { $0.cardID }
            chartviewModel.fetchFixedExpenses(forCardIDs: cardIDs, userMonth: selectedMonthIndex + 1, expenseType: ChartViewViewModel.ExpenseType.fixed) { fetchedExpenses in
                if fetchedExpenses.isEmpty {
                    let defaultExpense = Expenses(id: UUID(), cardID: "", name: "Expenses", currency: .SAR, amount: 0, dateCreated: Date())
                    self.expenses = [defaultExpense]
                } else {
                    self.expenses = fetchedExpenses
                }
                for expense in self.expenses {
                    print("Fetched expense🧸: \(expense)")
                }
            }
        }
    }
}


struct SingleChart: View {
    @State private var selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    @State private var currentYear = Calendar.current.component(.year, from: Date())
    @ObservedObject var chartviewModel = ChartViewViewModel(cardID: "")
    @EnvironmentObject var authViewModel: sessionStore
    @ObservedObject var expensesViewModel: ExpensesViewModel
    @ObservedObject var cardViewModel = CardViewModel()
    @StateObject var viewModel = TViewModel()
    @State private var expenses: [Expenses] = []
    @State private var selectedCard: Card?
    @State private var currentCard: Card? = nil
    
    var filteredExpenses: [Expenses] {
        guard let selectedCard = selectedCard else { return [] }
        return expenses.filter { $0.cardID == selectedCard.cardID }
    }
    
    var body: some View {
        VStack {
            OptionViewFixed(expenses: $expenses, cardViewModel: cardViewModel, chartviewModel: ChartViewViewModel(cardID: ""), selectedMonthIndex: $selectedMonthIndex, currentYear: $currentYear)
                .onChange(of: selectedMonthIndex) { newValue in
                    if let userId = authViewModel.session?.uid {
                        cardViewModel.fetchCards(userID: userId)
                        print("current user id is👹 :\(userId)")

                        if cardViewModel.cards.isEmpty {
                            print("No cards found with the current user ID: \(userId)")
                        } else {
                            let cardIDs = cardViewModel.cards.map { $0.cardID }
                            chartviewModel.fetchFixedExpenses(forCardIDs: cardIDs, userMonth: selectedMonthIndex + 1, expenseType: ChartViewViewModel.ExpenseType.fixed) { fetchedExpenses in
                                if fetchedExpenses.isEmpty {
                                    let defaultExpense = Expenses(id: UUID(), cardID: "", name: "Expenses", currency: .SAR, amount: 0, dateCreated: Date())
                                    self.expenses = [defaultExpense]
                                } else {
                                    self.expenses = fetchedExpenses
                                }
                                for expense in self.expenses {
                                    print("Fetched expense🧸: \(expense)")
                                }
                            }
                        }
                    }
                                }
                            
            
            Group {
                Chart {
                    ForEach(expenses) { expense in
                        BarMark(x: .value("Expenses Name", expense.name),
                                y: .value("Amount", Double(expense.amount)),
                                width: .fixed(20)
                        )
                        .foregroundStyle(Color.customBlue)
                        .cornerRadius(7)
                    }
                }
                .frame(width: 300, height: 200)
                .chartXAxis {
                    AxisMarks(position: .bottom)
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel() {
                            if let intValue = value.as(Int.self) {
                                if intValue < 1000 {
                                    Text("\(intValue)")
                                        .font(.body)
                                } else {
                                    Text("\(intValue / 1000)\(intValue == 0 ? "" : "k")")
                                        .font(.body)
                                }
                            }
                        }
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .padding()
            }
            .onAppear {
                if let userId = authViewModel.session?.uid {
                    cardViewModel.fetchCards(userID: userId)
                    print("current user id is👹 :\(userId)")

                    if cardViewModel.cards.isEmpty {
                        print("No cards found with the current user ID: \(userId)")
                    } else {
                        let cardIDs = cardViewModel.cards.map { $0.cardID }
                        chartviewModel.fetchFixedExpenses(forCardIDs: cardIDs, userMonth: selectedMonthIndex + 1, expenseType:ChartViewViewModel.ExpenseType.fixed) { fetchedExpenses in
                            if fetchedExpenses.isEmpty {
                                let defaultExpense = Expenses(id: UUID(), cardID: "", name: "Expenses", currency: .SAR, amount: 0, dateCreated: Date())
                                self.expenses = [defaultExpense]
                            } else {
                                self.expenses = fetchedExpenses
                            }
                            for expense in self.expenses {
                                print("Fetched expense🧸: \(expense)")
                            }
                        }
                    }
                }
            }
        }
    }
}
