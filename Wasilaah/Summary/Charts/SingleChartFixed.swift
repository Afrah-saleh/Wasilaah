
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
        let months = Calendar.current.shortMonthSymbols // Use abbreviated month names
        
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
    @Binding var selectedMonthIndex: Int // Declare as @Binding
        @Binding var currentYear: Int // Declare as @Binding

    let months = Calendar.current.shortMonthSymbols
    var selectedMonthText: String {
        // Get the current month and year
        let currentMonth = selectedMonthIndex + 1
        let currentYear = self.currentYear
        
        // Calculate the start date for the current month
        let startDateComponents = DateComponents(year: currentYear, month: currentMonth, day: 1)
        guard let startDate = Calendar.current.date(from: startDateComponents) else { return "" }
        
        // Calculate the end date for the next month
        var components = DateComponents()
        components.month = 2 // Next month
        components.day = -1 // Last day of the next month
        let endDate = Calendar.current.date(byAdding: components, to: startDate)
        
        // Format the dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate ?? startDate)
        
        return "\(startDateString) - \(endDateString)"
    }
    
    var body: some View {
        HStack {
            Text(" \(selectedMonthText)").fontWeight(.regular)
                .foregroundColor(Color("TextGray"))
                .font(.system(size: 14))
                
            Spacer()
            DropDownMenuFixed(selectedOption: $selectedMonthIndex)
                .onChange(of: selectedMonthIndex) { _ in
                   
                    currentYear = Calendar.current.component(.year, from: Date())
                    print("Current Year:", currentYear)
                }
        }
        .padding()
    }
}
struct SingleChart: View {
    @State private var selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1
       @State private var currentYear = Calendar.current.component(.year, from: Date())
       
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
    
    
    
    func fetchFixedExpenses(forCardIDs cardIDs: [String], completion: @escaping ([Expenses]) -> Void) {
        // Access Firestore
        let db = Firestore.firestore()
        
        let expensesRef = db.collection("expenses")
        
        // Create a compound query to fetch expenses for multiple card IDs
        let query = expensesRef.whereField("type", isEqualTo: "Fixed")
            .whereField("cardID", in: cardIDs)
        
        // Fetch documents
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching expenses: \(error.localizedDescription)")
                completion([])
            } else {
                // Array to hold fetched expenses
                var expensesArray = [Expenses]()
                
                // Iterate through documents
                for document in querySnapshot!.documents {
                    // Convert Firestore data to Expense object
                    do {
                        let expense = try document.data(as: Expenses.self)
                        expensesArray.append(expense)
                        print("Fetched expense: \(expense)")
                        
                    } catch {
                        print("Error decoding expense: \(error.localizedDescription)")
                    }
                }
                
                // Call completion handler with fetched expenses
                completion(expensesArray)
            }
        }
    }
    
    
    func fetchCards(userID: String, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("cards")
            .whereField("userID", isEqualTo: userID)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching cards: \(error)")
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                // Map documents to Card objects and assign to cardViewModel.cards
                self.cardViewModel.cards = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Card.self)
                }
                
                // Call completion handler after populating cards
                completion()
            }
    }
    
    
    var body: some View {
        VStack{
            OptionViewFixed(selectedMonthIndex: $selectedMonthIndex, currentYear: $currentYear)
            
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
                                    Text("\(intValue/1000)\(intValue == 0 ? "" : "k")")
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
                            // Handle the case where no cards are found
                        } else {
                            let cardIDs = cardViewModel.cards.map { $0.cardID }
                            
                            fetchFixedExpenses(forCardIDs: cardIDs) { fetchedExpenses in
                                self.expenses = fetchedExpenses
                                for expense in fetchedExpenses {
                                    print("Fetched expense: \(expense)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
