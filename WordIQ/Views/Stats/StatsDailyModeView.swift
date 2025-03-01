import SwiftUI

/// View Container for Daily Mode Stats
struct StatsDailyModeView: View {
    
    var databaseHelper: GameDatabaseHelper
    
    var body: some View {
        let avgTimePerGame = TimeUtility.formatTimeShort(databaseHelper.getGameModeAvgTime(mode: .daily))
        let bestStreak = UserDefaultsHelper.shared.maxStreak_daily.description
        let currentSteak = UserDefaultsHelper.shared.currentStreak_daily.description
        
        let timeInMode = TimeUtility.formatTimeShort(databaseHelper.getGameModeTimePlayed(mode: .daily))
        let totalGamesPlayed = databaseHelper.getGameModeCount(mode: .daily).description
        let winPercentage = ValueConverter.DoubleToPercent(databaseHelper.getGameModeWinPercentage(mode: .daily))
        
        // Header
        Text(SystemNames.GameStats.dailyModeStats)
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
