import SwiftUI

/// View Container for Zen Mode Stats
struct StatsZenModeView: View {
    
    var databaseHelper: GameDatabaseHelper
    
    var body: some View {
        let avgTimePerGame = TimeUtility.formatTimeShort(databaseHelper.getGameModeAvgTime(mode: .zengame))
        let timeInMode = TimeUtility.formatTimeShort(databaseHelper.getGameModeTimePlayed(mode: .zengame))
        let totalGamesPlayed = databaseHelper.getGameModeCount(mode: .zengame).description
        
        // Header
        Text(SystemNames.GameStats.zenModeStats)
            .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title2)))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom)
        
        GroupBox {
            InfoItemView(image: SFAssets.numberSign,
                         label: SystemNames.GameStats.gamesPlayed,
                         value: totalGamesPlayed)
            Divider()
            InfoItemView(image: SFAssets.timer,
                         label: SystemNames.GameStats.timePlayed,
                         value: timeInMode)
            Divider()
            InfoItemView(image: SFAssets.timer,
                         label: SystemNames.GameStats.avgTime,
                         value: avgTimePerGame)
        }
    }
}
