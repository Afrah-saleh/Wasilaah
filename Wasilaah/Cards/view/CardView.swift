




import SwiftUI

struct CardView: View {
    @EnvironmentObject var authViewModel: sessionStore
    @ObservedObject var cardViewModel: CardViewModel
    @State private var selectedCard: Card?
    @State private var isExpanded: Bool = false
    @State private var showSheet = false // State to control sheet visibility
    @State private var showActionSheet = false
    @State private var showingSubscriptionView = false
    @State private var showingSignUp = false  // State to show SignUp View

    
    var body: some View {
        VStack{
            if let profile = authViewModel.session {
            
            HStack {
                           Text(isExpanded ? "Cards" : "Cards")
                               .font(.title)
                               .bold()
                               .padding()
                           if isExpanded {
                               Spacer() // Pushes the button to the trailing edge
                               Button(action: {
                                   if cardViewModel.cards.count >= 3 {
                                                           // Show the SubscriptionView
                                                           showingSubscriptionView = true
                                                       } else {
                                                           // Allow adding a card
                                                           showSheet.toggle()
                                                       }
                                                   }) {
                                   Image(systemName: "plus")
                                       .foregroundColor(.black11)
                               }
                               .padding(.trailing)
                           }
                       }
                       .padding()
                       .sheet(isPresented: $showSheet) {
                           CreateCardView(authViewModel: authViewModel, cardViewModel: CardViewModel())
                       }
                       .sheet(isPresented: $showingSubscriptionView) {
                           SubscriptionView() // Pass the binding here
                               }
            
            
            if isExpanded {
                // When expanded, show the cards in a list
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        ForEach(cardViewModel.cards) { card in
                            CardRow(cardViewModel: self.cardViewModel, expensesViewModel: ExpensesViewModel(cardID: card.cardID), card: card, isExpanded: $isExpanded, deleteAction: {
                                // Your code to delete the card
                                self.cardViewModel.deleteCard(card)
                            })
                                .padding(.vertical, -25)
                                .onTapGesture {
                                    self.selectedCard = card
                                }
                        }//foreach
                    }//lazy
                }//scroll
                
            }//if
            else {
                // When not expanded, show the cards in a stack
                GeometryReader { geometry in
                    ZStack {
                        ForEach(Array(cardViewModel.cards.enumerated()), id: \.element.id) { index, card in
                            CardRow(cardViewModel: self.cardViewModel, expensesViewModel: ExpensesViewModel(cardID: card.cardID), card: card, isExpanded: $isExpanded, deleteAction: {
                                // Your code to delete the card
                                self.cardViewModel.deleteCard(card)
                            })
                                .frame(width: geometry.size.width, height: 100)
                                .offset(y: CGFloat(index * 10))
                        }
                    }
                }
                .frame(height: 100 + CGFloat(cardViewModel.cards.count - 1) * 10)
                .padding(40)
                .onTapGesture {
                    withAnimation(.spring()) {
                        isExpanded.toggle()
                    }
                }
            }
            
            } else {
                CardViewBlocked()
                    .onTapGesture {
                        showingSignUp = true
                    }
                
                    .navigationDestination(isPresented: $showingSignUp) {
                        SignUpView(authViewModel: sessionStore())
                        
                    }
            }
            
          //first vstack
        }
            
        .onAppear {
            if let userId = authViewModel.session?.uid {
                cardViewModel.fetchCards(userID: userId)
            }
        }
        //body
    }
}





struct CardRow: View {
    @EnvironmentObject var authViewModel: sessionStore
    @ObservedObject var cardViewModel: CardViewModel
    @ObservedObject var expensesViewModel: ExpensesViewModel
    let card: Card
    @Binding var isExpanded: Bool
    @State private var showActionSheet = false
    var deleteAction: () -> Void

    
    
    var body: some View {
        ZStack{
            cardContent()
            
                Button(action: {
                    showActionSheet = true
                }) {
                    Image(systemName: "ellipsis")
                }
                .foregroundColor(.white) // Change the color to gray
                .font(.largeTitle)
                .offset(x: -80, y: -140)
                .rotationEffect(.degrees(90))
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(title: Text("Are you sure you want to Delete this card?"), buttons: [
                        .destructive(Text("Delete Card"), action: {
                            deleteCard(card)
                        }),
                        .cancel()
                    ])
                }
             
                

            
            
        }
        .onTapGesture {
            withAnimation(.spring()) {
                isExpanded.toggle()
            }
        }
        
    }
    
    
    private func deleteCard(_ card: Card) {
        cardViewModel.deleteCard(card)
    }
    
    
    @ViewBuilder
    private func cardContent() -> some View {
        ZStack {

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
                        
                        
                        NavigationLink(destination: CardDetailView(card: card, cardViewModel: CardViewModel(),expensesViewModel: ExpensesViewModel(cardID: card.cardID))) {
                            Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 10,height: 20)
                        }
                        .padding(.leading, 50)
                        .offset(x:120,y:50)
                    }
                    .padding(10)
                }
                .padding(.bottom, 20)
                .foregroundColor(.white)
        }
    }
}





#Preview {
    CardView(cardViewModel: CardViewModel())
}
