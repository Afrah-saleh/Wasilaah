//
//  ToolBar.swift
//  Namaa
//
//  Created by sumaiya on 06/05/2567 BE.
//

import SwiftUI


struct ToolBar: View {
    let segments: [String] = [
        NSLocalizedString("Jan", comment: "January"),
        NSLocalizedString("Feb", comment: "February"),
        NSLocalizedString("Mar", comment: "March"),
        NSLocalizedString("Apr", comment: "April")
    ]

    @State private var selected: String = NSLocalizedString("Jan", comment: "January")
    
    @Namespace var name
    
    @Binding var spendingAmounts: [Double]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top Paid")
                .font(.title)
                .padding(.bottom, 20)
                .padding(.leading,-80)
            
            HStack(spacing: 4) {
                ForEach(segments, id: \.self) { segment in
                    Button {
                        selected = segment
                    } label: {
                        VStack {
                            Text(segment)
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundColor(selected == segment ? .white : .black)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selected == segment ? Color.pprl : Color.buttonGray)
                                )
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .onChange(of: selected,initial: true) { newValue, arg in
            switch newValue {
            case "Jan":
                spendingAmounts = [300.0, 400.0, 600.0, 1000.0]
            case "Feb":
                spendingAmounts = [200.0, 500.0, 700.0, 1200.0]
            case "Mar":
                spendingAmounts = [350.0, 450.0, 550.0, 1100.0]
            case "Apr":
                spendingAmounts = [250.0, 350.0, 800.0, 900.0]
            default:
                break
            }
        }
        
    }
}

#Preview {


    ToolBar(spendingAmounts:.constant([]))
}
