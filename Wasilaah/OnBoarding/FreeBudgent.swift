
//
//  FreeBudgent.swift
//  Namaa
//
//  Created by Afrah Saleh on 24/10/1445 AH.
//

import SwiftUI

struct FreeBudgent: View {
    @ObservedObject var viewModel: ExpensesViewModel
     @Environment(\.presentationMode) var presentationMode
     @State private var isShowingNavigate = false
     @State private var progress: CGFloat = 0.6  // Represents the current progress
    @State private var isShowingSummary = false
     var cardID: String
    @State private var selectedCard: Card? = nil // Manage as per actual logic
    @State private var shouldNavigateToHome = false
    @State private var navigateToHome = false // State to control navigation


    var body: some View {
        NavigationView {
            VStack {
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
                
                
                
                Text("Prepare your Wassila Card")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top,20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                
                Text("Free expenses are undefined costs that might be occasional or non-mandatory, but they can still arise unexpectedly.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                VStack{
                    HStack{
                        Text("Set a budget for free expenses")
                        Text("(Optional)")
                            .foregroundColor(.gray)
                    }
                    ZStack {
                        HStack{
                            TextField("Enter amount", text: $viewModel.amount)
                                .padding(10)
                                .frame(height: 50)
                                .keyboardType(.decimalPad)
                                .padding(.trailing, 10)
                            
                            Text("SAR")
                                .foregroundColor(.pprl)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 12)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                }
                .padding()
                .padding(.bottom)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray, lineWidth: 1)
                        .opacity(0.5)
                )
                
                
                Spacer()
                
                NavigationLink(destination:    Home( expensesViewModel: ExpensesViewModel(cardID: ""),cardViewModel: CardViewModel()), isActive: $shouldNavigateToHome) {
                          EmptyView()
                      }
                
                HStack {
                    Button(action:{
//                        shouldNavigateToHome = true
                        navigateToHome = true
                    }){
                        Text("skip")
                            .foregroundColor(.pprl)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.gry)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        viewModel.addOtherExpense()
                        isShowingNavigate = true
                    }) {
                        Text("Next")
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.pprl)
                            .cornerRadius(12)
                    }
                }
                .padding()

                    // Adjust navigationDestination to handle nil scenario more gracefully
                    .navigationDestination(isPresented: $isShowingNavigate) {
                        Summary(cardID: cardID,cardViewModel: CardViewModel(), authViewModel: sessionStore(), expensesViewModel: ExpensesViewModel(cardID: cardID))
                    }
                
            }
            .padding()
            .navigationDestination(isPresented: $navigateToHome) {
                SetPasscodeView()
            }
            .navigationBarItems(leading: Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                                Image(systemName: "chevron.left") // Customize your icon
                            .foregroundColor(.black11) // Customize the color
                        })
            .navigationBarTitle("Prepare Card" , displayMode: .inline)
        }
        .navigationBarBackButtonHidden(true)
    }
    
}
struct FreeBudgent_Previews: PreviewProvider {
    static var previews: some View {
        // Assuming Card is a structure and has a static 'sample' instance for preview purposes
        FreeBudgent(viewModel: ExpensesViewModel(cardID: "12345"), cardID: Card.sample.cardID)
    }
}
