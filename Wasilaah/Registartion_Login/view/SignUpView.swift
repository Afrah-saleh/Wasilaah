
//
//  SignUpView.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 16/10/1445 AH.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import Firebase
import AuthenticationServices

struct SignUpView: View {
@State private var shouldNavigate = false // State to control navigation
@State private var shouldNavigateHome = false
@StateObject var authViewModel = sessionStore()
@State private var currentCard: Card?  // Initialize card as nil
    let texts = [
            ("Take control", "Keep your startup budget in\n check"),
            ("Starup Wallet", "Your path to a more efficient\n business starts here"),
            // Add more pairs as needed
        ]
    
    @State private var selection = 0
       // State to trigger auto-scroll
       @State private var autoScrollIsActive = true

       let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect() // Timer to change tabs every 5 seconds
    
    var body: some View {
        NavigationStack{
            VStack(spacing:5){
                HStack{
                    Text("Wasilaah")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                        .padding(.horizontal, 70)
                    
                    Button(action:{
                        shouldNavigateHome = true
                    }){
                        Text("Skip")
                    }
                }
                .padding(.leading, 40)
                
                Spacer()

                Image("WelcomePage")
                TabView(selection: $selection) {
                            ForEach(texts.indices, id: \.self) { index in
                                VStack(spacing: 2) {
                                    Text(texts[index].0)
                                        .font(.title) // Customize font to match your design
                                        .fontWeight(.bold)
                                    
                                    Text(texts[index].1)
                                        .font(.title2) // Customize font to match your design
                                        .multilineTextAlignment(.center)
                                }
                                .tag(index) // Tag each tab view with the corresponding index
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .frame(height: 190) // Adjust the height to accommodate your text
                        .onReceive(timer) { _ in
                            guard autoScrollIsActive else { return }
                            withAnimation {
                                selection = (selection + 1) % texts.count
                            }
                        }
                        .onAppear {
                            // Start auto-scroll when the view appears
                            autoScrollIsActive = true
                        }
                        .onDisappear {
                            // Stop auto-scroll when the view disappears
                            autoScrollIsActive = false
                        }
                
                        .padding(-20)
                
                VStack(spacing:50){
                    
                    Button(action:{
                        print("Tapped google sign in")
                        
                        authViewModel.signinWithGoogle(presenting: getRootViewController()) { error in
                            if let error = error {
                                print("Error signing in with Google: \(error.localizedDescription)")
                            } else if authViewModel.needsCompanyInfo{
                                self.shouldNavigate = true  // Navigate on success
                            }
                            else if authViewModel.signedIn{
                                self.shouldNavigateHome = true
                            }
                        }
               
                    }){
                        HStack{
                            Image("Google")

                            Text("Continue with Google")
                                .foregroundColor(.white11)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.black11)
                                .frame(width: 300,height: 48)
                        )
                    }

                    
                    
//                    Button(action:{
//                        print("Tapped apple sign in")
//                        authViewModel.startSignInWithAppleFlow()
//                        if authViewModel.needsCompanyInfo{
//                            self.shouldNavigate = true  // Navigate on success
//                        }
//                        else if authViewModel.signedIn{
//                            self.shouldNavigateHome = true
//                        }
//
//                    }){
//                        Image("apple")
//
//                        Text("Continue with Apple")
//                            .foregroundColor(.white11)
//                    }
//                    .background(
//                        RoundedRectangle(cornerRadius: 12)
//                            .foregroundColor(.black11)
//                            .frame(width: 300,height: 48)
//                    )
//                    
                   }
                .padding(50)

   
                
                HStack{
                    Rectangle()
                    Text("OR")
                    Rectangle()
                    
                }
                .frame(height: 0.1)
                .padding(.bottom,20)
                
                NavigationLink(destination: CreateAccount()){
                    
                        Image("Email")
                    
                }
                
                 .padding(10)

                HStack {
                    Text("Already have an account?")
                    
                    NavigationLink(destination: LogInView1(authViewModel: sessionStore())) {
                        Text("Login").foregroundColor(.blue)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            }
        }
        .onChange(of: authViewModel.signedIn) { isSignedIn in
            if isSignedIn {
                if authViewModel.needsCompanyInfo {
                    shouldNavigate = true
                } else {
                    shouldNavigateHome = true
                }
            }
        }
                    
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $shouldNavigate) {
            CardsFirstTime(authViewModel: sessionStore(), cardViewModel: CardViewModel(), card: $currentCard)
        }
        
        .navigationDestination(isPresented: $shouldNavigateHome) {
            Home(expensesViewModel: ExpensesViewModel(cardID: ""),cardViewModel: CardViewModel())

        }
        
    }
}

#Preview {
    SignUpView()
}
