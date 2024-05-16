//
//  SingleSummary.swift
//  Namaa
//
//  Created by sumaiya on 06/05/2567 BE.
//

import SwiftUI
import Charts


struct SingleSummary: View {
    let title: String
    let expensesName: String
    let chartTitle: String
    let chartPercentage: String
    let chartArrow: String
    let chartColor: Color
    let percentageColor: Color
    let prograssStrokColor: Color
    let textPadding: EdgeInsets
    let isActive: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: -11.0) {
            ZStack {
                //Text(title)
                Text(NSLocalizedString(title, comment: ""))
                    .font(.footnote)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(textPadding)
                    .padding(.top, -75)
               // Text(expensesName)
                Text(NSLocalizedString(expensesName, comment: ""))

                    .font(.footnote)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, -60)
                    .padding(.top, 120)

                summaryCircle
            }
        }
        .frame(width: 170, height: 170)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray, lineWidth: 1)
                .opacity(0.3)

        )
    }

    private var summaryCircle: some View {
        ZStack {
            Circle()
                .trim(from: 0.3, to: 0.9)
                .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                .opacity(0.3)
                .foregroundColor(Color.gray)
                .rotationEffect(.degrees(54.5))

            Circle()
                .trim(from: 0.3, to: 0.3 + 0.6 * (isActive ? (Double(chartPercentage) ?? 0) / 100 : 0))
                .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(isActive ? prograssStrokColor : Color.gray)
                .rotationEffect(.degrees(54.5))

            VStack {
                HStack {
                    Image(systemName: chartArrow)
                        .font(Font.system(size: 10)).bold()
                        .foregroundColor(chartColor)
                    Text(chartPercentage)
                        .font(Font.system(size: 12)).bold()
                        .foregroundColor(percentageColor)
                }
                Text(chartTitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 100, height: 100)
        .frame(width: 250.0, height: 250.0)
        .padding(40.0)
    }
}
struct SingleSummary_Previews: PreviewProvider {
    static var previews: some View {
        SingleSummary(title: "Increased", expensesName: "Instagram Ads", chartTitle: "Increase By", chartPercentage: "10.49", chartArrow: "arrow.up.right", chartColor: Color.customBlue, percentageColor: Color.customBlue, prograssStrokColor: Color.customBlue, textPadding: EdgeInsets(top: 0, leading: -60, bottom: 0, trailing: 0), isActive: true)
    }
}
