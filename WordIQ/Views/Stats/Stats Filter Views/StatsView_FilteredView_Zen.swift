import SwiftUI

/// View Container for Zen Mode Stats
struct StatsView_FilteredView_Zen: View {
    
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

            StatsView_Component_GuessRatio(statsModel)
            
            StatsView_Component_GuessDistribution(statsModel, includePlus: true)
        }
    }
}

extension StatsView_FilteredView_Zen {
    init(databaseHelper: GameDatabaseHelper) {
        statsModel = StatsModelFactory(databaseHelper: databaseHelper).getStatsModel(for: .zenMode)
    }
}
