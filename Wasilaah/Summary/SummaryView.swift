//
//  SummaryView2.swift
//  Namaa
//
//  Created by sumaiya on 12/05/2567 BE.
//




import SwiftUI
import Charts

struct SummaryView: View {
    
    
    var body: some View {
       
        @EnvironmentObject var authViewModel: sessionStore
      
        var expense: Expenses
        let expensesViewModel = ExpensesViewModel(cardID: "yourCardID")
        let cardViewModel = CardViewModel()
        ScrollView{
            VStack{
                Text("Quick view of all expenses")
                    .fontWeight(.medium)
                   
                
                    .multilineTextAlignment(.center)
                    .padding(.leading,-10)
                    .padding(.bottom,18)
                    .padding(.top,18)
                VStack(){
                    
                    
                    
                    VStack(){
                        Text("Expenses This Month vs. Last Month")
                            .font(.title3)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.leading)
                            .padding(.leading,-25)
                        
                        
                        
                        
                        
                        
                    }
                    
                    CompareExpenses(expensesViewModel:  ExpensesViewModel(cardID: ""), cardViewModel: CardViewModel())
                    
                }.frame(width: 400,height: 400)
                
                Divider()
                VStack(){
                    Text("Fixed Expenses")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.leading,-180)
                    
                    
                    SingleChart(expensesViewModel: ExpensesViewModel(cardID: ""), cardViewModel: CardViewModel() )
                    
                }.frame(width: 400,height: 400)
               
                Divider()
                VStack(){
                    Text("Changeable Expenses")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.leading,-170)
                    
                    
                    
                    ChangeableExpenses(expensesViewModel: ExpensesViewModel(cardID: ""), cardViewModel: CardViewModel())
                    
                    
                }.frame(width: 400,height: 400)
                
                
            }.padding(.horizontal,20)
            
            
        } }
}


#Preview {
    SummaryView()
}
