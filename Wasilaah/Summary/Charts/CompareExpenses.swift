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
struct DropDownMenuCompare: View {
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

struct OptionViewCompare: View {
    @State private var selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1 // Initially select the current month
    
    let months = Calendar.current.shortMonthSymbols
    @State private var currentYear = Calendar.current.component(.year, from: Date()) // Use a state property for current year
    
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
 



struct CircleShapeChart: View {
    let color: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 25, height: 25)
            .padding()
    }
    

}

struct CircleComparation:View{
    var body: some View{
        HStack(alignment: .center){
            
            HStack{
                CircleShapeChart(color: .customBlue)
                VStack(alignment: .leading){
                    Text("0")
                    Text("This Month")
                        .font(.caption)
                        .foregroundColor(Color("TextGray"))
                }
            }
            HStack{
                CircleShapeChart(color: .strokYallow)
                VStack(alignment: .leading){
                    Text("0")
                       
                    Text("Last Month")
                        .foregroundColor(Color("TextGray"))
                        .font(.caption)
                }
            }
            
        }.frame(width: 300, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.stork, lineWidth: 1)
            )
            
    }
}
struct CompareExpensesList: Identifiable {
    let id = UUID()
    let expensesName: String
    let amount: Int
    
    init(expensesName: String, amount: Int) {
       
        
        self.expensesName = expensesName
        self.amount = amount
    }
    
    
    
    
}


let expensesThisMonth: [CompareExpensesList] = [
    CompareExpensesList(expensesName: "Week 1", amount: 0),
    CompareExpensesList(expensesName: "Week 2", amount: 0),
    CompareExpensesList(expensesName: "Week 3", amount: 0),
    CompareExpensesList(expensesName: "Week 4", amount: 0),

]
let expensesLastMonth: [CompareExpensesList] = [  CompareExpensesList(expensesName: "Week 1", amount: 0),
    CompareExpensesList(expensesName: "Week 2", amount: 0),
    CompareExpensesList(expensesName: "Week 3", amount: 0),
    CompareExpensesList(expensesName: "Week 4", amount: 0),

]



struct CompareExpenses: View {
    let expensesData = [
        (period: "This Month", data: expensesThisMonth),
        (period: "Last Month", data: expensesLastMonth)
    ]
    
    
    //here the handel of the func
    @State private var expensesThisMonth2: [CompareExpensesList] = []
       @State private var expensesLastMonth2: [CompareExpensesList] = []
       
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
    
    //fun
    
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
    
    func fetchChangebleExpenses(forCardIDs cardIDs: [String], completion: @escaping ([Expenses]) -> Void) {
        // Access Firestore
        let db = Firestore.firestore()
        
        let expensesRef = db.collection("expenses")
        
        // Create a compound query to fetch expenses for multiple card IDs
        let query = expensesRef.whereField("type", isEqualTo: "Changable")
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
    
    var body: some View {
        VStack{
            
            OptionViewCompare()
            
            
            Chart(expensesData,id:\.period){ dataEx in
                ForEach(dataEx.data) {
                    BarMark(x: .value("Expenses Name",$0.expensesName ),
                            y: .value("Amount", $0.amount)
                            , width: .fixed(20)
                            
                    )
                    /// Show a different color for each scheme
                    .foregroundStyle(by: .value("Expenses",dataEx.period))
                    
                    /// Show bars side by side
                    .position(by: .value("Expenses",dataEx.period),
                              axis: .horizontal,
                              span: .ratio(1)
                    )
                    .cornerRadius(7)
                    
                    
                    
                }
                
                
            }.frame(width: 300,height: 200)
                .chartYAxis{
                    AxisMarks(position: .leading){ value in
                        AxisValueLabel(){
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
                .chartForegroundStyleScale([
                    "This Month" : Color(.customBlue),
                    "Last Month" : Color(.strokYallow)
                ])
            
            CircleComparation()
            
            /// Customize the colors for each scheme
            
            
            
                .chartXAxis{
                    AxisMarks(position: .bottom)
                }
            
            
        }         .padding()
            .onAppear {
                if let userId = authViewModel.session?.uid {
                    cardViewModel.fetchCards(userID: userId)
                    print("current user id is👹 :\(userId)")
                    
                    if cardViewModel.cards.isEmpty {
                        print("No cards found with the current user ID: \(userId)")
                        // Handle the case where no cards are found
                    } else {
                        let cardIDs = cardViewModel.cards.map { $0.cardID }
                        
                        fetchFixedExpenses(forCardIDs: cardIDs) { fixedExpenses in
                            self.expenses.append(contentsOf: fixedExpenses)
                        }
                        
                        fetchChangebleExpenses(forCardIDs: cardIDs) { changeableExpenses in
                            self.expenses.append(contentsOf: changeableExpenses)
                        }
                    }
                }
            }
    }
    
    
    
    
}
    
    



//
//#Preview {
//    CompareExpenses()
//    //CircleComparation()
//}
