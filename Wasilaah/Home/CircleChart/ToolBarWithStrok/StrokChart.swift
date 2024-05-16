//
//  StrokCjart.swift
//  Namaa
//
//  Created by sumaiya on 06/05/2567 BE.
//


import SwiftUI
import FirebaseFirestore

struct StrokeChart: View {
    var spendingPercentages: [CGFloat]
    var colors: [Color] 

    var body: some View {
        
        // Ensure both the percentages and colors are limited to the count of available data, up to 4
        let limitedCount = min(spendingPercentages.count, colors.count, 4)
        let limitedPercentages = Array(spendingPercentages.prefix(limitedCount))
        let limitedColors = Array(colors.prefix(limitedCount))
        let totalProgress = limitedPercentages.reduce(0, +)
        
        // Calculate cumulative progress for each segment of the limited data
        let cumulativeProgress = limitedPercentages.reduce(into: [CGFloat]()) { result, value in
            let lastValue = result.last ?? 0
            result.append(lastValue + value / (totalProgress == 0 ? 1 : totalProgress))
        }
        
        return ZStack {
            if totalProgress == 0 {
                // Show a full gray circle when there's no data
                Circle()
                    .stroke(Color.gray, lineWidth: 20)
                    .rotationEffect(.degrees(-90))
            } else {
                // Display the pie chart with the specified colors and percentages
                ForEach(0..<limitedPercentages.count, id: \.self) { index in
                    Circle()
                        .trim(from: index == 0 ? 0 : cumulativeProgress[index - 1], to: cumulativeProgress[index])
                        .stroke(limitedColors[index], style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.easeIn, value: cumulativeProgress[index])
                }
            }
            // HintView positioned relative to the pie chart
            HintView()
                .frame(width: 50, height: 80)
                .padding(.leading, -120)
                .padding(.top, -73)
        }
        .frame(width: 180, height: 180) // Fixed size for the pie chart
    }
}

// Preview for the StrokeChart
struct StrokeChart_Previews: PreviewProvider {
    static var previews: some View {
        StrokeChart(spendingPercentages: [0.25, 0.35, 0.40], colors: [.red, .blue, .green])
    }
}
