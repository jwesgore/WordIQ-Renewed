import SwiftUI

/// View Container for Daily Mode Stats
struct StatsDailyModeView: View {
    
    // MARK: - State Properties
    /// The model providing the stats data for this view.
    @State var statsModel: StatsModel
    
    // MARK: - View Layout
    
    var body: some View {
        VStack(spacing: 8) {
            // MARK: Time-related Stats
            StatsView_Component_Label(
                label: "Time Played",
                value: TimeUtility.formatTimeAbbreviated(statsModel.totalTimePlayed, lowercased: true, concat: true)
            )
            StatsView_Component_Label(
                label: "Time Per Game",
                value: TimeUtility.formatTimeShort(statsModel.averageTimePerGame)
            )
            
            // MARK: Game Counts
            StatsView_Component_Label(
                label: "Games",
                value: statsModel.totalGamesPlayed.description
            )
            StatsView_Component_Label(
                label: "Guesses",
                value: statsModel.totalValidGuesses.description
            )
            StatsView_Component_Label(
                label: "Guesses Per Game",
                value: statsModel.averageGuessesPerGame.description
            )
            
            // MARK: Performance Stats
            StatsView_Component_Label(
                label: "Wins",
                value: statsModel.totalWins.description
            )
            StatsView_Component_Label(
                label: "Win %",
                value: ValueConverter.doubleToPercent(statsModel.winRate, includeSign: false)
            )
            
            // MARK: Streak Stats
            StatsView_Component_Label(
                label: "Current Streak",
                value: statsModel.currentStreak.description
            )
            StatsView_Component_Label(
                label: "Best Streak",
                value: statsModel.bestStreak.description
            )
            
            StatsView_Component_GuessDistribution(statsModel)
        }
    }
}

// MARK: - Initializer

extension StatsDailyModeView {
    /// Initializes the `StatsDailyModeView` with a database helper.
    /// - Parameter databaseHelper: The helper used to fetch and manage game stats.
    init(databaseHelper: GameDatabaseHelper) {
        statsModel = StatsModelFactory(databaseHelper: databaseHelper).getStatsModel(for: .dailyGame)
    }
}
