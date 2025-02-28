import SwiftUI

/// View Container for Zen Mode Stats
struct StatsZenModeView: View {
    
    var databaseHelper: GameDatabaseHelper
    
    var body: some View {
        // Header
        Text(SystemNames.GameStats.zenModeStats)
            .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title2)))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom)
    }
}
