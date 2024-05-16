
///
//  CardDetailView.swift
//  Namaa
//
//  Created by Afrah Saleh on 14/10/1445 AH.
//


import SwiftUI

struct CardDetailView: View {
    var card: Card
    //var cardID: String // This needs to be initialized within the initializer
    @ObservedObject var cardViewModel: CardViewModel
    @EnvironmentObject var authViewModel: sessionStore
    @ObservedObject var expensesViewModel: ExpensesViewModel
    @State private var showingAddExpenseSheet = false
    @Environment(\.presentationMode) var presentationMode
    @State private var AddNewExpenses = false // State to control the sheet presentation
    @State private var showDeleteAlert = false
    @State private var expenseToDelete: Expenses?
    var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    init(card: Card, cardViewModel: CardViewModel, expensesViewModel: ExpensesViewModel) {
        self.card = card
       // self.cardID = cardID
        self.cardViewModel = cardViewModel
        //self.authViewModel = authViewModel
        self.expensesViewModel = expensesViewModel
        self.expensesViewModel.fetchExpenses(forCardID: card.cardID)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack(alignment:.leading){
                    ZStack {
                        Image("Card")
                            .resizable()
                            .frame(width: 400,height: 270)
                            .shadow(color:.gry, radius: 2)
                        
                        VStack (alignment:.leading){
                            Image("icon")
                            Text("\(card.cardName)")
                                .font(.subheadline)
                                .bold()
                            Text("Budget")
                                .font(.caption)
                            HStack(spacing: 2){
                                Text("\(expensesViewModel.totalExpensesInSAR, specifier: "%.2f")")
                                    .bold()
                                Text("SAR")
                                    .font(.footnote)
                            }
                        }
                        .padding(.leading,-125)
                        .padding(.bottom,40)
                    }
                    .padding(10)
                }
                .foregroundColor(.white)
                
                
                
                HStack(spacing:210){
                    Text("History")
                        .bold()
                        .font(.title3)
                    
                    
                    NavigationLink(destination: AllExpensesView(expensesViewModel: expensesViewModel, cardID: card.cardID)) {
                        HStack{
                            Text("Show More")
                            Image(systemName: "chevron.forward")
                        }
                        .font(.caption)
                    }
                    
                    
                }
                List {
                    
                    ForEach(expensesViewModel.sortedExpenses.prefix(5)) { expense in
                        NavigationLink(destination: DetailSingleExpenses(expenses: expense, circleColor: .pprl, transactionViewModel: TransactionViewModel(), expensesViewModel: expensesViewModel)) {
                            VStack(alignment: .leading) {
                                HStack{
                                    
                                    Text(expense.name)
                                    Spacer()
                                    
                                    HStack{
                                        Text("\(expense.amount, specifier: "%.2f")")
                                        Text("\(expense.currency.rawValue)")
                                            .font(.custom(String(), size: 10))
                                            .foregroundColor(.gray)
                                            .padding(.top, 5)
                                    }
                                    .fixedSize()
                                }
                                
                                Text("\(expense.dateCreated, formatter: itemFormatter)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: deleteExpense)
                }
                let transactionsViewModel = TransactionViewModel() // Create an instance of TransactionViewModel
                
                NavigationLink(destination: AllTransactionsView(transactionsViewModel: transactionsViewModel, expensesViewModel: expensesViewModel, cardID: card.cardID, authViewModel: authViewModel)) {
                    HStack {
                        Text("Show Transactions")
                        Image(systemName: "chevron.forward")
                    }
                    .font(.caption)
                }

                
                Spacer()
            }
            .onAppear {
                expensesViewModel.fetchExpenses(forCardID: card.cardID)
            }
            
                .overlay(
                            Group {
                                if AddNewExpenses {
                                    AddExpense(card: card, isPresented: $AddNewExpenses, cardID: card.cardID, expensesViewModel: ExpensesViewModel(cardID: card.cardID))
                                }
                            }, alignment: .bottom
                        )
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Are you sure you want to delete this expense?"),
                message: Text("This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let expense = expenseToDelete {
                        expensesViewModel.deleteExpense(expense)
                    }
                },
                secondaryButton: .cancel {
                    expenseToDelete = nil
                }
            )
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                            Image(systemName: "chevron.left") // Customize your icon
                        .foregroundColor(.black11) // Customize the color
                    })
                    .navigationBarTitle("\(card.cardName)", displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        self.AddNewExpenses.toggle()
                    }) {
                        Image(systemName: "plus")
                    })
                    .foregroundColor(.black11)

        
    }
    private func deleteExpense(at offsets: IndexSet) {
        for index in offsets {
            let expense = expensesViewModel.sortedExpenses[index]
            expenseToDelete = expense
            showDeleteAlert = true
        }
    }
}





#Preview {
CardDetailView(
    card: Card.sample,
    cardViewModel: CardViewModel(),
   // authViewModel: sessionStore(),
    expensesViewModel: ExpensesViewModel(cardID: Card.sample.cardID)
)
}
