import SwiftUI

/// View Container for Standard Mode Stats
struct StatsStandardModeView: View {
    
    @State var showStats: Bool = true
    
    var databaseHelper: GameDatabaseHelper
    let mode = GameMode.standardMode
    
    var body: some View {
        let avgTimePerGame = TimeUtility.formatTimeShort(databaseHelper.getGameModeAvgTimePerGame(mode: mode))
        let bestStreak = UserDefaultsHelper.shared.maxStreak_standard.description
        let currentSteak = UserDefaultsHelper.shared.currentStreak_standard.description
        let guessesMade = databaseHelper.getGameModeNumGuesses(mode: mode).description
        let timeInMode = TimeUtility.formatTimeShort(databaseHelper.getGameModeTimePlayed(mode: mode))
        let totalGamesPlayed = databaseHelper.getGameModeCount(mode: mode).description
        let winPercentage = ValueConverter.doubleToPercent(databaseHelper.getGameModeWinPercentage(mode: mode))
        
        VStack (spacing: StatsViewHelper.vStackSpacing) {
            ExpandAndCollapseHeaderView(title: SystemNames.GameStats.standardModeStats, isExpanded: $showStats)
                .padding(.vertical, StatsViewHelper.baseHeaderPadding)
                .padding(.bottom, showStats ? StatsViewHelper.additionalHeaderPadding : 0)
            
            if showStats {
                GroupBox {
                    InfoItemView(icon: SFAssets.numberSign,
                                 label: SystemNames.GameStats.gamesPlayed,
                                 value: totalGamesPlayed)
                    Divider()
                    InfoItemView(icon: SFAssets.numberSign,
                                 label: SystemNames.GameStats.guessesMade,
                                 value: guessesMade)
                    Divider()
                    InfoItemView(icon: SFAssets.stats,
                                 label: SystemNames.GameStats.winPercentage,
                                 value: winPercentage)
                    Divider()
                    InfoItemView(icon: SFAssets.timer,
                                 label: SystemNames.GameStats.timePlayed,
                                 value: timeInMode)
                    Divider()
                    InfoItemView(icon: SFAssets.timer,
                                 label: SystemNames.GameStats.avgTime,
                                 value: avgTimePerGame)
                    Divider()
                    InfoItemView(icon: SFAssets.star,
                                 label: SystemNames.GameStats.currentStreak,
                                 value: currentSteak)
                    Divider()
                    InfoItemView(icon: SFAssets.star,
                                 label: SystemNames.GameStats.bestStreak,
                                 value: bestStreak)
                }
                .backgroundStyle(Color.appGroupBox)
            }
        }
    }
}
