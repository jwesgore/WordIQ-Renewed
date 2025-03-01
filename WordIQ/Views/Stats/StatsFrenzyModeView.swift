import SwiftUI

/// View Container for Frenzy Mode Stats
struct StatsFrenzyModeView: View {
    
    var databaseHelper: GameDatabaseHelper
    
    var body: some View {
        let avgTimePerGame = TimeUtility.formatTimeShort(databaseHelper.getGameModeAvgTime(mode: .frenzygame))
        let timeInMode = TimeUtility.formatTimeShort(databaseHelper.getGameModeTimePlayed(mode: .frenzygame))
        let totalGamesPlayed = databaseHelper.getGameModeCount(mode: .frenzygame).description
        
        // Header
        Text(SystemNames.GameStats.frenzyModeStats)
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
