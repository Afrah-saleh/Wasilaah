
//
//  NewExpenses.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 25/10/1445 AH.
//

import SwiftUI
import FirebaseStorage
import UniformTypeIdentifiers
import QuickLook


struct NewExpenses: View {
    @ObservedObject var viewModel: ExpensesViewModel
    @State private var isShowingDocumentPicker = false
    var cardID: String // This needs to be initialized within the initializer
    @State var isShowingNavigateBack = false
    @State var isShowingNavigate = false
    @State private var progress: CGFloat = 0.4  // Represents the current progress
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var showViewer = false
    @State private var fileURL: URL?
    @State private var showShareSheet = false
    @State private var isShowingSubscriptionView = false
    @State private var addButtonCount = 0
    @State private var isShowingAlert = false
    
    
    // Corrected initializer
    init(cardID: String) {
        self.cardID = cardID // Initialize the cardID property
        _viewModel = ObservedObject(wrappedValue: ExpensesViewModel(cardID: cardID))
    }
    
    var body: some View {
        NavigationView {
            VStack{
                ScrollView{
                    VStack{
                        Spacer()
                        // Text Description
                        VStack(alignment:.leading){
                            Text("Update Expenses of this card")
                                .font(.headline)
                                .foregroundColor(.black11)
                            
                        }
                        
                        FileNumber(cardID: cardID)
                            .padding(30)
                        
                        // Expenses Forms
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(viewModel.expenses.indices, id: \.self) { index in
                                    ExpenseForm(viewModel: ExpenseFormViewModel(expense: viewModel.expenses[index]), deleteAction: {
                                        viewModel.expenses.remove(at: index)
                                    }, cardID: cardID)
                                }
                            }
                        }
                        .padding()
                        
                        //                            Spacer()
                    }
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                
                
                
                // Save Button
                Button("Done") {
                    isShowingAlert = true
                    //                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.pprl)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding([.leading, .trailing, .bottom])
                
                
            }
            
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("Confirmation"),
                    message: Text("Are you sure you press on Save for each expenses form?"),
                    primaryButton: .default(Text("OK")) {
                        // Action for "Next" button
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left") // Customize your icon
                    .foregroundColor(.black11) // Customize the color
            })
            .navigationBarTitle("Update Expenses of this card", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                    viewModel.NewExpense()
            }) {
                Image(systemName: "plus")
            })
            .foregroundColor(.black11)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    
    
    
    private func downloadFile(completion: @escaping (URL?) -> Void) {
        let storageRef = Storage.storage().reference()
        let path = "Expensies.numbers"
        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent("Expensies.numbers")
        
        storageRef.child(path).write(toFile: localURL) { url, error in
            if let error = error {
                print("Error downloading file: \(error)")
                completion(nil)
            } else {
                print("File downloaded to: \(url?.path ?? "unknown location")")
                completion(localURL)
            }
        }
    }
}




#Preview {
    NewExpenses(cardID: "12345")
}
