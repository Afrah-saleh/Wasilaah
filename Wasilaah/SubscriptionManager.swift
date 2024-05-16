////
////  SubscriptionManager.swift
////  Namaa
////
////  Created by Muna Aiman Al-hajj on 07/11/1445 AH.
////
//
//import Foundation
//import StoreKit
//import SwiftUI
//
//class SubscriptionManager: ObservableObject {
//    @Published var products: [Product] = []
//    private var productIDs: Set<String> = ["com.yourapp.annual", "com.yourapp.monthly"]
//
//    init() {
//        loadProducts()
//    }
//
//    func loadProducts() {
//        Task {
//            do {
//                let fetchedProducts = try await Product.products(for: productIDs)
//                DispatchQueue.main.async {
//                    self.products = fetchedProducts
//                }
//            } catch {
//                print("Failed to fetch products: \(error)")
//            }
//        }
//    }
//
//    func purchase(_ product: Product) async throws {
//        let result = try await product.purchase()
//        switch result {
//        case .success(let verification):
//            switch verification {
//            case .verified(let transaction):
//                await transaction.finish()
//                print("Purchase successful: \(transaction)")
//            case .unverified(_, _):
//                print("Purchase unverified")
//            }
//        case .userCancelled:
//            print("User cancelled the purchase")
//        case .pending:
//            print("Purchase pending")
//        default:
//            break
//        }
//    }
//
//    func restorePurchases() async {
//        for await result in Transaction.currentEntitlements {
//            guard case .verified(let transaction) = result else { continue }
//            await transaction.finish()
//            print("Restored: \(transaction)")
//        }
//    }
//}
