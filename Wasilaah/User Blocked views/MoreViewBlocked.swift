
//
//  MoreViewBlocked.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 02/11/1445 AH.
//

import SwiftUI

struct MoreViewBlocked: View {
    var body: some View {
        NavigationView{
            VStack{
                
                
                VStack(alignment:.leading, spacing: 20){
                    Text("Account")
                        .bold()
                        .font(.title3)
                        .padding(.leading,-155)
                    VStack(alignment:.leading){
                        Text("Name")
                            .font(.headline)
                            .padding(.leading,-150)
                            .foregroundColor(.black)

                        Text("Example @appleid.com")
                            .foregroundColor(.gray)
                            .font(.caption)
                            .padding(.leading,-150)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.gry)
//                            .stroke(Color.gry, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                            .frame(width: 350,height: 60)
                    )
                }
                .padding()

                
                VStack(alignment:.leading, spacing: 25){
                    Text("Reset Password")
                        .bold()
                        .font(.title3)
                        .padding(.leading,-155)
                    HStack{
                        Text("Change Password")
                            .font(.headline)
                            .padding(.leading,-150)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.gry)
//                            .stroke(Color.gry, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                            .frame(width: 350,height: 60)
                    )
                }
                
                Spacer()
                
                VStack(spacing:50){
                    Button(action: {
                        //                    showingLogoutAlert = true
                    }){
                        HStack{
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Logout")
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke( lineWidth: 1)
                                .frame(width: 300, height: 48)
                            
                        )
                    }
                    .foregroundColor(.pprl)
                    
                    Button(action:{
                        //                    showDeleteAccountAlert = true
                        
                    }){
                        HStack{
                            Image(systemName: "trash")
                            Text("Delete Account")
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke( lineWidth: 1)
                                .frame(width: 300, height: 48)
                        )
                    }
                    .foregroundColor(.red)
                }
                
                .padding()
            }
            
            
        }
        
    }
}

#Preview {
    MoreViewBlocked()
}
