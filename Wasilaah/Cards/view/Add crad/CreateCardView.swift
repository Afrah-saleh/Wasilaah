//
//  CreateCardView.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 28/10/1445 AH.
//

import SwiftUI


struct CreateCardView: View {
    @ObservedObject var authViewModel: sessionStore
    @ObservedObject var cardViewModel: CardViewModel
    @State private var cardName: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                            Spacer()
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black11)
                            }
                            .padding()
                        }
            
            if let user = authViewModel.session {
            
            Text("Create a Card")
                .font(.title)
                .padding(.leading, -180)
            
                .padding()

                Text("Create Title for you Wasilaah card")
                .padding(.leading, -130)
                TextField("Card Name", text: $cardName)
                    .padding()
                    .border(Color.gray)
                    .cornerRadius(12)
                    .frame(width: 322.54, height: 46.45)

                    .padding()
                
//                Button("Create Card") {
//                    cardViewModel.createCard(userID: user.uid, cardName: cardName)
//                    self.presentationMode.wrappedValue.dismiss()
//                }
                
                Spacer()
                
                Button("Create Card") {
                    cardViewModel.createCard(userID: user.uid, cardName: cardName) { result in
                        switch result {
                        case .success(let createdCard):
                            // Optionally do something with createdCard if needed
                            print("Card created successfully with ID: \(createdCard.cardID)")
                            self.presentationMode.wrappedValue.dismiss()
                        case .failure(let error):
                            print("Failed to create card: \(error.localizedDescription)")
                            // Here, handle the error, e.g., show an alert to the user
                            // Do not dismiss the view, let the user try again or correct the error
                        }
                    }
                }
                .padding()
                .frame(width: 300, height: 48)
                .background(Color.pprl)
                .foregroundColor(.white)
                .cornerRadius(12)

            } else {
                Text("Please sign in to create a card.")
            }
        }
        .padding()
    }
}

#Preview {
    CreateCardView(authViewModel: sessionStore(), cardViewModel: CardViewModel())
}
