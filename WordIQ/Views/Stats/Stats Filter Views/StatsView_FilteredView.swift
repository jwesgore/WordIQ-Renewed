import SwiftUI
import Charts

/// View container for general statistics
struct StatsView_FilteredView : View {

    var databaseHelper: GameDatabaseClient
    @State var statsModel: StatsModel
    @Binding var activeFilter: StatsView_Filter_Enum
    
    var body: some View {
        VStack (spacing: 8.0) {

            StatsView_Component_Label(label: "Games Played", value: statsModel.totalGamesPlayed.description)
            StatsView_Component_Label(label: "Time Played",
                                      value: TimeUtility.formatTimeAbbreviated(statsModel.totalTimePlayed, lowercased: true, concat: true))
            StatsView_Component_Label(label: "Time Per Game",
                                      value: TimeUtility.formatTimeAbbreviated(statsModel.averageTimePerGame, lowercased: true, concat: true))
    
            if activeFilter.isWinnable {
                StatsView_Component_Label_Ratio(label1: "Streak",
                                                value1: statsModel.currentStreak.description,
                                                label2: "Best",
                                                value2: statsModel.bestStreak.description)
                
                StatsView_Component_WinRatio(statsModel)
            }
            
            StatsView_Component_GuessRatio(statsModel)
            
            StatsView_Component_GuessDistribution(statsModel,
                                                  startingIndex: activeFilter.guessStartIndex,
                                                  endingIndex: activeFilter.guessEndIndex,
                                                  includePlus: activeFilter.guessIncludePlus)
        }
        .onChange(of: activeFilter) { oldValue, newValue in
            Task {
                if newValue == .all {
                    self.statsModel = StatsModelFactory(databaseHelper: databaseHelper).getStatsModel()
                } else {
                    self.statsModel = StatsModelFactory(databaseHelper: databaseHelper).getStatsModel(for: newValue.asGameMode)
                }
            }
        }
    }
}


extension StatsView_FilteredView {
    init (_ databaseHelper: GameDatabaseClient, filter: Binding<StatsView_Filter_Enum>) {
        self.databaseHelper = databaseHelper
        self.statsModel = StatsModelFactory(databaseHelper: databaseHelper).getStatsModel()
        self._activeFilter = filter
    }
}
