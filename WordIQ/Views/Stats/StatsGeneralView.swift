import SwiftUI
import Charts

/// View container for general statistics
struct StatsGeneralView : View {
    @State var showStats: Bool = true
    
    var databaseHelper: GameDatabaseHelper
    var statsModel: StatsModel
    
    var body: some View {
        let distribution = databaseHelper.getGameModeDistribution()
        let (totalGuesses, totalValidGuesses, totalInvalidGuesses) = databaseHelper.totalGuessesAll
        
        VStack (spacing: StatsViewHelper.vStackSpacing) {
            ExpandAndCollapseHeaderView(title: SystemNames.GameStats.generalStats, isExpanded: $showStats)
                .padding(.vertical, StatsViewHelper.baseHeaderPadding)
                .padding(.bottom, showStats ? StatsViewHelper.additionalHeaderPadding : 0)
            
            if showStats {
                VStack {
                    // Total Time Played
                    StatsTotalTimePlayedView(totalTimePlayed: statsModel.totalTimePlayed, totalGamesPlayed: statsModel.totalGamesPlayed)
                    
                    // Mode Distribution
                    if statsModel.totalGamesPlayed > 0 {
                        if let favoriteMode = distribution.max(by: { $0.value < $1.value })?.key {
                            StatsGameModeDistribution(distribution: distribution, favoriteMode: favoriteMode, totalGamesPlayed: statsModel.totalGamesPlayed)
                        }
                    }
                    
                    // Guesses
                    if (totalGuesses != 0) {
                        StatsTotalGuessesView(totalGuesses: totalGuesses, totalValidGuesses: totalValidGuesses, totalInvalidGuesses: totalInvalidGuesses)
                    }
                }
            }
        }
    }
}

extension StatsGeneralView {
    init (_ databaseHelper: GameDatabaseHelper) {
        self.databaseHelper = databaseHelper
        self.statsModel = databaseHelper.getGameStatistics(for: CDGameResultsModel.self)
    }
}
