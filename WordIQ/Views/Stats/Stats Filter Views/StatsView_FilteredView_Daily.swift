import SwiftUI

/// View Container for Daily Mode Stats
struct StatsView_FilteredView_Daily: View {
    
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
            
            // MARK: Streak Stats
            StatsView_Component_Label(
                label: "Current Streak",
                value: statsModel.currentStreak.description
            )
            StatsView_Component_Label(
                label: "Best Streak",
                value: statsModel.bestStreak.description
            )
            
            StatsView_Component_WinRatio(statsModel)
            
            StatsView_Component_GuessRatio(statsModel)
            
            StatsView_Component_GuessDistribution(statsModel)
        }
    }
}

// MARK: - Initializer

extension StatsView_FilteredView_Daily {
    /// Initializes the `StatsDailyModeView` with a database helper.
    /// - Parameter databaseHelper: The helper used to fetch and manage game stats.
    init(databaseHelper: GameDatabaseHelper) {
        statsModel = StatsModelFactory(databaseHelper: databaseHelper).getStatsModel(for: .dailyGame)
    }
}
