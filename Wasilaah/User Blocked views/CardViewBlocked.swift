//
//  CardViewBlocked.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 02/11/1445 AH.
//

import SwiftUI

struct CardViewBlocked: View {
    var body: some View {
        NavigationView{
            VStack(spacing:-40){
                ZStack{
                    Image("Card")
                        .resizable()
                        .frame(width: 400,height: 270)
                        .shadow(color:.gry, radius: 2)
                    VStack(alignment:.leading){
                        Image("icon")
                            .resizable()
                            .frame(width: 40,height: 20)
                        Text("Card Name")
                            .font(.title3)
                        Text("Budget")
                            .font(.caption)
                            .foregroundColor(.gry)
                        HStack{
                            Text("00.00")
                                .bold()
                                .font(.largeTitle)
                            
                            Text("SAR")
                                .font(.subheadline)
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.leading, -155)
                    .padding(.bottom,60)
                    
                    VStack(spacing:120){
                        Button(action: {
                        }) {
                            Image(systemName: "ellipsis")
                        }
                        .rotationEffect(.degrees(90))
                        
                        
                        Button(action: {
                        }) {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .foregroundColor(.white) // Change the color to gray
                    .font(.largeTitle)
                    .padding(.leading,290)
                }
                
                
                
                ZStack{
                    Image("Card")
                        .resizable()
                        .frame(width: 400,height: 270)
                        .shadow(color:.gry, radius: 2)
                    VStack(alignment:.leading){
                        Image("icon")
                            .resizable()
                            .frame(width: 40,height: 20)
                        Text("Card Name")
                            .font(.title3)
                        Text("Budget")
                            .font(.caption)
                            .foregroundColor(.gry)
                        HStack{
                            Text("00.00")
                                .bold()
                                .font(.largeTitle)
                            
                            Text("SAR")
                                .font(.subheadline)
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.leading, -155)
                    .padding(.bottom,60)
                    
                    VStack(spacing:120){
                        Button(action: {
                        }) {
                            Image(systemName: "ellipsis")
                        }
                        .rotationEffect(.degrees(90))
                        
                        
                        Button(action: {
                        }) {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .foregroundColor(.white) // Change the color to gray
                    .font(.largeTitle)
                    .padding(.leading,290)
                }
                
                Spacer()
                
            }
            .navigationBarTitle("Cards", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                
            }) {
                Image(systemName: "plus")
            })
            .foregroundColor(.black11)
        }
        
    }
}

#Preview {
    CardViewBlocked()
}
