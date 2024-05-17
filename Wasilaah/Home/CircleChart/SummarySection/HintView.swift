//
//  HintView.swift
//  Namaa
//
//  Created by sumaiya on 11/05/2567 BE.
//

import SwiftUI

struct HintView: View {
    
    @State private var isHidden = false
    @State private var currentIndex = 0
    @Environment(\.locale) var locale: Locale

    let cases: [(String, String)] = [
            (NSLocalizedString("hint_track", comment: "Hint about tracking"), "😌"),
            (NSLocalizedString("hint_costs", comment: "Hint about costs"), "🤯"),
            (NSLocalizedString("hint_higher_costs", comment: "Hint about higher costs"), "🤔"),
            (NSLocalizedString("hint_due_date", comment: "Hint about due date"), "⌛️"),
            (NSLocalizedString("hint_unpaid_costs", comment: "Hint about unpaid costs"), "😦")
        ]
    
    var localizedImageName: String {
        let languageCode = locale.language.languageCode?.identifier ?? "en" // Default to English if language code is not found
          switch languageCode {
          case "ar": return "RectangleTextArabic"
          case "en": return "RectangleText"
          default: return "RectangleText" // Fallback default image
          }
      }
    var body: some View {
        // Function to determine if the current language is Arabic
    
        ZStack{
            if !isHidden {
                ZStack{
                    Image(localizedImageName)
                   // Image(isArabic() ? "RectangleTextArabic" : "RectangleText")
                   // Image("RectangleText").resizable()
                        .frame(width: 170, height: 60)
                        //.padding()
                    Text(cases[currentIndex].0)
                        .multilineTextAlignment(.leading)
                       // .padding(.horizontal,10)
                        //.padding(.vertical,10)
                        .padding(.bottom,10)
                        .font(.system(size: 9))
                        .foregroundColor(.black)
                        .shadow(radius: 5)
                    
                    
                    Button(action: {
                        isHidden = true // Set isHidden to true when close button is tapped
                    }) {
                        Image("Close")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                    }
                    .transition(.slide)
                                    .onTapGesture {
                                        withAnimation {
                                            isHidden = true
                                        }
                                    }
                    .padding(.leading,-92)
                    .padding(.top,-35)
                    
                    
                    
                } .padding()
            }
            
            Text(cases[currentIndex].1)
                          
                .font(.title2)
                          .padding(.leading ,170)
                           .padding(.top ,70)
            }
        
        
        }
    
}

#Preview {
    HintView()
}

