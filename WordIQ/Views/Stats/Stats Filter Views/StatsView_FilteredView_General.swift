import SwiftUI
import Charts

/// View container for general statistics
struct StatsView_FilteredView_General : View {

    var databaseHelper: GameDatabaseHelper
    var statsModel: StatsModel
    
    var body: some View {
        let distribution = databaseHelper.getGameModeDistribution()

        VStack (spacing: 8.0) {
            
            StatsView_Component_Label(label: "Time Played", value: TimeUtility.formatTimeAbbreviated(statsModel.totalTimePlayed, lowercased: true, concat: true))
            StatsView_Component_Label(label: "Games Played", value: statsModel.totalGamesPlayed.description)
            
            StatsView_Component_GuessRatio(statsModel)
            
            StatsView_Component_GuessDistribution(statsModel, maxRows: 7, includePlus: true)
            
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


extension StatsView_FilteredView_General {
    init (_ databaseHelper: GameDatabaseHelper) {
        self.databaseHelper = databaseHelper
        self.statsModel = StatsModelFactory(databaseHelper: databaseHelper).getStatsModel()
    }
}
