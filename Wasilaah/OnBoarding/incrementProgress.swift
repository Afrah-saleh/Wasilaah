//
//  incrementProgress.swift
//  Namaa
//
//  Created by Afrah Saleh on 24/10/1445 AH.
//

import SwiftUI

struct incrementProgress: View {
    @State private var progress: CGFloat = 0.0  // Represents the current progress

    var body: some View {
        VStack {
            // Adding a button to increment progress
            Button("Increment") {
                withAnimation {
                    progress += 0.1
                    if progress > 1 { progress = 1 }  // Ensure the progress does not exceed 100%
                }
            }

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
        }
    }
}


#Preview {
    incrementProgress()
}
