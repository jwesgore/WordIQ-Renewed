import SwiftUI

/// A view that displays a horizontal bar chart split into two segments, visually representing two percentages.
///
/// This bar chart uses `GeometryReader` to dynamically adjust to the available space,
/// with each segment styled, sized, and labeled proportionally to the provided percentages.
///
/// Example:
/// If `percentage1 = 0.6` and `percentage2 = 0.4`, the chart will split into two segments:
/// - The first segment occupies 60% of the width.
/// - The second segment occupies 40% of the width.
///
/// - Parameters:
///   - percentage1: A `Double` value representing the first percentage (e.g., 0.6 for 60%).
///   - percentage2: A `Double` value representing the second percentage (e.g., 0.4 for 40%).
///   - barHeight: The height of the bar chart. Defaults to 20.
struct StatsView_Component_BarDistributionChart: View {
    
    // MARK: - Properties
    
    /// The percentage of the first segment (e.g., 0.6 for 60%).
    var percentage1: Double
    
    /// The percentage of the second segment (e.g., 0.4 for 40%).
    var percentage2: Double
    
    /// The height of the bar chart.
    var barHeight: CGFloat
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // First segment
                Rectangle()
                    .fill(Color.Charts.PercentDistribution.background1)
                    .frame(width: geometry.size.width * percentage1, height: barHeight)
                    .overlay(
                        Text(ValueConverter.doubleToPercent(percentage1)) // Displays percentage for the first segment.
                            .foregroundColor(Color.Charts.PercentDistribution.text1)
                            .robotoSlabFont(.caption, .regular)
                            .padding(.leading, 5),
                        alignment: .leading
                    )
                
                // Second segment
                Rectangle()
                    .fill(Color.Charts.PercentDistribution.background2)
                    .frame(width: geometry.size.width * percentage2, height: barHeight)
                    .overlay(
                        Text(ValueConverter.doubleToPercent(percentage2)) // Displays percentage for the second segment.
                            .foregroundColor(Color.Charts.PercentDistribution.text2)
                            .robotoSlabFont(.caption, .regular)
                            .padding(.trailing, 5),
                        alignment: .trailing
                    )
            }
            .cornerRadius(barHeight / 2) // Adds rounded corners for a polished look.
        }
        .frame(height: barHeight) // Ensures the bar chart height matches the specified value.
    }
}

// MARK: - Initializer

extension StatsView_Component_BarDistributionChart {
    /// Initializes the bar chart with a single percentage, automatically calculating the second percentage.
    ///
    /// - Parameters:
    ///   - percentage1: The percentage of the first segment (e.g., 0.6 for 60%).
    ///   - barHeight: The height of the bar chart. Defaults to 20.
    init(_ percentage1: Double, barHeight: CGFloat = 20) {
        self.percentage1 = percentage1
        self.percentage2 = 1.0 - percentage1 // Automatically calculates the second percentage.
        self.barHeight = barHeight
    }
}
