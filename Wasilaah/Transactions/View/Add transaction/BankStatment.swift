//
//  ContentView.swift
//  libarrytablr
//
//  Created by sumaiya on 22/04/2567 BE.
//
import SwiftUI
import PDFKit


struct ContentView: View {
    var cardID: String
    @ObservedObject var viewModel = TransactionViewModel()
    @State private var showingDocumentPicker = false

    var body: some View {
        VStack {
            List(viewModel.transactions) { transaction in
                VStack(alignment: .leading) {
                    Text(transaction.transactionName)
                        .font(.headline)
                    Text("Amount: \(transaction.amount)")
                    Text("Date: \(transaction.date)")
                }
            }
            Button("Load PDF") {
                self.showingDocumentPicker = true
            }
        }
        .sheet(isPresented: $showingDocumentPicker) {
            DocumentPicker { url in
                // Assuming you have a way to extract data from PDF
                let pdfData = extractTableFromPDF(pdfURL: url)
                viewModel.fetchMatchingTransactions(from: pdfData!, cardID: cardID)
            }
        }
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



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(cardID: Card.sample.cardID)
    }
}
