import SwiftUI

/// A view that displays guess distribution statistics, including total guesses,
/// valid vs. invalid guesses, and a bar chart representing the distribution.
///
/// This component uses other reusable components (`StatsView_Component_Label`,
/// `StatsView_Component_Label_Ratio`, and `StatsView_Component_BarDistributionChart`)
/// to display formatted statistics in a visually appealing layout.
///
/// Example: Displays the total guesses, a ratio of valid to invalid guesses, and
/// a horizontal bar chart showing the percentage of valid guesses.
///
/// - Parameters:
///   - totalValidGuesses: The total number of valid guesses.
///   - totalInvalidGuesses: The total number of invalid guesses.
struct StatsView_Component_GuessRatio: View {
    
    // MARK: - Properties
    
    /// The total number of valid guesses.
    var totalValidGuesses: Int
    
    /// The total number of invalid guesses.
    var totalInvalidGuesses: Int
    
    /// Computes the total number of guesses by summing valid and invalid guesses.
    var totalGuesses: Int {
        return totalValidGuesses + totalInvalidGuesses
    }
    
    /// Computes the percentage of valid guesses relative to total guesses.
    /// Returns 0.0 if the total number of guesses is 0 to avoid division by zero.
    var validGuessesPercentage: Double {
        guard totalGuesses > 0 else { return 0.0 }
        return Double(totalValidGuesses) / Double(totalGuesses)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 8) {
            // Displays the total number of guesses.
            StatsView_Component_Label(
                label: "Guesses",
                value: totalGuesses.description
            )
            
            // Displays the ratio of valid to invalid guesses.
            StatsView_Component_Label_Ratio(
                label1: "Valid",
                value1: totalValidGuesses.description,
                label2: "Invalid",
                value2: totalInvalidGuesses.description
            )
            
            // Displays a bar distribution chart for valid guesses.
            StatsView_Component_BarDistributionChart(validGuessesPercentage)
        }
    }
}

// MARK: - Initializer

extension StatsView_Component_GuessRatio {
    /// Initializes the `StatsView_Component_GuessDistribution` using a `StatsModel` object.
    /// - Parameter statsModel: A model containing the total valid and invalid guesses.
    init(_ statsModel: StatsModel) {
        self.totalValidGuesses = statsModel.totalValidGuesses
        self.totalInvalidGuesses = statsModel.totalInvalidGuesses
    }
}
