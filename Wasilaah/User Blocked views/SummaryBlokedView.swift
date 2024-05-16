//
//  SummaryBlokedView.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 02/11/1445 AH.
//

import SwiftUI
import Charts

//struct SummaryBlokedView: View {
//    let options = ["Jan1,2020 - Feb 30,2020", "Feb1,2020 - Mar 30,2020", "Mar1,2020 - Apr 30,2020"]
//    @State private var selectedOption = 0
//    var body: some View {
//        let expensesViewModel = ExpensesViewModel(cardID: "yourCardID")
//                  let cardViewModel = CardViewModel()
//        NavigationView{
//        ScrollView{
//            VStack(alignment: .leading){
//                
//                Spacer()
//                
//                
//                VStack(){
//                    Spacer(minLength: 50)
//
//                    Text("Expenses This Month vs. Last Month")
//                        .font(.title3)
//                        .fontWeight(.medium)
//                        .multilineTextAlignment(.leading)
//                        .padding(.leading,-70)
//                    
//                    HStack{
//                        Text(options[selectedOption])
//                            .fontWeight(.regular)
//                            .foregroundColor(Color("TextGray"))
//                        Spacer()
//                        
//                     
//                        
//                    }
//                    .padding(.bottom,40)
//                    .padding(.horizontal,20)
//                    CompareExpenses()
//                    
//                }.frame(width: 400,height: 400)
//                
//                Spacer(minLength: 50)
//                Rectangle()
//                    .frame(width: 300,height: 1)
//                    .padding(.leading,50)
//                    .foregroundColor(.gry)
//                
//                
//                VStack(){
//                    Text("Fixed Expenses")
//                        .font(.title3)
//                        .fontWeight(.medium)
//                        .padding(.leading,-180)
//                    
//                    HStack{
//                        Text(options[selectedOption])
//                            .fontWeight(.regular)
//                            .foregroundColor(Color("TextGray"))
//                        Spacer()
//                     
//                        
//                    }.padding(.bottom,40)
//                        .padding(.horizontal,20)
//                    SingleChart(expensesViewModel: ExpensesViewModel, cardViewModel: <#CardViewModel#>)
//                }.frame(width: 400,height: 400)
//                
//                Rectangle()
//                    .frame(width: 300,height: 1)
//                    .padding(.leading,50)
//                    .foregroundColor(.gry)
//
//                VStack(){
//                    Text("Changeable Expenses")
//                        .font(.title3)
//                        .fontWeight(.medium)
//                        .padding(.leading,-170)
//                    
//                    HStack{
//                        Text(options[selectedOption])
//                            .fontWeight(.regular)
//                            .foregroundColor(Color("TextGray"))
//                        Spacer()
//                        
//                      
//                        
//                    }
//                    .padding(.horizontal,20)
//                    
//                    
//                  //  ChangeableExpenses()
//                    
//                    
//                }.frame(width: 400,height: 400)
//                
//                
//            }
//            .padding(.horizontal,20)
//            
//            
//        }
//    }
//    }
//}
//
//#Preview {
//    SummaryBlokedView()
//}
