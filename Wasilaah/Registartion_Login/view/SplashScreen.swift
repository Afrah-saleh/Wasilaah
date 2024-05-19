//
//  SplashScreen.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 16/10/1445 AH.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive=false
    @State private var size=0.8
    @State private var opacity=0.5
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var transactionViewModel = TransactionViewModel()
    @StateObject var expensesViewModel = ExpensesViewModel(cardID: "")
    @StateObject var authService = sessionStore()

    var body: some View {
        if isActive {
            RootView(authViewModel: authService, expenses: ExpensesViewModel(cardID: ""))
             .environmentObject(authService) // Pass the authService to your views
                 //.environmentObject(ExpensesViewModel(cardID: "")) // Pass ExpensesViewModel here if it's needed globally
                 .environmentObject(transactionViewModel)
                 .environmentObject(expensesViewModel)
             .onAppear {
                 authService.checkCurrentUser()
             }
        } else {
//            VStack {
//                Image("logo") // Replace "logo" with your image name in the asset catalog
//                    .resizable()
//                    .frame(width: 200,height: 120)
//                
//                    .padding(40)
////                Text("From Chaos to Clarity")
////                    .font(.title2)
////                    
////                                        .padding(.top, 20)
////                                        .opacity(textOpacity)
////                                        .scaleEffect(textScale)
////                                        .onAppear {
////                                            withAnimation(.easeInOut(duration: 1.5)) {
////                                                textOpacity = 1.0
////                                                textScale = 1.0
////                                            }
////                                        }
//                                }
////            .onAppear {
////                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Adjust time as needed
////                    withAnimation {
////                        self.isActive = true
////                    }
////                }
////            }
//            .foregroundColor(.white)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.pprl)
//                        .edgesIgnoringSafeArea(.all)
//        }
//    }
//}

            ZStack{
                Color(Color.pprl)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    
                    
                    VStack {
                        Image("logo")
                            .resizable()
                                                .frame(width: 200,height: 120)
                            
                                                .padding(40)
                        
                    }
                    
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.5)) {
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    }
                }
//                .onAppear {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        withAnimation {
//                            self.isActive = true
//                        }
//                    }
//                }
            }
            .background(.pprl)
        }
    }
}

#Preview {
    SplashScreen()
}
//
//struct SplashScreen: View {
//    @State var textOpacity: Double = 0.0
//    @State var textScale: CGFloat = 0.5
//    @EnvironmentObject var appState: AppState
//    
//    var body: some View {
//        VStack {
//            Image("logo") // Replace "logo" with your image name in the asset catalog
//                .resizable()
//                .frame(width: 200, height: 120)
//                .padding(40)
//            Text("From Chaos to Clarity")
//                .font(.title2)
//                .padding(.top, 20)
//                .opacity(textOpacity)
//                .scaleEffect(textScale)
//                .onAppear {
//                    withAnimation(.easeInOut(duration: 1.5)) {
//                        textOpacity = 1.0
//                        textScale = 1.0
//                    }
//                }
//        }
//        .foregroundColor(.white)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.pprl)
//          .edgesIgnoringSafeArea(.all)
//    }
//}
