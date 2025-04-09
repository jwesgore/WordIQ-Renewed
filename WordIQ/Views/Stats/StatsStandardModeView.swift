import SwiftUI

/// View Container for Standard Mode Stats
struct StatsStandardModeView: View {
    
    @State var showStats: Bool = true
    @State var statsModel: StatsModel
    
    var body: some View {
        
        VStack (spacing: StatsViewHelper.vStackSpacing) {
            ExpandAndCollapseHeaderView(title: SystemNames.GameStats.standardModeStats, isExpanded: $showStats)
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
                    InfoItemView(icon: SFAssets.stats,
                                 label: SystemNames.GameStats.winPercentage,
                                 value: ValueConverter.doubleToPercent(statsModel.winRate))
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
                                 label: SystemNames.GameStats.currentStreak,
                                 value: statsModel.currentStreak.description)
                    Divider()
                    InfoItemView(icon: SFAssets.star,
                                 label: SystemNames.GameStats.bestStreak,
                                 value: statsModel.bestStreak.description)
                }
                .backgroundStyle(Color.appGroupBox)
            }
        }
    }
}

extension StatsStandardModeView {
    init(databaseHelper: GameDatabaseHelper) {
        statsModel = StatsModelFactory(databaseHelper: databaseHelper).getStatsModel(for: .standardMode)
    }
}
