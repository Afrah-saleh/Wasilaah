//
//  SingleExpensesStatus.swift
//  Namaa
//
//  Created by sumaiya on 06/05/2567 BE.
//

import SwiftUI

extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
}

struct RoundedCorner: Shape {
  
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}
struct SingleExpensesStatus: View {
    let title: String
    let date: String
    let amount: Double
    let currency: String
    let circleColor: Color
    let viewIcon: String?
    let status: String?
    let diff: Double // Added to determine the arrow color

    var body: some View {
        
        HStack {
            
            VStack {
            }
                   .frame(width: 24, height: 95)
                   .background(circleColor)
                   .cornerRadius(16, corners: [.bottomLeft, .topLeft])
                    
            VStack{
                HStack(alignment: .center){
                    
                    Text(title)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(Color.black11)
                    Spacer()
                    Text(String(format: "%.2f", amount))
                        .fontWeight(.medium)
                        .foregroundColor(Color.black11)
                    Text(currency)
                        .font(.footnote)
                        .foregroundColor(.black11)
                        .padding(.trailing, 9)
                    
                    
                    
                }
                Divider()
               
                HStack{
                    Text(date)
                        .font(.footnote)
                        .foregroundColor(.black11)
                    Spacer()
                    if let status = status, let viewIcon = viewIcon {
                        HStack(spacing: 4) { // Adjust spacing as necessary
                            Text(status)
                                .foregroundColor(.black11)
                                .font(.footnote)
                                .frame(height: 20) // Adjusted to maintain consistent height with padding
                            Image(systemName: viewIcon)
                                .foregroundColor(diff >= 0 ? .green : .red)  // Color based on diff
                        }
                        
                        
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.gray.opacity(0.2)) // Replace with .buttonGray if you have defined it
                        
                        .cornerRadius(14)
                        .font(.system(size: 10))
                        
                    }
                    else{
                        // When status or viewIcon is nil, make background clear

                        HStack(spacing: 4) { // Adjust spacing as necessary
                            Text(status ?? "")
                                .foregroundColor(.black)
                                .font(.footnote)
                                .frame(height: 20) // Adjusted to maintain consistent height with padding
                            Image(systemName: viewIcon ?? "")
                                .foregroundColor(diff >= 0 ? .green : .red)  // Color based on diff
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.clear) // Clear background                        .cornerRadius(14)
                        .font(.system(size: 10))
                    }
                }.padding(.trailing,8)
                
            }
            
           
        }
        .frame(width: 360, height: 95)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.stork, lineWidth: 1)
                .opacity(0.8)
        )
        .padding(.bottom,3)//for the list spaceing
    }

}

#Preview {
    SingleExpensesStatus(title: "Snapchat Ads", date: "19-4-2024", amount: 350.00, currency: "SAR", circleColor: .yellow, viewIcon: "arrow.up.right", status: "7 days ago", diff: 12.0)
}
