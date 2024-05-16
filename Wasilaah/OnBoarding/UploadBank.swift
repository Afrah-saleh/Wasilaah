
//
//  UploadBank.swift
//  Namaa
//
//  Created by Afrah Saleh on 26/10/1445 AH.
//

import SwiftUI
import PDFKit

struct UploadBank: View {
    @State private var progress: CGFloat = 0.8 // Represents the current progress
    var cardID: String
    @ObservedObject var viewModel: TransactionViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDocumentPicker = false
    @State private var progress1: CGFloat = 0.0 // Initial progress is 0
    @State private var showingProgressView = false
    @State private var navigateToHome = false // State to control navigation
    @State private var shouldNavigateToHome = false
    
    var body: some View {
        NavigationView {
            VStack{
                VStack {
     
                    // Adding a progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(width: geometry.size.width, height: 10)
                                .opacity(0.3)
                                .cornerRadius(5.0)
                                .foregroundColor(.gray)
                            
                            Rectangle()
                                .frame(width: min(progress * geometry.size.width, geometry.size.width), height: 10)
                                .foregroundColor(.pprl)
                                .cornerRadius(5.0)
                                .animation(.linear, value: progress)
                        }
                    }
                    .frame(height: 10)
                    
                    VStack(alignment: .leading){
                        Text("Record your expenses")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)
                            .padding(.top,30)
                        
                        
                        Text("Please provide your bank statement so we can read your expenses and confirm your Wassila Expense Records card")
                            .padding(.bottom, 20)
                            .font(.callout)
                            .opacity(0.6)
                        ZStack{
                            
                            // Dashed border rectangle
                            DashedRectangle()
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                .frame(height: 150)
                                .opacity(0.3
                                )
                            if showingProgressView {
                                // Show progress view with message and indicator
                                
                                ProgressView("Please wait patiently we're working on it")
                                    .foregroundColor(Color.pprl)
                                
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .frame(height: 150)
                                    .onAppear {
                                        withAnimation {
                                            self.progress1 += 0.2
                                        }
                                        // Start a timer to simulate progress
                                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                                            withAnimation {
                                                self.progress1 += 0.2
                                                if self.progress1 >= 1.0 {
                                                    timer.invalidate()
                                                    // After 5 seconds, navigate to HomeView
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                                        self.navigateToHome = true
                                                    }
                                                }
                                            }
                                        }
                                    }
                            } else {
                                Button(action: {
                                    self.showingDocumentPicker = true
                                }) {
                                    VStack {
                                        
                                        ZStack{
                                            Circle()
                                                .foregroundColor(.gray)
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 70, height: 70)
                                                .opacity(0.2)
                                            Image(systemName: "arrow.up.doc")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(.pprl)
                                        }
                                        Text("Click to Read")
                                            .foregroundColor(Color.pprl)
                                        Text("(Max. File size: 25 MB)")
                                            .font(.caption)
                                            .foregroundColor(Color.black11)
                                            .opacity(0.6)
                                        
                                        
                                    }
                                }
                            }
                        }

                        
                        Spacer()
                        
                        // Disclaimer text
                        VStack(alignment: .leading, spacing: 10) {
                            Text("At Wassila")
                                .fontWeight(.semibold)
                                .font(.system(size: 16))
                            Text("• We only keep expense data to help organize your expenses. We don't access other account information or save it and ensure your privacy.")
                                .font(.system(size: 14))
                            Text("• Your personal data is never used for other purposes.")
                                .font(.system(size: 14))
                            Text("• By uploading the file, you agree to the collection and use of this information for the purposes of providing financial services only")
                                .font(.system(size: 14))
                        }
                        .foregroundColor(.pprl)
                        .font(.caption)
                        .padding(.bottom, 20)
                        

                        
                        // Buttons at the bottom
                        HStack {
                            Button(action: {
                                navigateToHome = true
                            }) {
                                Text("Add Later")
                                    .foregroundColor(.pprl)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .font(.system(size: 14))
                                    .bold()
                            }
                            
                            Button(action: {
                                // Action for Review my Expenses button
                                self.showingProgressView = true
                            }) {
                                Text("Review my Expenses")
                                    .foregroundColor(.white)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding()
                                    .lineLimit(1)
                                    .background(Color.pprl)
                                    .cornerRadius(10)
                                    .font(.system(size: 14))
                                    .bold()
                            }
                        }
                    }
                }
                .padding(.all)
                .navigationBarTitle("Prepare Card", displayMode: .inline)
                .sheet(isPresented: $showingDocumentPicker) {
                    DocumentPicker { url in
                        let pdfData = extractTableFromPDF(pdfURL: url)
                        if let data = pdfData {
                            viewModel.fetchMatchingTransactions(from: data, cardID: cardID)
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                SetPasscodeView()
    }
            .navigationBarItems(leading: Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                                Image(systemName: "chevron.left") // Customize your icon
                            .foregroundColor(.black11) // Customize the color
                        })
            .navigationBarTitle("Prepare Card" , displayMode: .inline)
        }
   
.navigationBarBackButtonHidden(true)
        }
    
        struct DashedRectangle: Shape {
            func path(in rect: CGRect) -> Path {
                var path = Path()
                path.addRect(rect)
                return path
            }
        }
        
        func extractTableFromPDF(pdfURL: URL) -> [[String]]? {
            guard let document = PDFDocument(url: pdfURL) else {
                print("Failed to open PDF document.")
                return nil
            }
            
            var tableData = [[String]]()
            
            for i in 0..<document.pageCount {
                guard let page = document.page(at: i) else { continue }
                guard let text = page.string else { continue }
                
                let rows = text.components(separatedBy: "\n")
                for row in rows {
                    let cells = extractCellsFromRow(row: row)
                    tableData.append(cells)
                }
            }
            
            return tableData
        }
        
        func extractCellsFromRow(row: String) -> [String] {
            // Split the row string into cells using spaces as the delimiter
            let cells = row.components(separatedBy: " ")
            return cells
        }
        
        
        
    }
    
    

#Preview {
    UploadBank(cardID: Card.sample.cardID, viewModel: TransactionViewModel())
}
