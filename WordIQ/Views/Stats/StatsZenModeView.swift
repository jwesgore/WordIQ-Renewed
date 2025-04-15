import SwiftUI

/// View Container for Zen Mode Stats
struct StatsZenModeView: View {
    
    @State var showStats: Bool = true
    @State var statsModel: StatsModel
    
    var body: some View {

        VStack (spacing: StatsViewHelper.vStackSpacing) {
            ExpandAndCollapseHeaderView(title: SystemNames.GameStats.zenModeStats, isExpanded: $showStats)
                .padding(.vertical, StatsViewHelper.baseHeaderPadding)
                .padding(.bottom, showStats ? StatsViewHelper.additionalHeaderPadding : 0)
            
            if showStats {
                GroupBox {
                    InfoItemView(icon: SFAssets.numberSign.rawValue,
                                 label: SystemNames.GameStats.gamesPlayed,
                                 value: statsModel.totalGamesPlayed.description)
                    Divider()
                    InfoItemView(icon: SFAssets.numberSign.rawValue,
                                 label: SystemNames.GameStats.guessesMade,
                                 value: statsModel.totalValidGuesses.description)
                    Divider()
                    InfoItemView(icon: SFAssets.timer.rawValue,
                                 label: SystemNames.GameStats.timePlayed,
                                 value: TimeUtility.formatTimeShort(statsModel.totalTimePlayed))
                    Divider()
                    InfoItemView(icon: SFAssets.timer.rawValue,
                                 label: SystemNames.GameStats.avgTime,
                                 value: TimeUtility.formatTimeShort(statsModel.averageTimePerGame))
                }
                .backgroundStyle(Color.appGroupBox)
            }
        }
    }
}

extension StatsZenModeView {
    init(databaseHelper: GameDatabaseHelper) {
        statsModel = StatsModelFactory(databaseHelper: databaseHelper).getStatsModel(for: .zenMode)
    }
}
