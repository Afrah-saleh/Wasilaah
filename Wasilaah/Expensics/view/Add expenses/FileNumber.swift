//
//  FileNumber.swift
//  Namaa
//
//  Created by Muna Aiman Al-hajj on 28/10/1445 AH.
//

import SwiftUI
import FirebaseStorage
import UniformTypeIdentifiers
import QuickLook

struct FileNumber: View {
    @State private var showShareSheet = false
    @State private var showAlert = false
    @State private var showViewer = false
    @State private var fileURL: URL?
    @ObservedObject var viewModel: ExpensesViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingDocumentPicker = false
    init(cardID: String) {
        _viewModel = ObservedObject(wrappedValue: ExpensesViewModel(cardID: cardID))
    }
    
    var body: some View {
        VStack(spacing:25){
            
            Text("Download Numbers File")
                .padding(.leading,-130)
            
            Button(action:{
                downloadFile { url in
                    self.fileURL = url
                    self.showAlert = true
                }
            }){
                HStack(spacing:50){
                    Text("Numbers File to Fill  Expenses")
                    Image(systemName: "square.and.arrow.down")
                }
            }.background(Image("load"))
                .foregroundColor(.pprl)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("File Downloaded"),
                        message: Text("Choose an option for the downloaded file."),
                        primaryButton: .default(Text("View")) {
                            // Trigger the file viewer
                            self.showViewer = true
                        },
                        secondaryButton: .default(Text("Download")) {
                            if fileURL != nil {
                                self.showShareSheet = true
                            }
                        }
                    )
                }
            
            
            
            Text("Download Numbers File")
                .padding(.leading,-130)
            
            Button(action:{
                isShowingDocumentPicker = true
            }){
                HStack(spacing:150){
                    Text("Check Expenses")
                    Image(systemName: "square.and.arrow.up")
                }
            }
            .background(Image("load"))
            .foregroundColor(.pprl)
            .sheet(isPresented: $isShowingDocumentPicker) {
                DocumentPicker { url in
                    viewModel.uploadExpensesFromPDF(url: url)
                }
            }

        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray,lineWidth: 1.0)
                .frame(width: 355, height: 220)
//                .padding(-45)
                .opacity(0.5)
            
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("File Downloaded"),
                message: Text("Choose an option for the downloaded file."),
                primaryButton: .default(Text("View")) {
                    // Trigger the file viewer
                    self.showViewer = true
                },
                secondaryButton: .default(Text("Download")) {
                    if fileURL != nil {
                        self.showShareSheet = true
                    }
                }
            )
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = fileURL {
                ShareSheet(activityItems: [url])
            }
        }
        .sheet(isPresented: $showViewer) {
            if let url = fileURL {
                FileViewer(url: url)
            }
        }
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

struct FileViewer: UIViewControllerRepresentable {
    var url: URL

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        var parent: FileViewer

        init(_ parent: FileViewer) {
            self.parent = parent
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.url as QLPreviewItem
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}


#Preview {
    FileNumber(cardID: "")
}
