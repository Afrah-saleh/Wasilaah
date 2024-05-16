//
//  SwiftUIView.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 28/10/1445 AH.
//




import SwiftUI
import StoreKit

struct SubscriptionView: View {
    let productIds = ["Annual", "Monthly"]
    @Environment(\.presentationMode) var presentationMode

    @State private var products: [Product] = []
    @State private var annualProduct: Product?
    @State private var monthlyProduct: Product?

    var body: some View {
        VStack(spacing: 20) {
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 300)
            
            Image("Subscription")
            
            Text("Stop Guessing, Start Knowing!")
                .font(.title2)
                .bold()
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.pprl)
                        .bold()
                    Text("Save time!")
                        .font(.headline)
                }
                .padding(.leading, -27)
                Text("Automate expense categorization")
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.pprl)
                        .bold()
                    Text("Stay accountable!")
                        .font(.headline)
                }
                .padding(.leading, -27)
                Text("Set custom spending limits & track \nprogress")
            }
            

            if let annual = annualProduct {
                Button(action:{
                    Task {
                        do {
                            try await self.purchase(annual)
                        } catch {
                            print(error)
                        }
                    }
                }){
                    VStack(alignment:.leading){
                        HStack(spacing:130){
                            Text("Annual")
                                .bold()
                            Text("Best value")
                                .font(.caption)
                                .frame(width: 80, height: 21.92)
                                .background(.white)
                                .foregroundColor(.black)
                                .cornerRadius(12)
                        }
                        HStack(spacing:30){
                            Text("Document 3 analysis free")
                                .font(.caption)
                            Text("\(annual.displayPrice) \(annual.displayName)")
                        }
                    }
                }
                .frame(width: 320, height: 65)
                .foregroundColor(.white)
                .background(Color.pprl)
                .cornerRadius(12)
            }
            

            if let monthly = monthlyProduct {
                Button(action:{
                    Task {
                        do {
                            try await self.purchase(monthly)
                        } catch {
                            print(error)
                        }
                    }
                }){
                    VStack(alignment:.leading){
                            Text("Monthly")
                                .bold()
                        HStack(spacing:30){
                            Text("Document 3 analysis free")
                                .font(.caption)
                            Text("\(monthly.displayPrice) \(monthly.displayName)")
                        }
                    }
                }
                .frame(width: 320, height: 65)
                .foregroundColor(.white)
                .background(Color.pprl)
                .cornerRadius(12)
            }

            // Restore Purchase, Terms and Conditions, and Upgrade button
            HStack(spacing: 4) {
                Button("Restore Purchase") {
                    // Handle restore purchase
                }
                Text(".")
                Button("Terms & Conditions") {
                    // Handle terms and conditions
                }
            }
            .font(.caption)
            .foregroundColor(.blue)

            Spacer()
//            Button("Upgrade to Pro") {
//                // Handle upgrade action
//            }
//            .frame(width: 320, height: 60)
//            .background(Color.pprl)
//            .foregroundColor(.white)
//            .cornerRadius(12)
        }
        .task {
            do {
                let loadedProducts = try await Product.products(for: productIds)
                for product in loadedProducts {
                    if product.id == "Annual" {
                        annualProduct = product
                    } else if product.id == "Monthly" {
                        monthlyProduct = product
                    }
                }
            } catch {
                print(error)
            }
        }
    }

    private func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                await transaction.finish()
            case .unverified:
                // Handle unverified purchase
                break
            }
        case .pending:
            // Handle pending transaction
            break
        case .userCancelled:
            // Handle user cancellation
            break
        @unknown default:
            // Handle unexpected new cases
            break
        }
    }
}

// Preview
struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}
