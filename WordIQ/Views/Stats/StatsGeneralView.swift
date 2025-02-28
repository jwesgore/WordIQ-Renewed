import SwiftUI

/// View container for general statistics
struct StatsGeneralView : View {
    
    var databaseHelper: GameDatabaseHelper
    
    var body: some View {
        let totalGamesPlayed = databaseHelper.gameCount
        let totalTimePlayed = databaseHelper.totalTimePlayed
        let distribution = databaseHelper.getGameModeDistribution()
        
        // Total Time Played
        StatsTotalTimePlayedView(totalTimePlayed: totalTimePlayed, totalGamesPlayed: totalGamesPlayed)
        
        // Mode Distribution
        GroupBox {
            HStack {
                if let favoriteMode = distribution.max(by: { $0.value < $1.value })?.key {
                    HStack {
                        Text("You play ") +
                        Text(favoriteMode.value)
                            .fontWeight(.semibold) +
                        Text(" \(ValueConverter.IntsToPercent(top: distribution[favoriteMode], bottom: totalGamesPlayed)) of the time making it your most played game mode!")
                        Spacer()
                    }
                    .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.headline)))
                }
                
                StatsGameModeDistributionDonutChartView(distribution: distribution)
                    .frame(maxHeight: 150)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
