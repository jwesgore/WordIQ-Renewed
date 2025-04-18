import SwiftUI
import Charts

/// View container for general statistics
struct StatsGeneralView : View {

    var databaseHelper: GameDatabaseHelper
    var statsModel: StatsModel
    
    var body: some View {
        let distribution = databaseHelper.getGameModeDistribution()
        let (totalGuesses, totalValidGuesses, totalInvalidGuesses) = databaseHelper.totalGuessesAll

        VStack {
            
            StatsView_Component_Label(label: "Time Played", value: TimeUtility.formatTimeAbbreviated(statsModel.totalTimePlayed))
            StatsView_Component_Label(label: "Games Played", value: statsModel.totalGamesPlayed.description)
            StatsView_Component_Label(label: "Guesses Made", value: statsModel.totalValidGuesses.description)
            
            
            // Mode Distribution
//            if statsModel.totalGamesPlayed > 0 {
//                if let favoriteMode = distribution.max(by: { $0.value < $1.value })?.key {
//                    StatsGameModeDistribution(distribution: distribution, favoriteMode: favoriteMode, totalGamesPlayed: statsModel.totalGamesPlayed)
//                }
//            }
//            
//            // Guesses
//            if (totalGuesses != 0) {
//                StatsTotalGuessesView(totalGuesses: totalGuesses, totalValidGuesses: totalValidGuesses, totalInvalidGuesses: totalInvalidGuesses)
//            }
        }
    }
}


extension StatsGeneralView {
    init (_ databaseHelper: GameDatabaseHelper) {
        self.databaseHelper = databaseHelper
        self.statsModel = databaseHelper.getGameStatistics(for: SDStandardGameResult.self)
    }
}
