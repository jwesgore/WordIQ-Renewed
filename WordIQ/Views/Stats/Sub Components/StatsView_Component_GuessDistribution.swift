import SwiftUI

/// A view that displays a guess distribution chart with rows representing the number of guesses.
///
/// Each row corresponds to a specific index (e.g., startingIndex to endingIndex), showing the guess count for that index
/// as a bar chart. Optionally, the chart can include a summary "+" row for values beyond `endingIndex`
/// when `includePlus` is set to `true`.
///
/// ## Features
/// - Dynamically generates rows based on the provided range (`startingIndex` to `endingIndex`).
/// - Adjusts bar sizes proportionally using `normalizeValue` to ensure consistent scaling.
/// - Optional summary row for values exceeding `endingIndex`.
///
/// ## Parameters
/// - `guessDistribution`: A `DefaultDictionary` mapping indices to guess counts.
/// - `startingIndex`: The starting index of the chart rows. Defaults to `1`.
/// - `endingIndex`: The ending index of the chart rows. Defaults to `6`.
/// - `includePlus`: Whether to include a summary row for indices beyond `endingIndex`. Defaults to `false`.
///
/// ## Example Usage
/// ```swift
/// let guessDistribution = DefaultDictionary<Int, Int>(defaultValue: 0)
/// guessDistribution[1] = 10
/// guessDistribution[2] = 15
/// guessDistribution[3] = 5
///
/// StatsView_Component_GuessDistribution(guessDistribution: guessDistribution, startingIndex: 1, endingIndex: 5, includePlus: true)
/// ```
///
/// - Note: This component depends on other subviews (`StatsView_Component_Label`, `StatsView_Component_GuessDistribution_Row`, and `StatsView_Component_BarDistributionChart`).
struct StatsView_Component_GuessDistribution: View {
    
    // MARK: - Properties
    
    /// A dictionary mapping guess counts to their corresponding rows.
    var guessDistribution: DefaultDictionary<Int, Int>
    
    /// The starting index for the chart rows.
    var startingIndex: Int = 1
    
    /// The ending index for the chart rows.
    var endingIndex: Int = 6
    
    /// Whether to include a summary "+" row for values exceeding `endingIndex`.
    var includePlus: Bool = false
    
    /// Normalized value for scaling bar sizes, based on the maximum value in the chart.
    var normalizeValue: Int {
        includePlus ?
        max(guessDistribution.sumValues(forKeysGreaterThan: endingIndex), 5) :
        max(guessDistribution.getMax()?.value ?? 0, 5)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 8.0) {
            // Title Label
            StatsView_Component_Label(
                label: "Guess Distribution",
                value: ""
            )
            
            // Generate rows dynamically based on the range
            ForEach(startingIndex...endingIndex, id: \.self) { index in
                StatsView_Component_GuessDistribution_Row(
                    index: index,
                    guessDistribution: guessDistribution,
                    normalizeValue: normalizeValue,
                    includePlus: includePlus && (index == endingIndex)
                )
            }
        }
    }
}

// MARK: - Subview: Guess Distribution Row

/// A row in the guess distribution chart, displaying a label and a bar chart.
///
/// Each row shows the number of guesses for a given index. Optionally, a "+" row
/// can summarize guess counts for indices greater than the current index.
///
/// ## Parameters
/// - `index`: The index of the row.
/// - `guessDistribution`: The dictionary containing guess counts.
/// - `normalizeValue`: The value used to normalize bar sizes. Defaults to `5`.
/// - `includePlus`: Whether this row is a "+" summary row. Defaults to `false`.
struct StatsView_Component_GuessDistribution_Row: View {
    
    // MARK: - Properties
    
    /// The index of the current row.
    var index: Int
    
    /// The dictionary mapping indices to guess counts.
    var guessDistribution: DefaultDictionary<Int, Int>
    
    /// The value used to normalize bar sizes. Defaults to `5`.
    var normalizeValue: Int = 5
    
    /// Whether this row is a "+" summary row.
    var includePlus: Bool = false
    
    // MARK: - Computed Properties
    
    /// The label displayed on the row.
    private var label: Int {
        includePlus ?
        guessDistribution.sumValues(forKeysGreaterThan: index - 1) :
        guessDistribution[index]
    }
    
    /// The size of the bar for this row, normalized to `normalizeValue`.
    private var barSize: Double {
        includePlus ?
        max(Double(guessDistribution.sumValues(forKeysGreaterThan: index - 1)) / Double(normalizeValue), 0.05) :
        max(Double(guessDistribution[index]) / Double(normalizeValue), 0.05)
    }
    
    // MARK: - Body
    var body: some View {
        StatsView_Component_BarDistributionChart(barSize, percent1Label: "\(label)", percent2Label: "") {
            Text("\(includePlus ? "+" : "" )\(index)")
                .robotoSlabFont(.headline, .regular)
        }
    }
}

// MARK: - Extension: Convenience Initializer

extension StatsView_Component_GuessDistribution {
    /// Convenience initializer for creating a guess distribution chart from a `StatsModel`.
    ///
    /// - Parameters:
    ///   - statsModel: A `StatsModel` containing the guess distribution data.
    ///   - startingIndex: The starting index for the chart rows. Defaults to `1`.
    ///   - endingIndex: The ending index for the chart rows. Defaults to `6`.
    ///   - includePlus: Whether to include a summary "+" row. Defaults to `false`.
    init(_ statsModel: StatsModel, startingIndex: Int = 1, endingIndex: Int = 6, includePlus: Bool = false) {
        self.guessDistribution = statsModel.guessDistribution
        self.startingIndex = startingIndex
        self.endingIndex = endingIndex
        self.includePlus = includePlus
    }
}
