import SwiftUI

/// A view that displays the win distribution statistics, including total games played,
/// wins versus losses, and a bar chart representing the win percentage.
///
/// This component uses reusable subviews (`StatsView_Component_Label`,
/// `StatsView_Component_Label_Ratio`, and `StatsView_Component_BarDistributionChart`)
/// to provide a clear and visually appealing summary of win-related stats.
///
/// Example:
/// - Displays total games played.
/// - Shows the ratio of wins to losses.
/// - Includes a bar chart to visualize the win percentage.
///
/// - Parameters:
///   - totalWins: The total number of wins.
///   - totalLoses: The total number of losses.
struct StatsView_Component_WinRatio: View {
    
    // MARK: - Properties
    
    /// The total number of wins.
    var totalWins: Int
    
    /// The total number of losses.
    var totalLoses: Int
    
    /// Computes the total number of games by summing wins and losses.
    var totalGames: Int {
        return totalWins + totalLoses
    }
    
    /// Computes the win percentage relative to total games played.
    /// Returns 0.0 if there are no games to avoid division by zero.
    var winPercentage: Double {
        guard totalGames > 0 else { return 0.0 }
        return Double(totalWins) / Double(totalGames)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 8) {
            // Displays the total number of games played.
            StatsView_Component_Label(
                label: "Games Played",
                value: totalGames.description
            )
            
            // Displays the ratio of wins to losses.
            StatsView_Component_Label_Ratio(
                label1: "Wins",
                value1: totalWins.description,
                label2: "Loses",
                value2: totalLoses.description
            )
            
            // Displays a bar distribution chart for win percentage.
            StatsView_Component_BarDistributionChart(winPercentage)
        }
    }
}

// MARK: - Initializer

extension StatsView_Component_WinRatio {
    /// Initializes the `StatsView_Component_WinDistribution` using a `StatsModel` object.
    /// - Parameter statsModel: A model containing the total wins and losses.
    init(_ statsModel: StatsModel) {
        self.totalWins = statsModel.totalWins
        self.totalLoses = statsModel.totalLoses
    }
}
