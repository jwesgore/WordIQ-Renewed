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
            
            StatsView_Component_GuessDistribution(statsModel, endingIndex: 7, includePlus: true)
        }
    }
}


extension StatsView_FilteredView_General {
    init (_ databaseHelper: GameDatabaseHelper) {
        self.databaseHelper = databaseHelper
        self.statsModel = StatsModelFactory(databaseHelper: databaseHelper).getStatsModel()
    }
}
