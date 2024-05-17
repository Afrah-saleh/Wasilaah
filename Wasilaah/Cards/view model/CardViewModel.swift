////
////  onBoardingVM.swift
////  Namaa
////
////  Created by Afrah Saleh on 11/10/1445 AH.
////
//
import Foundation
import Combine
import Firebase

class CardViewModel: ObservableObject {
    @Published var cards: [Card] = []

      private var cancellables = Set<AnyCancellable>()
    private let db = Firestore.firestore()
    var expensesViewModels: [String: ExpensesViewModel] = [:]

      // Function to fetch cards for a specific user
//    func fetchCards(userID: String) {
//        db.collection("cards")
//            .whereField("userID", isEqualTo: userID)
//            .addSnapshotListener { querySnapshot, error in
//                if let error = error {
//                    print("Error fetching cards: \(error)")
//                    return
//                }
//                guard let documents = querySnapshot?.documents else {
//                    print("No documents")
//                    return
//                }
//                self.cards = documents.compactMap { queryDocumentSnapshot in
//                    try? queryDocumentSnapshot.data(as: Card.self)
//                }
//            }
//    }
    func fetchCards(userID: String) {
           db.collection("cards")
               .whereField("userID", isEqualTo: userID)
               .addSnapshotListener { querySnapshot, error in
                   if let error = error {
                       print("Error fetching cards: \(error)")
                       return
                   }
                   guard let documents = querySnapshot?.documents else {
                       print("No documents")
                       return
                   }
                   self.cards = documents.compactMap { queryDocumentSnapshot in
                       let card = try? queryDocumentSnapshot.data(as: Card.self)
                       if let card = card {
                           self.expensesViewModels[card.cardID] = ExpensesViewModel(cardID: card.cardID)
                       }
                       return card
                   }
               }
       }
    func createCard(userID: String, cardName: String, completion: @escaping (Result<Card, Error>) -> Void) {
        let newCard = Card(
            cardID: UUID().uuidString,  // Convert UUID to String for the cardID
            cardName: cardName,
            userID: userID
        )
        
        saveCardToFirebase(card: newCard) { result in
            switch result {
            case .success(_):
                completion(.success(newCard))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    func deleteCard(_ cardToDelete: Card) {
        let db = Firestore.firestore()
        db.collection("cards").document(cardToDelete.cardID).delete { error in
            if let error = error {
                // Handle the error here, perhaps by showing an alert to the user
                print("Error removing document: \(error)")
            } else {
                // If the deletion was successful, update the local cards array
                if let index = self.cards.firstIndex(where: { $0.cardID == cardToDelete.cardID }) {
                    DispatchQueue.main.async {
                        self.cards.remove(at: index)
                    }
                }
                // You may want to communicate success to the user, or trigger other UI updates
            }
        }
    }
    
    
    // Save the card data to Firebase
    private func saveCardToFirebase(card: Card) {
        let db = Firestore.firestore()
        do {
            let _ = try db.collection("cards").addDocument(from: card)
        } catch let error {
            print("Error adding card to Firestore: \(error)")
        }
    }
    
    
    func saveCardToFirebase(card: Card, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("cards").document(card.cardID).setData([
            "cardID": card.cardID,
            "cardName": card.cardName,
            "userID": card.userID
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
