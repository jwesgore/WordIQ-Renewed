import SwiftUI

/// View container for general statistics
struct StatsGeneralView : View {
    
    @State var showStats: Bool = true
    
    var databaseHelper: GameDatabaseHelper
    
    var body: some View {
        let totalGamesPlayed = databaseHelper.gameCount
        let totalTimePlayed = databaseHelper.totalTimePlayed
        let distribution = databaseHelper.getGameModeDistribution()
        let (totalGuesses, totalValidGuesses, totalInvalidGuesses) = databaseHelper.totalGuessesAll
        
        VStack (spacing: StatsViewHelper.vStackSpacing) {
            ExpandAndCollapseHeaderView(title: SystemNames.GameStats.generalStats, isExpanded: $showStats)
                .padding(.vertical, StatsViewHelper.baseHeaderPadding)
                .padding(.bottom, showStats ? StatsViewHelper.additionalHeaderPadding : 0)
            
            if showStats {
                VStack {
                    // Total Time Played
                    StatsTotalTimePlayedView(totalTimePlayed: totalTimePlayed, totalGamesPlayed: totalGamesPlayed)
                    
                    // Mode Distribution
                    if totalGamesPlayed > 0 {
                        if let favoriteMode = distribution.max(by: { $0.value < $1.value })?.key {
                            let donutChartView = StatsGameModeDistributionDonutChartView(distribution: distribution)
                            GroupBox {
                                VStack {
                                    HStack {
                                        // Favorite mode text
                                        HStack {
                                            Text("You play ") +
                                            Text(favoriteMode.asStringShort)
                                                .fontWeight(.semibold) +
                                            Text(" \(ValueConverter.intsToPercent(top: distribution[favoriteMode], bottom: totalGamesPlayed)) of the time making it your most played game mode!")
                                            Spacer()
                                        }
                                        .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.headline)))
                                        
                                        // Displays chart without legens
                                        donutChartView
                                            .frame(maxHeight: 150)
                                            .chartLegend(.hidden)
                                    }
                                    
                                    // Spreads the legend across the bottom
                                    donutChartView
                                        .frame(maxHeight: 0)
                                        .chartLegend(alignment: .center)
                                        .padding(.bottom)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .backgroundStyle(Color.appGroupBox)
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
