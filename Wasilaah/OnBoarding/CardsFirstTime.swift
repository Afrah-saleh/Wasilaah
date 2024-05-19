//
////
////  CardsFirstTime.swift
////  Namaa
////
////  Created by Afrah Saleh on 24/10/1445 AH.
////
//
//import SwiftUI
//
//struct CardsFirstTime: View {
//    @ObservedObject var authViewModel: sessionStore
//    @ObservedObject var cardViewModel: CardViewModel
//    @State private var cardName: String = ""
//    @State private var progress: CGFloat = 0.15  // Represents the current progress
//    @State var isShowingNavigate = false
//    @Binding var card: Card?
//    @Environment(\.presentationMode) var presentationMode
//    @State private var shouldNavigateToHome = false
//    @State private var navigateToHome = false // State to control navigation
//
//
//
//    
//    var body: some View {
//        NavigationView {
//            ScrollView{
//                GeometryReader { geometry in
//                VStack(spacing:20){
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
//                    Divider()
//                    
//                   
////
//                    
//                    // if let user = authViewModel.session {
//                    VStack(alignment:.leading , spacing: 10) {
//                        Text("Prepare your Wassila Card")
//                            .font(.title3)
//                        Text("Card Name")
//                            .fontWeight(.bold)
//                        Text("Assign a Name to Your Card")
//                            .foregroundColor(.gray)
//                        TextField("Ex: Development", text: $cardName)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                        //                        .padding()
//                    }
//                    .padding(.leading,-2)
//                    
//                    
//                    NavigationLink(destination: Home( expensesViewModel: ExpensesViewModel(cardID: ""),cardViewModel: CardViewModel())
//                                   , isActive: $shouldNavigateToHome) {
//                        EmptyView()
//                    }
//                    
//                    
//                    HStack {
//                        Button(action:{
//                            //                        shouldNavigateToHome = true
//                            navigateToHome = true
//                            
//                        }){
//                            Text("skip")
//                                .foregroundColor(.pprl)
//                                .frame(minWidth: 0, maxWidth: .infinity)
//                                .padding()
//                                .background(Color.gry)
//                                .cornerRadius(12)
//                        }
//                        
//                        Button(action: {
//                            if let user = authViewModel.session {
//                                cardViewModel.createCard(userID: user.uid, cardName: cardName) { result in
//                                    switch result {
//                                    case .success(let createdCard):
//                                        self.card = createdCard
//                                        authViewModel.incrementProgress()
//                                        isShowingNavigate = true
//                                    case .failure(let error):
//                                        print("Failed to create card: \(error)")
//                                        // Handle error, show an alert, etc.
//                                    }
//                                }
//                            }
//                        }) {
//                            Text("Next")
//                                .foregroundColor(.white)
//                                .frame(minWidth: 0, maxWidth: .infinity)
//                                .padding()
//                                .background(Color.pprl)
//                                .cornerRadius(12)
//                        }
//                    }
//                    .padding()
//                    .padding(.top,400)
//                    // }
//                    Spacer()
//                }
//                .frame(maxWidth: .infinity,maxHeight: .infinity)
//            }
//            .padding(.all)
//            .navigationDestination(isPresented: $isShowingNavigate) {
//                ExpensesFirst(cardID: card?.cardID ?? "")
//            }
//            .navigationDestination(isPresented: $navigateToHome) {
//                SetPasscodeView()
//    }
//            .navigationBarItems(leading: Button(action: {
//                self.presentationMode.wrappedValue.dismiss()
//            }) {
//                Image(systemName: "chevron.left") // Customize your icon
//                    .foregroundColor(.black11) // Customize the color
//            })
//            .navigationBarTitle("Prepare Card" , displayMode: .inline)
//            
//            
//        }
//                    }
//    .navigationBarBackButtonHidden(true)
//
//            
//                }
//    
//
// }
//            
//
//struct CardsFirstTime_Previews: PreviewProvider {
//    @State static var sampleCard: Card? = Card(cardID: "1", cardName: "Sample Name", userID: "user1") // Example Card instance
//
//    static var previews: some View {
//        CardsFirstTime(
//            authViewModel: sessionStore(),
//            cardViewModel: CardViewModel(),
//            card: $sampleCard
//        )
//    }
//}




//
//  CardsFirstTime.swift
//  Namaa
//
//  Created by Afrah Saleh on 24/10/1445 AH.
//

import SwiftUI

struct CardsFirstTime: View {
    @ObservedObject var authViewModel: sessionStore
    @ObservedObject var cardViewModel: CardViewModel
    @State private var cardName: String = ""
    @State private var progress: CGFloat = 0.15  // Represents the current progress
    @State var isShowingNavigate = false
    @Binding var card: Card?
    @Environment(\.presentationMode) var presentationMode
    @State private var shouldNavigateToHome = false
    @State private var navigateToHome = false // State to control navigation



    
    var body: some View {
        NavigationView {
            ScrollView{
            VStack(spacing:20){
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
                
                Divider()
                
                Text("Prepare your Wasilaah Card")
                    .font(.title3)
                    .padding(.leading,-165)
                
                
                // if let user = authViewModel.session {
                VStack(alignment:.leading , spacing: 10) {
                    Text("Card Name")
                        .fontWeight(.bold)
                    Text("Assign a Name to Your Card")
                        .foregroundColor(.gray)
                    TextField("Ex: Development", text: $cardName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                        .padding()
                }
                .padding(.leading,-2)
                
                
                NavigationLink(destination: Home( expensesViewModel: ExpensesViewModel(cardID: ""),cardViewModel: CardViewModel())
                               , isActive: $shouldNavigateToHome) {
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
                        if let user = authViewModel.session {
                            cardViewModel.createCard(userID: user.uid, cardName: cardName) { result in
                                switch result {
                                case .success(let createdCard):
                                    self.card = createdCard
                                    authViewModel.incrementProgress()
                                    isShowingNavigate = true
                                case .failure(let error):
                                    print("Failed to create card: \(error)")
                                    // Handle error, show an alert, etc.
                                }
                            }
                        }
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
                .padding(.top,400)
                // }
                Spacer()
            }
            .padding(.all)
            .navigationDestination(isPresented: $isShowingNavigate) {
                ExpensesFirst(cardID: card?.cardID ?? "")
            }
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
                    }
    .navigationBarBackButtonHidden(true)

            
                }
    

 }
            

struct CardsFirstTime_Previews: PreviewProvider {
    @State static var sampleCard: Card? = Card(cardID: "1", cardName: "Sample Name", userID: "user1") // Example Card instance

    static var previews: some View {
        CardsFirstTime(
            authViewModel: sessionStore(),
            cardViewModel: CardViewModel(),
            card: $sampleCard
        )
    }
}
