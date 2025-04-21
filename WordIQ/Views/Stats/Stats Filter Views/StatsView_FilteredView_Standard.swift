import SwiftUI

/// View Container for Standard Mode Stats
struct StatsView_FilteredView_Standard: View {
    
    @State var statsModel: StatsModel
    
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

extension StatsView_FilteredView_Standard {
    init(databaseHelper: GameDatabaseClient) {
        statsModel = StatsModelFactory(databaseHelper: databaseHelper).getStatsModel(for: .standardMode)
    }
}
