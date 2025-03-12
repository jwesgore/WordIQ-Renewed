import SwiftUI

/// View Container for Daily Mode Stats
struct StatsDailyModeView: View {
    
    var databaseHelper: GameDatabaseHelper
    let mode = GameMode.daily
    
    var body: some View {
        let avgTimePerGame = TimeUtility.formatTimeShort(databaseHelper.getGameModeAvgTimePerGame(mode: mode))
        let bestStreak = UserDefaultsHelper.shared.maxStreak_daily.description
        let currentSteak = UserDefaultsHelper.shared.currentStreak_daily.description
        let guessesMade = databaseHelper.getGameModeNumGuesses(mode: mode).description
        let timeInMode = TimeUtility.formatTimeShort(databaseHelper.getGameModeTimePlayed(mode: mode))
        let totalGamesPlayed = databaseHelper.getGameModeCount(mode: mode).description
        let winPercentage = ValueConverter.DoubleToPercent(databaseHelper.getGameModeWinPercentage(mode: mode))
        
        // Header
        Text(SystemNames.GameStats.dailyModeStats)
            .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title2)))
            .frame(maxWidth: .infinity, alignment: .leading)
        
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
