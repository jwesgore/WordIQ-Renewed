import SwiftUI

/// A view that displays a horizontal bar chart split into two segments, visually representing two percentages.
///
/// This bar chart dynamically adjusts its layout using `GeometryReader` to fit the available width.
/// Each segment of the chart is styled and proportionally sized based on the provided percentages.
/// An optional custom view (`barHeader`) can be displayed on the left side of the chart, acting as a header or label.
///
/// ## Example
/// If `percentage1 = 0.6` and `percentage2 = 0.4`, the chart will:
/// - Allocate 60% of the width to the first segment.
/// - Allocate 40% of the width to the second segment.
/// - Display the default or custom labels for each percentage (if provided).
///
/// ## Customization
/// You can control the following aspects of the chart:
/// - **Bar Header**: Add a custom view on the left side of the chart (e.g., labels or icons) or omit it entirely by toggling `showHeader`.
/// - **Appearance**: Define colors and text styles for the bar segments using `Color.Charts.PercentDistribution`.
/// - **Labels**: Specify custom text labels for the segments or fall back to calculated percentage values.
/// - **Bar Height**: Set the height of the bar for greater flexibility.
///
/// ## Parameters
/// - `showHeader`: A `Bool` that determines whether to show the `barHeader` view. Defaults to `true`.
/// - `barHeader`: A custom view to be displayed to the left of the bar chart, serving as a header. Defaults to `EmptyView`.
/// - `headerWidth`: The width of the `barHeader` view. Defaults to `24`.
/// - `percentage1`: A `Double` value representing the size of the first segment as a proportion (e.g., `0.6` for 60%).
/// - `percentage2`: A `Double` value representing the size of the second segment as a proportion (e.g., `0.4` for 40%).
/// - `percent1Label`: An optional `String` label for the first segment. If `nil`, the percentage is displayed.
/// - `percent2Label`: An optional `String` label for the second segment. If `nil`, the percentage is displayed.
/// - `barHeight`: The height of the bar chart. Defaults to `20`.
struct StatsView_Component_BarDistributionChart<BarHeader: View>: View {
    
    // MARK: - Properties
    
    /// Whether to show the custom `barHeader` view. Defaults to `true`.
    var showHeader: Bool
    
    /// A custom view to display on the left side of the bar chart, acting as a header or label.
    var barHeader: BarHeader
    
    /// The width of the custom header view. Defaults to `24`.
    var headerWidth: CGFloat
    
    /// The percentage of the first segment (e.g., `0.6` for 60% of the total width).
    var percentage1: Double
    
    /// The percentage of the second segment (e.g., `0.4` for 40% of the total width).
    var percentage2: Double
    
    /// An optional label for the first segment. If `nil`, displays the calculated percentage.
    var percent1Label: String?
    
    /// An optional label for the second segment. If `nil`, displays the calculated percentage.
    var percent2Label: String?
    
    /// The height of the bar chart. Defaults to `20`.
    var barHeight: CGFloat

    // MARK: - Body
    
    var body: some View {
        HStack (spacing: 8.0) {
            if showHeader {
                // Optional header or label on the left
                barHeader
                    .frame(width: headerWidth, height: barHeight, alignment: .trailing)
            }
            
            // Main bar chart with GeometryReader
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    // First segment
                    Rectangle()
                        .fill(Color.Charts.PercentDistribution.background1)
                        .frame(width: geometry.size.width * percentage1, height: barHeight)
                        .overlay(
                            Text(percent1Label ?? ValueConverter.doubleToPercent(percentage1)) // Display custom or calculated label.
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
                            Text(percent2Label ?? ValueConverter.doubleToPercent(percentage2)) // Display custom or calculated label.
                                .foregroundColor(Color.Charts.PercentDistribution.text2)
                                .robotoSlabFont(.caption, .regular)
                                .padding(.trailing, 5),
                            alignment: .trailing
                        )
                }
                .cornerRadius(barHeight / 2) // Adds rounded corners to the bar.
            }
            .frame(height: barHeight) // Ensures the bar chart height matches the specified value.
        }
        .frame(height: barHeight)
    }
}

// MARK: - Initializer

extension StatsView_Component_BarDistributionChart {
    /// Initializes the bar chart with a primary percentage, automatically calculating the second percentage.
    ///
    /// This initializer allows you to optionally include a custom header view by toggling `showHeader`.
    /// - Parameters:
    ///   - showHeader: Whether to display the `barHeader` view. Defaults to `true`.
    ///   - percentage1: The proportion of the first segment (e.g., `0.6` for 60%).
    ///   - barHeight: The height of the bar chart. Defaults to `20`.
    ///   - percent1Label: An optional custom label for the first segment. If `nil`, the percentage is displayed.
    ///   - percent2Label: An optional custom label for the second segment. If `nil`, the percentage is displayed.
    ///   - headerWidth: The width of the `barHeader` view. Defaults to `24`.
    ///   - barHeader: A custom view for the left side of the chart, serving as a header. Defaults to an empty `Text`.
    init(
        showHeader: Bool = true,
        _ percentage1: Double,
        barHeight: CGFloat = 20,
        percent1Label: String? = nil,
        percent2Label: String? = nil,
        headerWidth: CGFloat = 24,
        @ViewBuilder barHeader: () -> BarHeader = { Text("") }
    ) {
        self.showHeader = showHeader
        self.percentage1 = percentage1
        self.percentage2 = 1.0 - percentage1 // Automatically calculate the second percentage.
        self.barHeight = barHeight
        self.percent1Label = percent1Label
        self.percent2Label = percent2Label
        self.headerWidth = headerWidth
        self.barHeader = barHeader()
    }
}
