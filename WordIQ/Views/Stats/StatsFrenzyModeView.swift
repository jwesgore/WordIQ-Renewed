import SwiftUI

/// View Container for Frenzy Mode Stats
struct StatsFrenzyModeView: View {
    
    @State var showStats: Bool = true
    @State var statsModel: StatsModel
    
    var body: some View {

        VStack (spacing: StatsViewHelper.vStackSpacing) {
            ExpandAndCollapseHeaderView(title: SystemNames.GameStats.frenzyModeStats, isExpanded: $showStats)
                .padding(.vertical, StatsViewHelper.baseHeaderPadding)
                .padding(.bottom, showStats ? StatsViewHelper.additionalHeaderPadding : 0)
            
            if showStats {
                GroupBox {
                    InfoItemView(icon: SFAssets.numberSign,
                                 label: SystemNames.GameStats.gamesPlayed,
                                 value: statsModel.totalGamesPlayed.description)
                    Divider()
                    InfoItemView(icon: SFAssets.numberSign,
                                 label: SystemNames.GameStats.guessesMade,
                                 value: statsModel.totalValidGuesses.description)
                    Divider()
                    InfoItemView(icon: SFAssets.timer,
                                 label: SystemNames.GameStats.timePlayed,
                                 value: TimeUtility.formatTimeShort(statsModel.totalTimePlayed))
                    Divider()
                    InfoItemView(icon: SFAssets.timer,
                                 label: SystemNames.GameStats.avgTime,
                                 value: TimeUtility.formatTimeShort(statsModel.averageTimePerGame))
                    Divider()
                    InfoItemView(icon: SFAssets.star,
                                 label: SystemNames.GameStats.avgScore,
                                 value: "Temp")
                    Divider()
                    InfoItemView(icon: SFAssets.star,
                                 label: SystemNames.GameStats.bestScore,
                                 value: "Temp")
                }
                .backgroundStyle(Color.appGroupBox)
            }
        }
    }
}

extension StatsFrenzyModeView {
    init(databaseHelper: GameDatabaseHelper) {
        statsModel = StatsModelFactory(databaseHelper: databaseHelper).getStatsModel(for: .frenzyMode)
    }
}
