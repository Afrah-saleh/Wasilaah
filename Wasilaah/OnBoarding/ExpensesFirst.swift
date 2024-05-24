////
////  Expenses.swift
////  Namaa
////
////  Created by Afrah Saleh on 24/10/1445 AH.
////

import SwiftUI
import Combine

struct ExpensesFirst: View {
    //    @ObservedObject var viewModel: ExpensesViewModel
    //    @State private var isShowingDocumentPicker = false
    //    @Environment(\.presentationMode) var presentationMode
    //    var cardID: String // This needs to be initialized within the initializer
    //    @State private var selectedCard: Card? = nil // Manage as per actual logic
    //    @State var isShowingNavigateBack = false
    //    @State var isShowingNavigate = false
    //    @State private var progress: CGFloat = 0.4  // Represents the current progress
    //    @State private var shouldNavigateToHome = false
    //    @State private var addButtonCount = 0
    //    @State private var isShowingSubscriptionView = false
    //        @State private var isShowingAlert = false
    //    @State private var navigateToHome = false // State to control navigation
    //
    //    // Corrected initializer
    //    init(cardID: String) {
    //        self.cardID = cardID // Initialize the cardID property
    //        _viewModel = ObservedObject(wrappedValue: ExpensesViewModel(cardID: cardID))
    //    }
    //    
    //    var body: some View {
    //        NavigationView {
    //            VStack{
    //                    // Adding a progress bar
    //                    GeometryReader { geometry in
    //                        ZStack(alignment: .leading) {
    //                            Rectangle()
    //                                .frame(width: geometry.size.width, height: 10)
    //                                .opacity(0.3)
    //                                .cornerRadius(5.0)
    //                                .foregroundColor(.gray)
    //                            
    //                            Rectangle()
    //                                .frame(width: min(progress * geometry.size.width, geometry.size.width), height: 10)
    //                                .foregroundColor(.pprl)
    //                                .cornerRadius(5.0)
    //                                .animation(.linear, value: progress)
    //                        }
    //                    }
    //                    .frame(height: 10)
    //                    
    //                    
    //                    Divider()
    //
    //                ScrollView{
    //                    VStack{
    //                        // Text Description
    //                        VStack(alignment:.leading){
    //                            Text("Prepare your Wassila Card")
    //                                .font(.headline)
    //                                .foregroundColor(.black11)
    //                            
    //                            Text("Define your expenses that will be record from this card")
    //                                .font(.subheadline)
    //                                .foregroundColor(.gray)
    //                        }
    //                        .padding([.leading, .trailing, .bottom])
    //                        
    //                        .padding(10)
    //                        
    //                        FileNumber(cardID: cardID)
    //                        
    //                            .padding()
    //                        
    //                        
    //                        Spacer()
    //                        
    //                        // Expenses Forms
    //                        VStack(alignment: .leading, spacing: 20) {
    //                            VStack(alignment: .leading, spacing: 20) {
    //                                ForEach(viewModel.expenses.indices, id: \.self) { index in
    //                                    ExpenseForm(viewModel: ExpenseFormViewModel(expense: viewModel.expenses[index]), deleteAction: {
    //                                        viewModel.expenses.remove(at: index)
    //                                    }, cardID: cardID)
    //                                }
    //                            }
    //                        }
    //                        .padding(40)
    //                        
    //                        Spacer()
    //                    }
    //                }
    //                
    //                HStack{
    //                    Button(action:{
    ////                        shouldNavigateToHome = true
    //                        navigateToHome = true
    //                    }){
    //                        Text("skip")
    //                            .foregroundColor(.pprl)
    //                            .frame(minWidth: 0, maxWidth: .infinity)
    //                            .padding()
    //                            .background(Color.gry)
    //                            .cornerRadius(12)
    //                    }
    //                    
    //                    Button("Next") {
    //                     //   viewModel.addExpense()
    ////                        isShowingNavigate = true
    //                                                isShowingAlert = true
    //
    //                    }
    //    .foregroundColor(.white)
    //    .frame(minWidth: 0, maxWidth: .infinity)
    //    .padding()
    //    .background(Color.pprl)
    //    .cornerRadius(12)
    //                }
    //                .padding()
    //                               
    //                }
    ////                .padding(.all)
    //                //.navigationBarHidden(true)
    //                .navigationDestination(isPresented: $isShowingNavigate) {
    //                    FreeBudgent(viewModel: ExpensesViewModel(cardID: cardID), cardID: cardID)
    //                }
    //                .onAppear {
    //                    viewModel.NewExpense()
    //                    
    //                }
    //                .navigationDestination(isPresented: $navigateToHome) {
    ////                    SetPasscodeView()
    ////                    Home(expensesViewModel: ExpensesViewModel(cardID: cardID), cardViewModel: CardViewModel())
    //                  
    //        }
    //            
    //            .sheet(isPresented: $isShowingSubscriptionView) {
    //                SubscriptionView()
    //            }
    //            .navigationBarItems(leading: Button(action: {
    //                            self.presentationMode.wrappedValue.dismiss()
    //                        }) {
    //                                Image(systemName: "chevron.left") // Customize your icon
    //                            .foregroundColor(.black11) // Customize the color
    //                        })
    //            .alert(isPresented: $isShowingAlert) {
    //                            Alert(
    //                                title: Text("Confirmation"),
    //                                message: Text("Are you sure you press on Save for each expenses form?"),
    //                                primaryButton: .default(Text("OK")) {
    //                                    // Action for "Next" button
    //                                    isShowingNavigate = true
    //                                },
    //                                secondaryButton: .cancel()
    //                            )
    //                        }
    //            .navigationBarTitle("Prepare Card" , displayMode: .inline)
    //            .navigationBarItems(trailing: Button(action: {
    //                           addButtonCount += 1
    //                           if addButtonCount >= 5 {
    //                               isShowingSubscriptionView = true
    //                           } else {
    //                               viewModel.NewExpense()
    //                           }
    //                       }) {
    //                           Text("Add")
    //                       })
    //                       .foregroundColor(.black11)
    //        }
    //       
    //
    // 
    //.navigationBarBackButtonHidden(true)
    //
    //    }
    //}
    
    
    @ObservedObject var viewModel: ExpensesViewModel
    @State private var isShowingDocumentPicker = false
    @Environment(\.presentationMode) var presentationMode
    var cardID: String // This needs to be initialized within the initializer
    @State private var selectedCard: Card? = nil // Manage as per actual logic
    @State var isShowingNavigateBack = false
    @State var isShowingNavigate = false
    @State private var progress: CGFloat = 0.4  // Represents the current progress
    @State private var shouldNavigateToHome = false
    @State private var addButtonCount = 0
    @State private var isShowingSubscriptionView = false
    @State private var isShowingAlert = false
    @State private var navigateToHome = false // State to control navigation
    
    // Corrected initializer
    init(cardID: String) {
        self.cardID = cardID // Initialize the cardID property
        _viewModel = ObservedObject(wrappedValue: ExpensesViewModel(cardID: cardID))
    }
    
    
    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                VStack{
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
                    .frame(height: 20)
                    
                    ScrollView{
                        VStack{
                            // Text Description
                            VStack(alignment:.leading){
                                Text("Prepare your Wasilaah Card")
                                    .font(.headline)
                                    .foregroundColor(.black11)
                                Text("Define your expenses that will be record from this card")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            FileNumber(cardID: cardID)
                                .padding(40)
                            
                            // Expenses Forms
                            VStack(alignment: .leading, spacing: 20) {
                                VStack(alignment: .leading, spacing: 20) {
                                    ForEach(viewModel.expenses.indices, id: \.self) { index in
                                        ExpenseForm(viewModel: ExpenseFormViewModel(expense: viewModel.expenses[index]), deleteAction: {
                                            viewModel.expenses.remove(at: index)
                                        }, cardID: cardID)
                                    }
                                }
                            }
                            .padding()
                            
                            //                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    //
                    Spacer()
                    
                    HStack{
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
                        
                        Button("Next") {
                            //   viewModel.addExpense()
                            //                        isShowingNavigate = true
                            isShowingAlert = true
                            
                        }
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.pprl)
                        .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .navigationDestination(isPresented: $isShowingNavigate) {
                FreeBudgent(viewModel: ExpensesViewModel(cardID: cardID), cardID: cardID)
            }
            .onAppear {
                viewModel.NewExpense()
                
            }
            .navigationDestination(isPresented: $navigateToHome) {
                SetPasscodeView()
                //                    Home(expensesViewModel: ExpensesViewModel(cardID: cardID), cardViewModel: CardViewModel())
                
            }
            
//            .sheet(isPresented: $isShowingSubscriptionView) {
//                SubscriptionView()
//            }
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left") // Customize your icon
                    .foregroundColor(.black11) // Customize the color
            })
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("Confirmation"),
                    message: Text("Are you sure you press on Save for each expenses form?"),
                    primaryButton: .default(Text("OK")) {
                        // Action for "Next" button
                        isShowingNavigate = true
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationBarTitle("Prepare Card" , displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                addButtonCount += 1
                if addButtonCount >= 5 {
                    isShowingSubscriptionView = true
                } else {
                    viewModel.NewExpense()
                }
            }) {
                Text("Add")
            })
            .foregroundColor(.black11)
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct SegmentedControlButton<T: Hashable>: View {
    @Binding var selection: T
    let options: [T]
    
    var body: some View {
        let columns = [
            GridItem(.flexible(minimum: 70)),
            GridItem(.flexible(minimum: 70)),
            GridItem(.flexible(minimum: 70)),
            GridItem(.flexible(minimum: 70))
        ]
        
        LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    self.selection = option
                }) {
                    Text(displayString(for: option))
                        .font(.system(size: 12))
                        .foregroundColor(self.selection == option ? .pprl : .black11)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(self.selection == option ? Color.pprl.opacity(0.1) : Color.gray.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(self.selection == option ? Color.pprl : Color.clear, lineWidth: 1)
                        )
                        .cornerRadius(8)
                }
            }
        }
    }

    private func displayString(for value: T) -> String {
        switch value {
        case let value as ExpenseType:
            return value.localized
        case let value as Currency:
            return value.localized
        case let value as PaymentDate:
            return value.localized
        default:
            return "\(value)"
        }
    }
}

#Preview {
    ExpensesFirst(cardID: "12345")
}


