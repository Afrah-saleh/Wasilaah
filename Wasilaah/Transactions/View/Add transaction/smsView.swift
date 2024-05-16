//
//  BankSMSParserView.swift
//  Namaa
//
//  Created by Afrah Saleh on 21/10/1445 AH.
//

import SwiftUI
import UIKit  // Needed to access UIPasteboard


struct smsView: View {
    @EnvironmentObject var session: sessionStore
    @ObservedObject private var viewModel: SMSVM
    @State private var smsText: String = ""
    @Environment(\.presentationMode) var presentationMode
    var cardID: String
    
    init(cardID: String) {
        self.cardID = cardID
        self.viewModel = SMSVM(cardID: cardID)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) { // Set alignment to .leading
              
                Text("Transaction Name:")
                    .font(.headline)
                   Text(viewModel.companyName)
                    .foregroundColor(.black)
                    .opacity(0.6)
                      
                   
                   Text("Amount:")
                    .font(.headline)
                   Text(viewModel.amount)
                    .foregroundColor(.black)
                    .opacity(0.6)

                   Text("Date:")
                    .font(.headline)
                   Text(viewModel.dateTime)
                    .foregroundColor(.black)
                    .opacity(0.6)
                                   
                
                Spacer().frame(height: 20) // Provides spacing between text and buttons
                
                HStack {
                    Button("Paste") {
                        smsText = viewModel.fetchClipboardContent()
                        viewModel.pasteSMS(smsText: smsText)
                    }
                        .foregroundColor(.pprl)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gry)
                        .cornerRadius(12)
                    
                  //  .padding()
                    
                    Button("Save") {
                        viewModel.parseAndSaveSMS(smsText: smsText, cardID: cardID)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.pprl)
                    .cornerRadius(12)
                    //.padding()
                }
                
                TextEditor(text: $smsText)
                    .frame(height: -0) // Specify height for the TextEditor
                    .padding()
                    .border(Color.clear, width: 1) // Adds a border to TextEditor for visual clarity
                
            }
            .padding()
            .navigationBarTitle("Paste from SMS Message", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.black)
                    .opacity(0.4)
            })
        }
    }
}
struct smsView_Previews: PreviewProvider {
    static var previews: some View {
        smsView(cardID: "12345")
            .environmentObject(sessionStore()) // Assuming you have a sessionStore class
    }
}
