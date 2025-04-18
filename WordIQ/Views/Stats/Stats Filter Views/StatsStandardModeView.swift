import SwiftUI

/// View Container for Standard Mode Stats
struct StatsStandardModeView: View {
    
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
            
            // MARK: Game Counts
            StatsView_Component_Label(
                label: "Games",
                value: statsModel.totalGamesPlayed.description
            )

            StatsView_Component_Label(
                label: "Guesses Per Game",
                value: statsModel.averageGuessesPerGame.description
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
            
            StatsView_Component_WinDistribution(statsModel)
        }
    }
}

extension StatsStandardModeView {
    init(databaseHelper: GameDatabaseHelper) {
        statsModel = StatsModelFactory(databaseHelper: databaseHelper).getStatsModel(for: .standardMode)
    }
}
