import SwiftUI

/// A view that displays a horizontal bar chart split into two segments, visually representing two percentages.
///
/// This bar chart dynamically adjusts its layout using `GeometryReader` to fit the available width.
/// Each segment of the chart is styled and sized proportionally based on the provided percentages,
/// with optional labels for displaying custom or calculated percentage values.
///
/// ## Example
/// If `percentage1 = 0.6` and `percentage2 = 0.4`, the chart will:
/// - Allocate 60% of the width to the first segment.
/// - Allocate 40% of the width to the second segment.
/// - Display the default or custom labels for each percentage (if provided).
///
/// ## Customization
/// You can control the following aspects of the chart:
/// - **Appearance**: Define segment colors and text styles using `Color.Charts.PercentDistribution`.
/// - **Labels**: Provide custom labels for the segments or fall back to calculated percentage values.
/// - **Bar Height**: Adjust the height of the bar as needed.
///
/// - Parameters:
///   - percentage1: A `Double` value representing the size of the first segment as a proportion (e.g., `0.6` for 60%).
///   - percentage2: A `Double` value representing the size of the second segment as a proportion (e.g., `0.4` for 40%).
///   - percent1Label: An optional `String` representing a custom label for the first segment. If `nil`, the percentage is displayed.
///   - percent2Label: An optional `String` representing a custom label for the second segment. If `nil`, the percentage is displayed.
///   - barHeight: The height of the bar chart. Defaults to `20`.
struct StatsView_Component_BarDistributionChart: View {
    
    // MARK: - Properties
    
    /// The percentage of the first segment (e.g., `0.6` for 60% of the total width).
    var percentage1: Double
    
    /// The percentage of the second segment (e.g., `0.4` for 40% of the total width).
    var percentage2: Double
    
    /// An optional label for the first segment. If `nil`, displays the calculated percentage.
    var percent1Label: String?
    
    /// An optional label for the second segment. If `nil`, displays the calculated percentage.
    var percent2Label: String?
    
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
                        Text(percent1Label ?? ValueConverter.doubleToPercent(percentage1)) // Displays a custom label or the calculated percentage.
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
                        Text(percent2Label ?? ValueConverter.doubleToPercent(percentage2)) // Displays a custom label or the calculated percentage.
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
    /// This initializer allows you to provide the primary percentage (`percentage1`), while the
    /// secondary percentage (`percentage2`) is automatically calculated as `1.0 - percentage1`.
    /// Additional customization options include specifying custom labels and setting the bar height.
    ///
    /// - Parameters:
    ///   - percentage1: The proportion of the first segment (e.g., `0.6` for 60%).
    ///   - barHeight: The height of the bar chart. Defaults to `20`.
    ///   - percent1Label: An optional custom label for the first segment. If `nil`, the percentage is displayed.
    ///   - percent2Label: An optional custom label for the second segment. If `nil`, the percentage is displayed.
    init(_ percentage1: Double, barHeight: CGFloat = 20, percent1Label: String? = nil, percent2Label: String? = nil) {
        self.percentage1 = percentage1
        self.percentage2 = 1.0 - percentage1 // Automatically calculates the second percentage.
        self.barHeight = barHeight
        self.percent1Label = percent1Label
        self.percent2Label = percent2Label
    }
}
