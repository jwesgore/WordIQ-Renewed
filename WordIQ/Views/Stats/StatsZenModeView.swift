import SwiftUI

/// View Container for Zen Mode Stats
struct StatsZenModeView: View {
    
    @State var showStats: Bool = true
    
    var databaseHelper: GameDatabaseHelper
    let mode = GameMode.zenMode
    
    var body: some View {
        let avgTimePerGame = TimeUtility.formatTimeShort(databaseHelper.getGameModeAvgTimePerGame(mode: mode))
        let guessesMade = databaseHelper.getGameModeNumGuesses(mode: mode).description
        let timeInMode = TimeUtility.formatTimeShort(databaseHelper.getGameModeTimePlayed(mode: mode))
        let totalGamesPlayed = databaseHelper.getGameModeCount(mode: mode).description
        
        VStack (spacing: StatsViewHelper.vStackSpacing) {
            ExpandAndCollapseHeaderView(title: SystemNames.GameStats.zenModeStats, isExpanded: $showStats)
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
                    InfoItemView(icon: SFAssets.timer,
                                 label: SystemNames.GameStats.timePlayed,
                                 value: timeInMode)
                    Divider()
                    InfoItemView(icon: SFAssets.timer,
                                 label: SystemNames.GameStats.avgTime,
                                 value: avgTimePerGame)
                }
                .backgroundStyle(Color.appGroupBox)
            }
        }
    }
}
