//
//  Wallet.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 13/10/1445 AH.
//

import Foundation


struct Card: Identifiable, Codable, Hashable {
    var cardID: String  // This will be used as the unique identifier
    var cardName: String
    var userID: String

    // Conform to Identifiable using a custom property
    var id: String {
        cardID
    }
}
extension Card {
    static var sample: Card {
        Card(cardID: "1", cardName: "Sample Card", userID: "user1")
    }
}
