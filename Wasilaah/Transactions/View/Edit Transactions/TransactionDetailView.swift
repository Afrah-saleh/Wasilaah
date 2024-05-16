////
////  TransactionDetailView.swift
////  Namaa
////
////  Created by Afrah Saleh on 29/10/1445 AH.
////
//
import SwiftUI
import FirebaseStorage

struct TransactionDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TransactionViewModel
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State var transaction: TransactionEntry
    @ObservedObject var expensesViewModel: ExpensesViewModel
    
    
    var body: some View {
        NavigationView{
            VStack{
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 170){
                        Text("Expenses Name")
                            .font(.title3)
                        NavigationLink(destination: EditTransaction(viewModel: viewModel, expensesViewModel: expensesViewModel, transaction: transaction)) {
                            Image(systemName: "pencil.line")
                        }
                    }
                    Text("Name: \(transaction.transactionName)")
                        .foregroundColor(.gray)
                    Text("Amount: \(transaction.amount, specifier: "%.2f")")
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.pprl, lineWidth: 2)
                            .fill(Color.lightpprl))
                        .foregroundColor(.pprl)
                        .padding(.leading,10)
                    Text("Date: \(transaction.date)")
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.pprl, lineWidth: 2)
                            .fill(Color.lightpprl))
                        .foregroundColor(.pprl)
                        .padding(.leading,10)
                    Spacer()
                    if let fileURL = transaction.fileURL {
                        Button("Download File") {
                            downloadFile(from: fileURL)
                            
                        } .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.pprl)
                            .cornerRadius(12)
                    
//                    } else {
//                        Button("Upload File") {
//                            showingImagePicker = true
//
//                        }
//                        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
//                                ImagePicker(image: self.$inputImage)
//                            }
                        Button("Update Transaction") {
                            viewModel.loadExpense(transaction)
                            presentationMode.wrappedValue.dismiss()
                        }//
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.pprl)
                        .cornerRadius(12)
                        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                            ImagePicker(image: self.$inputImage)
                            
                        }
                        
                    }
                }.padding(.all)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray,lineWidth: 1.0)
                    )
            }
                    .padding(.all)
               
            }
        .onAppear {
            viewModel.loadExpense(transaction)
        }
       
    }
            
            //function to upload image
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
        let documentPicker = UIDocumentPickerViewController(forExporting: [fileURL])
        UIApplication.shared.windows.first?.rootViewController?.present(documentPicker, animated: true, completion: nil)
    }
//            func presentDocumentPicker(for fileURL: URL) {
//                // Create the document picker for exporting the specified URL
//                let documentPicker = UIDocumentPickerViewController(forExporting: [fileURL])
//
//                // Find the window scene
//                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                   let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
//                    // Present the document picker on the rootViewController of the key window
//                    rootViewController.present(documentPicker, animated: true, completion: nil)
//                }
//            }

    func uploadFile(imageData: Data, completion: @escaping (URL?) -> Void) {
            let storageRef = Storage.storage().reference().child("transaction_files/\(UUID().uuidString)")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"  // Adjust based on whether it's a PDF or image

            storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                guard metadata != nil else {
                    print("Failed to upload: \(error?.localizedDescription ?? "No error info")")
                    completion(nil)
                    return
                }

                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        print("Download URL not found")
                        completion(nil)
                        return
                    }
                    var updatedTransaction = transaction
                    updatedTransaction.fileURL = downloadURL
                    viewModel.updateTransactions(transaction)
                    completion(downloadURL)
                }
            }
        }
            
        }


#Preview{
    TransactionDetailView(viewModel: TransactionViewModel(), transaction: TransactionEntry.init(id: "12", cardID: "11", userID: "11", transactionName: "ss", amount: 200.0, date: "12-2-24"), expensesViewModel: ExpensesViewModel(cardID: "11"))
}
