import SwiftUI

/// View Container for Standard Mode Stats
struct StatsStandardModeView: View {
    
    var databaseHelper: GameDatabaseHelper
    
    var body: some View {
        let avgTimePerGame = TimeUtility.formatTimeShort(databaseHelper.getGameModeAvgTime(mode: .standardgame))
        let bestStreak = UserDefaultsHelper.shared.maxStreak_standard.description
        let currentSteak = UserDefaultsHelper.shared.currentStreak_standard.description
        
        let timeInMode = TimeUtility.formatTimeShort(databaseHelper.getGameModeTimePlayed(mode: .standardgame))
        let totalGamesPlayed = databaseHelper.getGameModeCount(mode: .standardgame).description
        let winPercentage = ValueConverter.DoubleToPercent(databaseHelper.getGameModeWinPercentage(mode: .standardgame))
        
        // Header
        Text(SystemNames.GameStats.standardModeStats)
            .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title2)))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom)
        
        GroupBox {
            InfoItemView(image: SFAssets.numberSign,
                         label: SystemNames.GameStats.gamesPlayed,
                         value: totalGamesPlayed)
            Divider()
            InfoItemView(image: SFAssets.stats,
                         label: SystemNames.GameStats.winPercentage,
                         value: winPercentage)
            Divider()
            InfoItemView(image: SFAssets.timer,
                         label: SystemNames.GameStats.timePlayed,
                         value: timeInMode)
            Divider()
            InfoItemView(image: SFAssets.timer,
                         label: SystemNames.GameStats.avgTime,
                         value: avgTimePerGame)
            Divider()
            InfoItemView(image: SFAssets.star,
                         label: SystemNames.GameStats.currentStreak,
                         value: currentSteak)
            Divider()
            InfoItemView(image: SFAssets.star,
                         label: SystemNames.GameStats.bestStreak,
                         value: bestStreak)
        }
    }
}
