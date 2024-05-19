

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
            ScrollView{
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
                                    .foregroundColor(.black11)
                                    .background(Color.white11) // Set the background color to white
                                    .cornerRadius(10) // Apply a corner radius to make the edges rounded
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10) // Use RoundedRectangle for smooth corners
                                            .stroke(Color.gray, lineWidth: 1) // Define the border color and width
                                    )
                                    .frame(width: 150)
                                    
                                
                                Text("Currency")
                                SegmentedControlButton(selection: $viewModel.currency, options: Currency1.allCases)
                                //
                                //                                Button("Upload File") {
                                //                                    showingImagePicker = true
                                //                                    //  viewModel.loadExpense(transaction)
                                //                                    //  presentationMode.wrappedValue.dismiss()
                                //                                }
                                //                                .foregroundColor(.white)
                                //                                .frame(width: 300)
                                //                                .padding()
                                //                                .padding(.leading,20)
                                //                                .background(Color.pprl)
                                //                                .cornerRadius(12)
                                //                                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                                //                                    ImagePicker(image: self.$inputImage)
                                //
                                //                                }
                            }.padding(.all)
                            //.padding(.leading,20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray,lineWidth: 1.0)
                                    .frame(width: 380)
                                    .padding(-20)
                            )
                            
                            Button(action:{
                                viewModel.saveTransaction(cardID: cardID, userID: user.uid)
                                viewModel.updateTransactions(transaction)
                            }){
                                Text("Done")
                                    .foregroundColor(.white)
                                    .frame(width: 300)
                                    .padding()
                                    .background(Color.pprl)
                                    .cornerRadius(12)
                                    .padding(.top,100)
                            }
                          //  .padding(70)
                            
                        }.padding()
                        }
                    }
            }
                .onAppear {
                    viewModel.fetchExpenseNames(cardID: cardID)
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
       .background(Color.white11) // Ensures the capsule's background is white
       .clipShape(RoundedRectangle(cornerRadius: 8))
   }
    
    //download file
    func loadImage() {
        guard let inputImage = inputImage else { return }
        guard let imageData = inputImage.jpegData(compressionQuality: 1.0) else { return }

        let storageRef = Storage.storage().reference().child("transaction_files/\(transaction.id).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading file: \(error.localizedDescription)")
                return
            }
            print("File uploaded successfully")
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }
                guard let downloadURL = url else {
                    print("Download URL is nil")
                    return
                }
                print("File URL: \(downloadURL)")
                // Update transaction with file URL
                self.transaction.fileURL = downloadURL
                self.viewModel.updateTransaction(transaction: self.transaction)
            }
        }
    }
    
    
    
    //download file
//func downloadFile(from url: URL) {
//let downloadTask = URLSession.shared.dataTask(with: url) { data, response, error in
//    guard let data = data, error == nil else {
//        print("Error downloading file: \(error?.localizedDescription ?? "Unknown error")")
//        return
//    }
//    DispatchQueue.main.async {
//        let fileManager = FileManager.default
//        let tempDir = NSTemporaryDirectory()
//        let tempFileURL = URL(fileURLWithPath: tempDir).appendingPathComponent(url.lastPathComponent)
//
//        do {
//            try data.write(to: tempFileURL)
//            self.presentDocumentPicker(for: tempFileURL)
//        } catch {
//            print("Error saving file to temp location: \(error)")
//        }
//    }
//}
//downloadTask.resume()
//}
    
    
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
