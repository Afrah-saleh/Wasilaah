
//
//  Summary.swift
//  Namaa
//
//  Created by Afrah Saleh on 25/10/1445 AH.
//

import SwiftUI

struct Summary: View {
    @State private var progress: CGFloat = 0.8
    var cardID: String
   @State private var selectedCard: Card? = nil // Manage as per actual logic
    @State var isShowingNavigate = false

    @ObservedObject var cardViewModel: CardViewModel
    @ObservedObject var authViewModel: sessionStore
    @ObservedObject var expensesViewModel: ExpensesViewModel
    @Environment(\.presentationMode) var presentationMode

    var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    var body: some View {
        NavigationView {
            VStack {
                // Adding a progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: geometry.size.width, height: 10)
                            .opacity(0.3)
                            .cornerRadius(5.0)
                            .foregroundColor(.gray)

                        Rectangle()
                            .frame(width: min(progress * geometry.size.width, geometry.size.width), height: 10)
                            .foregroundColor(.pprl)
                            .cornerRadius(5.0)
                            .animation(.linear, value: progress)
                    }
                }
                .frame(height: 10)
                
                // Congrats Message
                VStack(spacing:50){
                    Text("Congrats")
                        .font(.title)
                        .bold()
                    
                    Text("You have created your first Wassila card!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                // Budget Card
                ZStack{
                    Image("Card")
                        .resizable()
                        .frame(width: 440.52,height: 260)
                    VStack(alignment:.leading){
                        HStack(spacing:280){
                            Image("icon")
                            Image(systemName: "pencil.line")
                                .foregroundColor(.white)
                        }
                        Text("Total Expenses")
                            .font(.subheadline)
                            .foregroundColor(.gry)
                        HStack{
                            Text("\(expensesViewModel.totalExpensesInSAR, specifier: "%.2f")")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                            
                            Text("SAR")
                                .font(.subheadline)
                                .foregroundColor(.gry)
                        }
                        .padding(.bottom,70)
                        
                    }
                    
//                    .offset(x:130,y:-70)
                    
                }
                Spacer()
                // Budget Summary
                VStack(alignment: .leading) {
                    Text("Budget Summary")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                        .padding()
                    VStack{
                        HStack(spacing:20){
                            Text("Budget for Scheduled Expenses:")
                            Text ("\(expensesViewModel.totalNonOtherExpenses, specifier: "%.2f") SAR")
                                .fixedSize()
                            
                        }
                        HStack(spacing:90){
                            Text("Free Budget Expenses:")
                            Text ("\(expensesViewModel.totalOtherExpenses, specifier: "%.2f") SAR")
                                .fixedSize()
                            
                        }
                        Divider()
                        HStack(spacing:150){
                            Text("Total Budget")
                                .bold()
                                .foregroundColor(.pprl)
                            Text ("\(expensesViewModel.totalExpensesInSAR, specifier: "%.2f") SAR")
                                .foregroundColor(.pprl)
                                .fixedSize()
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray,lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                            .frame(width: 380, height: 120)
                            .frame(maxWidth: .infinity,maxHeight: .infinity)
                    )
                    
                    
                }
                Spacer()
                
                // Confirm Button
                Button(action: {
                    isShowingNavigate = true
                }) {
                    Text("Confirm Expenses Records")
                        .foregroundColor(.white)
                        .frame(width: 300,height: 18)
                        .padding()
                        .background(Color.pprl)
                        .cornerRadius(10)
                }
                
            } .padding(.all)
            
                .navigationBarItems(leading: Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                    Image(systemName: "chevron.left") // Customize your icon
                                .foregroundColor(.black11) // Customize the color
                            })
                .navigationBarTitle("Prepare Card" , displayMode: .inline)            .navigationDestination(isPresented: $isShowingNavigate) {
                UploadBank(cardID: cardID, viewModel: TransactionViewModel())
    }
        }
    
        .navigationBarBackButtonHidden(true)


        }
    }


#Preview {
    Summary(cardID: "1234", cardViewModel: CardViewModel(), authViewModel: sessionStore(), expensesViewModel: ExpensesViewModel(cardID: Card.sample.cardID))
}
