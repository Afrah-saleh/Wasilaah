
//
//  Home.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 21/10/1445 AH.
//

import SwiftUI
import Firebase

struct Home: View {
    @Namespace private var namespace
    @EnvironmentObject var authViewModel: sessionStore
    @State private var showingLogoutAlert = false
    @State private var showRootView = false
    @State private var navigateToWallet = false
    @State private var showSheet = false // State to control sheet visibility
    @StateObject var expensesViewModel: ExpensesViewModel
    @StateObject var cardViewModel: CardViewModel
    @StateObject var viewModel = TViewModel()  // Create a single instance
    @StateObject var transitionviewmodel = TransactionViewModel()
    @State private var selectedCard: Card?
    @State private var selectedTab: Int = 0
    @State private var showingSignUp = false  // State to show SignUp View
    @State private var spentText = 1000
    @State private var budgetText = 5440
    // The number of each expense will go here
    @State private var spendingAmounts: [Double] = []
    @State private var transactions: [TransactionEntry] = []
    var strokeColors: [Color] = [.yellow, .blue, .green, .pink]  // Example colors
    @State private var showingSubscriptionView = false
        @State private var selectedButtonIndex = 0
    var filteredTransactions: [TransactionEntry] {
        guard let selectedCard = selectedCard, let user = authViewModel.session else { return [] }
        return transactions.filter { $0.cardID == selectedCard.cardID && $0.userID == user.uid }
    }
    @State private var expenses: [Expenses] = []
    // Accessing the current locale from the environment
    @Environment(\.locale) var locale: Locale
    var filteredExpenses: [Expenses] {
           guard let selectedCard = selectedCard else { return [] }
           return expenses.filter { $0.cardID == selectedCard.cardID }
       }
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView{
                VStack{
                    if authViewModel.signedIn {
                        //                        // User is signed in, show normal content
                        normalContentView()
                    } else {
                        // User is not signed in, show content but block interactions
                        blockedContentView()
                            .onTapGesture {
                                showingSignUp = true
                            }
                        
                            .navigationDestination(isPresented: $showingSignUp) {
                                SignUpView(authViewModel: sessionStore())
                                
                            }
                        
                    }
                    
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showRootView) {
                RootView(authViewModel: authViewModel, expenses: expensesViewModel)
            }
            .sheet(isPresented: $showSheet) {
                CreateCardView(authViewModel: authViewModel, cardViewModel: CardViewModel())
            }
            .sheet(isPresented: $showingSubscriptionView) {
                SubscriptionView() // Pass the binding here
            }
            
            
            .tabItem {
                Label("Dashboard", systemImage: "chart.bar.fill")
            }
            .tag(0)
            
            
            SummaryView()
                .tabItem {
                    Label("Summary", systemImage: "doc.plaintext")
                }
                .tag(1)
            
            CardView(cardViewModel: CardViewModel())
                .tabItem {
                    Label("Card", systemImage: "creditcard")
                }
                .tag(2)
            
            
            MoreView(authViewModel: authViewModel)
                .tabItem {
                    Label("More", systemImage: "circle.grid.2x2")
                }
                .tag(3)
            
        }
        .onAppear {
            viewModel.scheduleNotifications()
            viewModel.scheduleUpdateReminder()
                  fetchTransactions()
                  fetchexpensesIfNeeded()
                  fetchExpensesForSelectedCard()
                  handleSelectedCardChange()
                  if let userId = authViewModel.session?.uid {
                      cardViewModel.fetchCards(userID: userId)
                  }
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                      if !cardViewModel.cards.isEmpty && selectedCard == nil {
                          selectedCard = cardViewModel.cards[0]
                          selectedButtonIndex = 0
                      }
                  }
              }           }
        
    
    @ViewBuilder
    private func normalContentView() -> some View {
 
        VStack{
            Spacer()
            
            HStack {
                // This will align the text "Hello," and the user's full name to the left
                Text("Hello,")
                    .fixedSize() // This will prevent the text from being compressed or stretched
                Text("\(authViewModel.session?.fullName ?? "")")
                    .fixedSize() // This will prevent the text from being compressed or stretched
                
                Image("weekly")
                    .resizable()
                    .frame(width: 20,height: 20)
                Spacer() // This pushes everything else to the sides
                
                // This will align the bell image to the right
                Image(systemName: "bell.badge")
                    .fixedSize() // This will prevent the image from being compressed or stretched
                NavigationLink("View Notifications", destination: NotificationsListView())
            }
            .padding()
            .font(.title2)

            
  
            if authViewModel.session != nil {
                
                ScrollView{
                    VStack(spacing:5){
                        Text("Cards")
                            .font(.title2)
                            .bold()
                            .padding(.leading, -180)
                        HStack(spacing: -10){
                            Button(action: {
                                // Check if the card count is 3 or more
                                if cardViewModel.cards.count >= 3 {
                                    // Show the SubscriptionView
                                    showingSubscriptionView = true
                                } else {
                                    // Allow adding a card
                                    showSheet.toggle()
                                }
                            }) {
                                Image(localizedImageName) // Replace "buttonImage" with the name of your image asset
                                    .onAppear {
                                                print("Current locale: \(locale.identifier)") // This will print the locale identifier
                                            }
                            }
                            
                            
                            ScrollView(.horizontal, showsIndicators: true) {
                                LazyHStack {
                                    ForEach(cardViewModel.cards) { card in
                                        NavigationLink(destination: CardDetailView(card: card, cardViewModel: CardViewModel(), expensesViewModel: ExpensesViewModel(cardID: card.cardID))) {
                                            
                                            ZStack {
                                                Image("Card")
                                                    .resizable()
                                                    .frame(width: 330, height: 210)
                                                
                                                VStack (alignment:.leading){
                                                    Image("icon")
                                                    Text("\(card.cardName)")
                                                        .font(.subheadline)
                                                        .bold()
                                                    Text("Budget")
                                                        .font(.caption)
                                                    HStack(spacing: 2){
//                                                        Text ("\(viewModel.totalExpenseAmount, specifier: "%.2f")")
                                                        Text ("\(viewModel.totalExpenseAmount, specifier: "%.2f")")
                                                            .bold()
                                                        Text("SAR")
                                                            .font(.footnote)
                                                    }
                                                }
                                                .padding(.leading,-125)
                                                .padding(.bottom,40)
                                            }
                                            .padding(-20)
                                        }
                                        .foregroundColor(.white)
                                        .padding(.bottom,10)
                                        .onTapGesture {
                                            self.selectedCard = card
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                    
                    HStack(alignment: .bottom, spacing: 0) {
                                         ForEach(cardViewModel.cards.indices, id: \.self) { index in
                                             Button(action: {
                                                 withAnimation {
                                                     self.selectedCard = cardViewModel.cards[index]
                                                     self.selectedButtonIndex = index
                                                 }
                                             }) {
                                                 VStack {
                                                     Text(cardViewModel.cards[index].cardName)
                                                         .foregroundColor(self.selectedButtonIndex == index ? .pprl : .black11)
                                                         .frame(minWidth: 0, maxWidth: .infinity)
                                                         .font(.caption2)
                                                         .padding(6)
                                                         .bold()
                                                     
                                                     ZStack{
                                                         // Always present thin line
                                                         Rectangle()
                                                             .frame(height: 1)
                                                             .foregroundColor(.pprl)
                                                             .opacity(0.5) // Thin line is less opaque
                                                         
                                                         // Bolder line for the selected button
                                                         if selectedButtonIndex == index {
                                                             Rectangle()
                                                                 .frame(height: 3) // Bolder line is thicker
                                                                 .foregroundColor(.pprl)
                                                                 .transition(.opacity)
                                                                 .matchedGeometryEffect(id: "underline", in: namespace) // Animate the movement
                                                         }
                                                     }
                                                 }
                                             }
                                             .padding(.vertical, 10)
                                         }
                                     }
//                                     .frame(minWidth: 0, maxWidth: .infinity)
                                     .frame(width: 350)
                                     .animation(.default, value: selectedButtonIndex)
                    
                    VStack(spacing:5) {
                        ToolBar(spendingAmounts: $spendingAmounts)
                            .padding()
                        
                        StrokeChart(spendingPercentages: calculateSpendingPercentages(), colors: mapColorsToTransactions())
                            .padding(.top, 10)
                            .padding(.bottom, 30)
                        
                        // Text below the chart
                        VStack {
                            HStack {
                                Text ("\(viewModel.totalTransactionAmount, specifier: "%.2f")")
                                    .font(.headline)
                                Text("/")
                                // Text("\(budgetText)")
                                Text ("\(viewModel.totalExpenseAmount, specifier: "%.2f")")
                                    .font(.headline)
                                Text("SAR")
                                    .font(.footnote)
                            }
                            Text("Total Spent out of the budget")
                                .font(.caption)
                                .fontWeight(.light)
                                .foregroundColor(Color("TextGray"))
                        }
                        
    
                        
                        // Expenses section
                        ExpensesSection(authViewModel: authViewModel, expenses: filteredExpenses, strokeColors: [.blue, .green, .red])
                            .padding(.top, 25)
                        
                        
                        SummarySection(viewModel: viewModel, cardID: selectedCard)
                            .padding(.top, 25)
                            .id(selectedCard?.cardID) // Optional unwrapped safely

                        StatusSection(viewModel: viewModel)
                            .padding(.top, 25)
                        
                    }
  
                }
            }
        }
        .onAppear {
            viewModel.scheduleNotifications()
            viewModel.scheduleUpdateReminder()

                  fetchTransactions()
                  fetchexpensesIfNeeded()
                  fetchExpensesForSelectedCard()
                  handleSelectedCardChange()
                  if let userId = authViewModel.session?.uid {
                      cardViewModel.fetchCards(userID: userId)
                  }
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                      if !cardViewModel.cards.isEmpty && selectedCard == nil {
                          selectedCard = cardViewModel.cards[0]
                          selectedButtonIndex = 0
                      }
                  }
              }
            
        }
    private func handleSelectedCardChange() {
           if let card = selectedCard {
               print("Selected card changed to: \(card.cardName)")
               viewModel.fetchAndDisplayMatchingTransactions(cardID: card.cardID)
           } else {
               print("Selected card is nil")
           }
       }
    private func fetchexpensesIfNeeded() {
        
        if let card = selectedCard {
            
            viewModel.fetchExpenses(cardID: card.cardID)
            
        }
        
    }
        func fetchTransactions() {
            let db = Firestore.firestore()
            db.collection("newTransactions").getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("Error getting documents: (error)")
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    print("No documents found or access denied")
                    return
                }
                if documents.isEmpty {
                    print("Documents array is empty - no transactions found")
                }
                self.transactions = documents.compactMap { document -> TransactionEntry? in
                    try? document.data(as: TransactionEntry.self)
                }
                print("Fetched transactions: (self.transactions)")
            }
            
        }
    private func fetchExpensesForSelectedCard() {
        let db = Firestore.firestore()
        db.collection("expenses").getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching expenses: \(error.localizedDescription)")
                    return
                }

                let fetchedExpenses = querySnapshot?.documents.compactMap { document -> Expenses? in
                    try? document.data(as: Expenses.self)
                } ?? []
                print("Fetched \(fetchedExpenses.count) expenses")
                self.expenses = fetchedExpenses
            }
    }
    
    func calculateSpendingPercentages() -> [CGFloat] {
        let total = filteredExpenses.reduce(0) { $0 + $1.amount }
        return total == 0 ? [] : filteredExpenses.map { CGFloat($0.amount / total) }
    }
    
    func mapColorsToTransactions() -> [Color] {
        return filteredExpenses.enumerated().map { index, _ in getColor(forIndex: index) }
    }
    
    func getColor(forIndex index: Int) -> Color {
        return strokeColors[index % strokeColors.count]
    }
        
    
    
    struct blockedContentView: View {
        @State private var selectedSegment = 0
        let segmentOptions = ["Jan", "Feb", "Mar", "Apr"]
        
        var body: some View {
            VStack{
                headerView()
                
                
                ScrollView {
                    VStack(spacing:10) {
                        cardCarouselView()
                        
                        segmentControlView()
                        
                        budgetProgressView()
                        
                        expensesView()
                        
                        SummaryView1(selection: $selectedSegment, segmentOptions: ["Highest Price","Unpaid","Unpaid","Highest Price"])
                    }
                }
                .navigationBarHidden(true)
            }
        }
        
        private func headerView() -> some View {
            HStack(spacing:170){
                Text("Hello,!")
                    .frame(width: 270)
                    .padding(.leading,-100)
                Image(systemName: "bell.badge")
                
            }
            .font(.title2)
            .padding()
        }
        
        private func cardCarouselView() -> some View {
            VStack(spacing:-5){
                Text("Cards")
                    .font(.title3)
                    .bold()
                    .padding(.leading,-180)
                Button(action: {
                    //                                showingSignUp = true
                    
                }) {
                    Image("AddCard")
                }
                .padding(.leading,-200)
                
//                Image("Ellipse")
            }
            
        }
        
        
        private func segmentControlView() -> some View {
            CustomSegmentedPicker(selection: $selectedSegment, segmentOptions: segmentOptions)
        }
        
        private func budgetProgressView() -> some View {
            VStack {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                        .foregroundColor(Color.gray)
                }
                .frame(width: 150, height: 150)
                
                Spacer(minLength: 30)
                VStack{
                    Text("00 / 000")
                        .font(.title3)
                        .bold()
                    + Text(" SAR")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    
                    Text("Total Spent out of the budget")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .padding(.leading,20)
            }
            .padding()
        }
        
        private func expensesView() -> some View {
            VStack(alignment: .leading) {
                HStack(spacing:175) {
                    Text("Expenses")
                        .font(.headline)
                    Button(action:{}) {
                        HStack{
                            Text("Show more")
                            Image(systemName: "chevron.forward")
                        }
                    }
                    .foregroundColor(.black11)
                }
                .padding(.horizontal)
                
                HStack (spacing: 80){
                    HStack(spacing:100){
                        VStack{
                            Text("No Data to show")
                                .font(.caption)
                            Text("-")
                                .padding(.leading,-48)
                        }
                        
                        HStack{
                            Text("00.00 SAR")
                                .font(.headline)
                            Image(systemName: "chevron.forward")
                        }
                    }
                    .padding(.leading,-50)
                    
                }
                .foregroundColor(.gray)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray,lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                        .opacity(0.5)
                        .padding(.leading,-60)

                )
                .padding(.leading,75)
            }
        }
        
        
        struct SummaryView1: View {
            @Binding var selection: Int
            var segmentOptions: [String]
            
            var body: some View {
                VStack(alignment: .leading) {

                VStack(alignment: .leading){
                    Text("Summary") .font(.title2)
                        .fontWeight(.bold)
                    HStack{
                        SingleSummary(title: "Increased", expensesName: "expensesName",chartTitle: "Increase By",chartPercentage: "00%", chartArrow: "arrow.up.right",chartColor: Color.gray,percentageColor: Color.gray,prograssStrokColor: Color.gray,textPadding: EdgeInsets(top: 0, leading: -70, bottom: 0, trailing: 0), isActive: false)
                        
                        SingleSummary(title:"Less than usual", expensesName: "expensesName",chartTitle: "Increase By",chartPercentage: "00%", chartArrow: "arrow.down.right",chartColor: Color.gray,percentageColor: Color.gray ,prograssStrokColor: Color.gray,textPadding: EdgeInsets(top: 0, leading: -50, bottom: 0, trailing: 0), isActive: false)
                    }
                }
                    
                    Spacer(minLength: 40)
                    
                    HStack {
                        ForEach(segmentOptions.indices, id: \.self) { index in
                            Text(segmentOptions[index])
                                .font(.caption2)
                                .foregroundColor(selection == index ? .white : .black11)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 10)
                                .background(selection == index ? Color.pprl : Color(.systemGray6))
                                .cornerRadius(10)
                                .animation(.default, value: selection)
                                .onTapGesture {
                                    withAnimation {
                                        selection = index
                                    }
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                    
                    
                    Spacer(minLength: 20)
                    
                    HStack (spacing: 80){
                        
                        HStack(spacing:100){
                            VStack{
                                Text("No Data to show")
                                    .font(.caption)
                                Text("-")
                                    .padding(.leading,-48)
                            }
                            
                            HStack{
                                Text("00.00 SAR")
                                    .font(.headline)
                                Image(systemName: "chevron.forward")
                            }
                        }
                        .padding(.leading,-50)
                        
                    }
                    .foregroundColor(.gray)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray,lineWidth: 1.0)
                            .opacity(0.5)
                            .padding(.leading,-60)

                    )
                    .padding(.leading,75)
                    
                }
                .padding()
            }
 
        }
        
        struct ActionButton: View {
            var title: String
            var action: () -> Void
            
            var body: some View {
                Button(action: action) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 14)
                        .background(Color.blue)
                        .cornerRadius(18)
                }
            }
        }
        
        struct SemiCircleProgressIndicator: View {
            var color: Color
            
            var body: some View {
                ZStack {
                    Circle()
                        .trim(from: 0.5, to: 1)
                        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .opacity(0.3)
                        //.foregroundColor(color)
                        .rotationEffect(Angle(degrees: 360))
                    
                    Circle()
                        .trim(from: 0.5, to: 1)
                        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .foregroundColor(color)
                        .rotationEffect(Angle(degrees: 360))
                    // Bind this to your actual progress value
                        .animation(.linear, value: 0.7)
                }
                .frame(width: 250, height: 100) // Adjust size as needed
            }
        }
        
        struct CustomSegmentedPicker: View {
            @Binding var selection: Int
            var segmentOptions: [String]
            
            var body: some View {
                VStack{
                    Text("Last 30 Days")
                        .font(.title3)
                        .bold()
                        .padding(.leading,-180)
                    HStack {
                        ForEach(segmentOptions.indices, id: \.self) { index in
                            Text(segmentOptions[index])
                                .font(.caption2)
                                .foregroundColor(selection == index ? .white : .black11)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(selection == index ? Color.pprl : Color(.systemGray6))
                                .cornerRadius(10)
                                .animation(.default, value: selection)
                                .onTapGesture {
                                    withAnimation {
                                        selection = index
                                    }
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                    
                }
                
            }
            
        }
        
    }
    
    var localizedImageName: String {
        let languageCode = locale.language.languageCode?.identifier ?? "en" // Default to English if language code is not found
          switch languageCode {
          case "ar": return "AddCard_ar"
          case "en": return "AddCard_en"
          default: return "AddCard" // Fallback default image
          }
      }
    
}
    
#Preview {
    Home(expensesViewModel: ExpensesViewModel(cardID: ""),cardViewModel: CardViewModel())
}

