////
////  BarChartFixedView.swift
////  Namaa
////
////  Created by sumaiya on 06/05/2567 BE.
////
//
//import SwiftUI
//import Charts
//
//struct BarChartFixed: View {
//    let options = ["Jan1,2020 - Feb 30,2020", "Feb1,2020 - Mar 30,2020", "Mar1,2020 - Apr 30,2020"]
//    @State private var selectedOption = 0
//    var body: some View {
//        ScrollView{
//            VStack(alignment: .leading){
//                
//                Text("Quick view of all expenses")
//                    .font(.title3)
//                    .fontWeight(.bold)
//                    .padding(.leading,18)
//                   
//                VStack(){
//                    Text("Expenses This Month vs. Last Month")
//                        .font(.title3)
//                        .fontWeight(.medium)
//                        .multilineTextAlignment(.leading)
//                        .padding(.leading,-25)
//                    
//                    HStack{
//                        Text(options[selectedOption])
//                            .fontWeight(.regular)
//                            .foregroundColor(Color("TextGray"))
//                        Spacer()
//                        
//                        DropDownMenu(selectedOption: $selectedOption)
//                        
//                    }.padding(.bottom,40)
//                        .padding(.horizontal,20)
//                    CompareExpenses()
//                    
//                }.frame(width: 400,height: 400)
//                   
//                Divider()
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
//                        DropDownMenu(selectedOption: $selectedOption)
//                        
//                    }.padding(.bottom,40)
//                        .padding(.horizontal,20)
//                    SingleChart()
//                }.frame(width: 400,height: 400)
//             
//                Divider()
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
//                        DropDownMenu(selectedOption: $selectedOption)
//                        
//                    }
//                        .padding(.horizontal,20)
//                 
//                    
//                    ChangeableExpenses()
//                    
//                    
//                }.frame(width: 400,height: 400)
//                   
//                
//            }.padding(.horizontal,20)
//          
//              
//        }
//    }
//}
//
//#Preview {
//    BarChartFixed()
//}
