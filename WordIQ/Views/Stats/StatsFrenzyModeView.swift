import SwiftUI

/// View Container for Frenzy Mode Stats
struct StatsFrenzyModeView: View {
    
    var databaseHelper: GameDatabaseHelper
    let mode = GameMode.frenzygame
    
    var body: some View {
        let avgTimePerWord = TimeUtility.formatTimeShort(databaseHelper.getGameModeAvgTimePerWord(mode: mode))
        let avgScore = databaseHelper.getGameModeAvgScore(mode: mode).description
        let bestScore = UserDefaultsHelper.shared.maxScore_frenzy.description
        let guessesMade = databaseHelper.getGameModeNumGuesses(mode: mode).description
        let timeInMode = TimeUtility.formatTimeShort(databaseHelper.getGameModeTimePlayed(mode: mode))
        let totalGamesPlayed = databaseHelper.getGameModeCount(mode: mode).description
        
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
            InfoItemView(image: SFAssets.numberSign,
                         label: SystemNames.GameStats.guessesMade,
                         value: guessesMade)
            Divider()
            InfoItemView(image: SFAssets.timer,
                         label: SystemNames.GameStats.timePlayed,
                         value: timeInMode)
            Divider()
            InfoItemView(image: SFAssets.timer,
                         label: SystemNames.GameStats.avgTimePerWord,
                         value: avgTimePerWord)
            Divider()
            InfoItemView(image: SFAssets.star,
                         label: SystemNames.GameStats.avgScore,
                         value: avgScore)
            Divider()
            InfoItemView(image: SFAssets.star,
                         label: SystemNames.GameStats.bestScore,
                         value: bestScore)
        }
    }
}
