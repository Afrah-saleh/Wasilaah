////
////  AddTransactionManually.swift
////  Namaa
////
////  Created by Afrah Saleh on 22/10/1445 AH.
////
//
//import SwiftUI
//import FirebaseStorage
//
//struct AddTransactionManually: View {
//    @ObservedObject var viewModel: TransactionViewModel
//    @ObservedObject var authViewModel: sessionStore
//    @State private var showingImagePicker = false
//    @State private var inputImage: UIImage?
//    @State var transaction: TransactionEntry
//    @Environment(\.presentationMode) var presentationMode
//    @ObservedObject var expensesViewModel: ExpensesViewModel
//
//    var cardID: String
//
//    
//    var body: some View {
//        NavigationView {
//            if let user = authViewModel.session {
//                VStack{
//                    VStack{
//                        VStack(alignment:.leading, spacing:15){
//                            //                    Form {
//                            Text("Expenses Name")
//                            Menu {
//                                Picker("", selection: $viewModel.transactionName) {
//                                    ForEach(viewModel.transactionNames, id: \.self) { name in
//                                        Text(name).tag(name)
//                                    }
//                                }
//                            } label: {
//                                pickerLabel(title: viewModel.transactionName)
//                            }
//                            //                                       .pickerStyle(MenuPickerStyle())
//                            
//                            //                            if viewModel.showCustomNameField {
//                            //                                TextField("Enter custom Expenses name", text: $viewModel.customTransactionName)
//                            //                            }
//                            Text("Amount")
//                            TextField("Amount", text: $viewModel.amount)
//                                .padding(12)
//                                .background(Color.white) // Set the background color to white
//                                .cornerRadius(10) // Apply a corner radius to make the edges rounded
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10) // Use RoundedRectangle for smooth corners
//                                        .stroke(Color.gray, lineWidth: 1) // Define the border color and width
//                                )
//                                .frame(width: 150)
//                            
//                            Text("Currency")
//                            SegmentedControlButton(selection: $viewModel.currency, options: Currency1.allCases)
//                        }
//                        .padding()
//                   
//                            Button("Upload File") {
//                            showingImagePicker = true
//                            //  viewModel.loadExpense(transaction)
//                            //  presentationMode.wrappedValue.dismiss()
//                        }
//                        .foregroundColor(.white)
//                        .frame(width: 300)
//                        //                    .frame(minWidth: 0, maxWidth: .infinity)
//                        .padding()
//                        .background(Color.pprl)
//                        .cornerRadius(12)
//                        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
//                            ImagePicker(image: self.$inputImage)
//                            
//                        }
//                            
//                        }
//                        
//                        
//                        
//                    }
//                    .background(
//                        RoundedRectangle(cornerRadius: 12)
//                            .stroke(Color.gray,lineWidth: 1.0)
//                            .frame(width: 380)
//                        //                    .frame(maxWidth: .infinity,maxHeight: .infinity)
//                            .padding(-20)
//                    )
//                    
//                    .padding(50)
//                    
//                    Button(action:{
//                        //                        viewModel.saveTransaction(cardID: cardID, userID: user.uid)
//                    }){
//                        Text("Done")
//                            .foregroundColor(.white)
//                            .frame(width: 300)
//                            .padding()
//                            .background(Color.pprl)
//                            .cornerRadius(12)
//                    }
//                    Spacer()
//                }
//                //                Spacer()
//            }
//        .navigationBarItems(leading: Button(action: {
//                        self.presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Image(systemName: "xmark")
//                            .foregroundColor(.primary)
//                    })
//        .navigationBarItems(leading: Button(action: {
//            self.presentationMode.wrappedValue.dismiss()
//        }) {
//            Image(systemName: "chevron.left") // Customize your icon
//                .foregroundColor(.black11) // Customize the color
//        })
//                    .onAppear {
//                        viewModel.fetchExpenseNames(cardID: cardID)
//                        viewModel.loadExpense(transaction)
//                    }
//                .navigationBarTitle("Add Expenses", displayMode: .inline)
//        .onAppear {
//                    viewModel.fetchExpenseNames(cardID: cardID)
//                }
//                .onAppear {
//                    viewModel.loadExpense(transaction)
//                }
//                .navigationBarBackButtonHidden(true)
//        }
//
//        
//    
//    @ViewBuilder
//   private func pickerLabel(title: String) -> some View {
//       HStack {
//           Text("Pick an option")
//               .bold()
//               .foregroundColor(.pprl) // Set the color of the text
//           Spacer()
//           Image(systemName: "chevron.down") // Down arrow icon
//               .resizable()
//               .scaledToFit()
//               .frame(width: 10, height: 6) // Adjust the size of the chevron
//               .foregroundColor(.pprl)
//       }
//       .frame(width: 150)
//       .padding(.horizontal)
//       .padding(.vertical, 12)
//       .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.pprl, lineWidth: 1))
//       .background(Color.white) // Ensures the capsule's background is white
//       .clipShape(RoundedRectangle(cornerRadius: 8))
//   }
//    
//   
//    //download file
//    func loadImage() {
//           guard let inputImage = inputImage else { return }
//           guard let imageData = inputImage.jpegData(compressionQuality: 1.0) else { return }
//
//           let storageRef = Storage.storage().reference().child("transaction_files/\(transaction.id).jpg")
//           storageRef.putData(imageData, metadata: nil) { metadata, error in
//               guard metadata != nil else {
//                   print("Error uploading file: \(error?.localizedDescription ?? "Unknown error")")
//                   return
//               }
//               storageRef.downloadURL { url, error in
//                   guard let downloadURL = url else {
//                       print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
//                       return
//                   }
//                   // Update transaction with file URL
//                   var updatedTransaction = transaction
//                   updatedTransaction.fileURL = downloadURL
//                   viewModel.updateTransaction(transaction: updatedTransaction)
//               }
//           }
//       }
//            
//            //download file
//    func downloadFile(from url: URL) {
//        let downloadTask = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                print("Error downloading file: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            DispatchQueue.main.async {
//                let fileManager = FileManager.default
//                let tempDir = NSTemporaryDirectory()
//                let tempFileURL = URL(fileURLWithPath: tempDir).appendingPathComponent(url.lastPathComponent)
//
//                do {
//                    try data.write(to: tempFileURL)
//                    self.presentDocumentPicker(for: tempFileURL)
//                } catch {
//                    print("Error saving file to temp location: \(error)")
//                }
//            }
//        }
//        downloadTask.resume()
//    }
//    
//    func presentDocumentPicker(for fileURL: URL) {
//        // Create the document picker for exporting the specified URL
//        let documentPicker = UIDocumentPickerViewController(forExporting: [fileURL])
//        
//        // Find the window scene
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
//            // Present the document picker on the rootViewController of the key window
//            rootViewController.present(documentPicker, animated: true, completion: nil)
//        }
//    }
//
//
//    
//}
//
//#Preview {
//    AddTransactionManually(viewModel: TransactionViewModel(), authViewModel: sessionStore(), transaction: TransactionEntry.init(id: "12", cardID: "11", userID: "11", transactionName: "ss", amount: 200.0, date: "12-2-24"), expensesViewModel: ExpensesViewModel(cardID: ""), cardID: Card.sample.cardID)
//}




//
//  clean.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 07/11/1445 AH.
//

import SwiftUI
import FirebaseStorage

struct AddTransactionManually: View {
    @ObservedObject var viewModel: TransactionViewModel
    @ObservedObject var authViewModel: sessionStore
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State var transaction: TransactionEntry
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expensesViewModel: ExpensesViewModel

    var cardID: String
    var body: some View {
        NavigationView {
                VStack{
                    if let user = authViewModel.session {
                        VStack{
                            VStack(alignment:.leading, spacing:15){
                                Text("Expenses Name")
                                Menu {
                                    Picker("", selection: $viewModel.transactionName) {
                                        ForEach(viewModel.transactionNames, id: \.self) { name in
                                            Text(name).tag(name)
                                        }
                                    }
                                } label: {
                                    pickerLabel(title: viewModel.transactionName)
                                }
                                
                                Text("Amount")
                                TextField("Amount", text: $viewModel.amount)
                                    .padding(12)
                                    .background(Color.white) // Set the background color to white
                                    .cornerRadius(10) // Apply a corner radius to make the edges rounded
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10) // Use RoundedRectangle for smooth corners
                                            .stroke(Color.gray, lineWidth: 1) // Define the border color and width
                                    )
                                    .frame(width: 150)
                                
                                Text("Currency")
                                SegmentedControlButton(selection: $viewModel.currency, options: Currency1.allCases)
                                
                                Button("Upload File") {
                                    showingImagePicker = true
                                    //  viewModel.loadExpense(transaction)
                                    //  presentationMode.wrappedValue.dismiss()
                                }
                                .foregroundColor(.white)
                                .frame(width: 300)
                                .padding()
                                .padding(.leading,20)
                                .background(Color.pprl)
                                .cornerRadius(12)
                                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                                    ImagePicker(image: self.$inputImage)
                                    
                                }
                            }
                            .padding(.leading,20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray,lineWidth: 1.0)
                                    .frame(width: 380)
                                    .padding(-20)
                            )
                            
                            Button(action:{
                                                        viewModel.saveTransaction(cardID: cardID, userID: user.uid)
                            }){
                                Text("Done")
                                    .foregroundColor(.white)
                                    .frame(width: 300)
                                    .padding()
                                    .background(Color.pprl)
                                    .cornerRadius(12)
                                    .padding(.top,100)
                            }
                            .padding(70)
                            
                            
                        }
                    }
            }
                .onAppear {
                    viewModel.fetchExpenseNames(cardID: cardID)
                    viewModel.loadExpense(transaction)
                }
                .onAppear {
                    viewModel.fetchExpenseNames(cardID: cardID)
                }
                .onAppear {
                    viewModel.loadExpense(transaction)
                }
                .navigationBarTitle("Add Expenses", displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                })
        }
        .navigationBarBackButtonHidden(true)

    }
    
    
    
    
    
    
    
    
    @ViewBuilder
   private func pickerLabel(title: String) -> some View {
       HStack {
           Text("Pick an option")
               .bold()
               .foregroundColor(.pprl) // Set the color of the text
           Spacer()
           Image(systemName: "chevron.down") // Down arrow icon
               .resizable()
               .scaledToFit()
               .frame(width: 10, height: 6) // Adjust the size of the chevron
               .foregroundColor(.pprl)
       }
       .frame(width: 150)
       .padding(.horizontal)
       .padding(.vertical, 12)
       .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.pprl, lineWidth: 1))
       .background(Color.white) // Ensures the capsule's background is white
       .clipShape(RoundedRectangle(cornerRadius: 8))
   }
    
    //download file
    func loadImage() {
           guard let inputImage = inputImage else { return }
           guard let imageData = inputImage.jpegData(compressionQuality: 1.0) else { return }

           let storageRef = Storage.storage().reference().child("transaction_files/\(transaction.id).jpg")
           storageRef.putData(imageData, metadata: nil) { metadata, error in
               guard metadata != nil else {
                   print("Error uploading file: \(error?.localizedDescription ?? "Unknown error")")
                   return
               }
               storageRef.downloadURL { url, error in
                   guard let downloadURL = url else {
                       print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                       return
                   }
                   // Update transaction with file URL
                   var updatedTransaction = transaction
                   updatedTransaction.fileURL = downloadURL
                   viewModel.updateTransaction(transaction: updatedTransaction)
               }
           }
       }
    
    
    
    //download file
func downloadFile(from url: URL) {
let downloadTask = URLSession.shared.dataTask(with: url) { data, response, error in
    guard let data = data, error == nil else {
        print("Error downloading file: \(error?.localizedDescription ?? "Unknown error")")
        return
    }
    DispatchQueue.main.async {
        let fileManager = FileManager.default
        let tempDir = NSTemporaryDirectory()
        let tempFileURL = URL(fileURLWithPath: tempDir).appendingPathComponent(url.lastPathComponent)

        do {
            try data.write(to: tempFileURL)
            self.presentDocumentPicker(for: tempFileURL)
        } catch {
            print("Error saving file to temp location: \(error)")
        }
    }
}
downloadTask.resume()
}
    
    
    func presentDocumentPicker(for fileURL: URL) {
        // Create the document picker for exporting the specified URL
        let documentPicker = UIDocumentPickerViewController(forExporting: [fileURL])
        
        // Find the window scene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            // Present the document picker on the rootViewController of the key window
            rootViewController.present(documentPicker, animated: true, completion: nil)
        }
    }
    
}

#Preview {
    AddTransactionManually(viewModel: TransactionViewModel(), authViewModel: sessionStore(), transaction: TransactionEntry.init(id: "12", cardID: "11", userID: "11", transactionName: "ss", amount: 200.0, date: "12-2-24"), expensesViewModel: ExpensesViewModel(cardID: ""), cardID: Card.sample.cardID)
}
