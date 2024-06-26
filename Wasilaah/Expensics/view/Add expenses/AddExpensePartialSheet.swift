//
//  AddExpensePartialSheet.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 29/10/1445 AH.
//

import SwiftUI
import PDFKit


struct AddExpensePartialSheet: View {
    @Binding var isPresented: Bool
    var cardID: String
    @State private var showingSmsCoreFunction = false // New state for the BankSMSParserView sheet
    @State private var showingAddTransactionManually = false // State to control the sheet presentation
    @ObservedObject var viewModel = TransactionViewModel()
    @State private var showingDocumentPicker = false
    

    var body: some View {
        VStack {
            Spacer() // Pushes the sheet content to the bottom
                
                
                VStack(spacing: 10) {
                
                    HStack(spacing: 160){
                        Text("Add Expenses")
                            .bold()
                            .foregroundColor(.black11)
                        Button(action: {
                            self.isPresented = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .padding()
                                .foregroundColor(.gray)
                        }
                    }
                    .font(.title2)
                
                

                HStack(spacing:60){
                    
                        Button(action: {
                            self.showingDocumentPicker = true
                        }) {
                            ZStack{
//                                Image("base")
                                VStack (spacing:5){
                                    Image(systemName: "doc.text")
                                        .font(.title2)
                                        .foregroundColor(.pprl)
                                    Text("Upload bank Statement")
                                        .foregroundColor(.black11)
                                        .font(.subheadline)
                                }
                            }
                           
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray,lineWidth: 1.0)
                                .frame(width: 110, height: 120)
                        )
                        .sheet(isPresented: $showingDocumentPicker) {
                            DocumentPicker { url in
                                // Assuming you have a way to extract data from PDF
                                let pdfData = extractTableFromPDF(pdfURL: url)
                                viewModel.fetchMatchingTransactions(from: pdfData!, cardID: cardID)
                            }
                        }
                    
                    
                    Button(action: {
                        self.showingSmsCoreFunction = true // Show the BankSMSParserView when this button is tapped
                                   }) {
                                       ZStack {
//                                           Image("base")
                                           VStack(spacing:5) {
                                               Image(systemName: "bubble.left")
                                                   .font(.title2)
                                                   .foregroundColor(.pprl)
                                               Text("Paste SMS Message")
                                                   .foregroundColor(.black11)
                                                   .font(.subheadline)
                                           }
                                       }
                                   }
                                   .background(
                                       RoundedRectangle(cornerRadius: 12)
                                           .stroke(Color.gray,lineWidth: 1.0)
                                           .frame(width: 110, height: 120)
                                   )
                                   .sheet(isPresented: $showingSmsCoreFunction) {
                                       // Present the BankSMSParserView here
                                       smsView(cardID: cardID) // Replace with your actual card ID
                                   }
                    
//                    Spacer()
                    
                    Button(action: {
                        self.showingAddTransactionManually = true // Set to true to present the sheet
                    }) {
                        ZStack {
//                            Image("base")
                            VStack(spacing:10) {
                                Image(systemName: "plus.circle")
                                    .font(.title2)
                                    .foregroundColor(.pprl)
                                Text("Enter Manually")
                                    .foregroundColor(.black11)
                                    .font(.subheadline)
                            }
                        }
                       
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray,lineWidth: 1.0)
                            .frame(width: 110, height: 120)
                    )
                    .sheet(isPresented: $showingAddTransactionManually) {
                        // Present the AddTransactionManually view as a sheet
                        AddTransactionManually(viewModel: TransactionViewModel(), authViewModel: sessionStore(), transaction: TransactionEntry.init(id: "12", cardID: "11", userID: "11", transactionName: "ss", amount: 200.0, date: "12-2-24"), expensesViewModel: ExpensesViewModel(cardID: ""), cardID: cardID) // Replace with your actual card ID
                    }
                    
                }               
                .padding(.horizontal, 30) // Reduced padding from the horizontal edges of the HStack

                .padding(20)
            }
//            .padding(40)
            .frame(width: 420, height: 250)
//            .frame(maxWidth: .infinity)
            .background(Color.white11)
            .cornerRadius(20)
            .shadow(color:.gray,radius: 10)
            .transition(.move(edge: .bottom))
        }
        .onTapGesture {
            self.isPresented = false
        }
        .edgesIgnoringSafeArea(.all)
    }
}
      



struct AddExpense: View {
        var card: Card
    @Binding var isPresented: Bool
        var cardID: String
        @State private var AddNewExpenses = false // State to control the sheet
        @ObservedObject var expensesViewModel: ExpensesViewModel
    @State private var showAddExpensePartialSheet = false // State to control the presentation of the AddExpensePartialSheet


    var body: some View {
        VStack {
            Spacer() // Pushes the sheet content to the bottom

            VStack(spacing: 10) {
            
                HStack(spacing: 160){
                    Text("Edit Expenses")
                        .bold()
                        .foregroundColor(.black11)
                    Button(action: {
                        self.isPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .padding()
                            .foregroundColor(.gray)
                    }
                }
                .font(.title2)
                
                
                HStack {
                    
                    Button(action: {
                        showAddExpensePartialSheet = true
                    }) {
                        ZStack {
//                            Image("base") // Make sure this image exists in your assets
                            VStack(spacing: 5) {
                                Image(systemName: "pencil.line")
                                    .font(.title)
                                    .foregroundColor(.pprl) // Replace with your actual color
                                Text("Update \n Expenses")
                                    .foregroundColor(.black11) // Replace with your actual color
                                    .font(.subheadline)
                            }
                        }
                       
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray,lineWidth: 1.0)
                            .frame(width: 120, height: 120)
                    )
                    
                    Spacer(minLength: 10) // Further reduced space between buttons

                    
                    Button(action: {
                        
                    }) {
                        ZStack {
                            NavigationLink(
                                destination: NewExpenses(cardID: card.cardID),
                                label: {
                                    ZStack{
//                                        Image("base") // Make sure this image exists in your assets
                                        VStack(spacing: 5) {
                                            Image(systemName: "plus")
                                                .font(.title)
                                                .foregroundColor(.pprl) // Replace with your actual color
                                            Text("Add New \n Expenses")
                                                .foregroundColor(.black11) // Replace with your actual color
                                                .font(.subheadline)
                                                
                                        }
                                    }
                                }
                            )
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray,lineWidth: 1.0)
                            .frame(width: 120, height: 120)
                    )
                }
                .padding(.horizontal, 30) // Reduced padding from the horizontal edges of the HStack

                .padding(40)
            }
            .padding(10)
            .frame(width: 390, height: 250)
            .frame(maxWidth: .infinity)
            .background(Color.white11)
            .cornerRadius(20)
            .shadow(color:.gray,radius: 10)
            .transition(.move(edge: .bottom))
        }
        .onTapGesture {
            self.isPresented = false
        }
        .onAppear {
            expensesViewModel.fetchExpenses(forCardID: card.cardID)
        }
        .overlay(
            Group {
                if showAddExpensePartialSheet {
                    AddExpensePartialSheet(isPresented: $showAddExpensePartialSheet, cardID: cardID)
                        .transition(.move(edge: .top))
                }
            }
        )
        .edgesIgnoringSafeArea(.all)
    }
}

struct AddExpense_Previews: PreviewProvider {
    static var previews: some View {
        AddExpense(card: Card(cardID: "12", cardName: "1", userID: "1"), isPresented: .constant(true), cardID: "12345", expensesViewModel: ExpensesViewModel(cardID: "12"))
    }
}
