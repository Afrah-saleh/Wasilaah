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
        GeometryReader { geometry in
        VStack(spacing: 20) {
            Spacer()
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
        .frame(maxWidth: .infinity,maxHeight: .infinity)
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



//import SwiftUI
//import StoreKit
//
//struct SubscriptionView: View {
//    let productIds = ["Annual", "Monthly"]
//    @Environment(\.presentationMode) var presentationMode
//    @State private var products: [Product] = []
//    @State private var annualProduct: Product?
//    @State private var monthlyProduct: Product?
//
//    var body: some View {
//        GeometryReader { geometry in
//            VStack(spacing: 20) {
//                closeButton
//                
//                Image("Subscription")
//                
//                Text("Stop Guessing, Start Knowing!")
//                    .font(.title2)
//                    .bold()
//                
//                featureList
//                
//                if let annual = annualProduct {
//                    subscriptionButton(for: annual, label: "Annual", geometry: geometry)
//                }
//                
//                if let monthly = monthlyProduct {
//                    subscriptionButton(for: monthly, label: "Monthly", geometry: geometry)
//                }
//
//                restoreAndTerms
//                
//                Spacer()
//            }
//            .task {
//                await loadProducts()
//            }
//        }
//    }
//
//    private var closeButton: some View {
//        Button(action: {
//            presentationMode.wrappedValue.dismiss()
//        }) {
//            Image(systemName: "xmark.circle.fill")
//                .font(.title)
//                .foregroundColor(.gray)
//        }
//        .padding(.trailing)
//        .frame(maxWidth: .infinity, alignment: .trailing)
//    }
//    
//    private var featureList: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            featureItem(icon: "checkmark", title: "Save time!", description: "Automate expense categorization")
//            featureItem(icon: "checkmark", title: "Stay accountable!", description: "Set custom spending limits & track progress")
//        }
//    }
//    
//    private func featureItem(icon: String, title: String, description: String) -> some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Image(systemName: icon)
//                    .foregroundColor(.blue)
//                    .bold()
//                Text(title)
//                    .font(.headline)
//            }
//            Text(description)
//        }
//    }
//    
//    private func subscriptionButton(for product: Product, label: String, geometry: GeometryProxy) -> some View {
//        Button(action: {
//            Task {
//                do {
//                    try await purchase(product)
//                } catch {
//                    print(error)
//                }
//            }
//        }) {
//            VStack(alignment: .leading) {
//                HStack {
//                    Text(label)
//                        .bold()
//                    Spacer()
//                    Text("Best value")
//                        .font(.caption)
//                        .padding(6)
//                        .background(.white)
//                        .cornerRadius(12)
//                }
//                HStack {
//                    Text("Document 3 analysis free")
//                        .font(.caption)
//                    Spacer()
//                    Text("\(product.displayPrice) \(product.displayName)")
//                }
//            }
//            .padding()
//            .frame(width: geometry.size.width * 0.9)
//            .foregroundColor(.white)
//            .background(Color.blue)
//            .cornerRadius(12)
//        }
//    }
//    
//    private var restoreAndTerms: some View {
//        HStack(spacing: 4) {
//            Button("Restore Purchase") {}
//            Text(".")
//            Button("Terms & Conditions") {}
//        }
//        .font(.caption)
//        .foregroundColor(.blue)
//    }
//    
//    private func loadProducts() async {
//        do {
//            let loadedProducts = try await Product.products(for: productIds)
//            for product in loadedProducts {
//                if product.id == "Annual" {
//                    annualProduct = product
//                } else if product.id == "Monthly" {
//                    monthlyProduct = product
//                }
//            }
//        } catch {
//            print(error)
//        }
//    }
//    
//    private func purchase(_ product: Product) async throws {
//        let result = try await product.purchase()
//        // Handle purchase result cases
//    }
//}
//
//struct SubscriptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubscriptionView()
//    }
//}
