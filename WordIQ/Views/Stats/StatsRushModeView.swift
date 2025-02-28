import SwiftUI

/// View Container for Rush Mode Stats
struct StatsRushModeView: View {
    
    var databaseHelper: GameDatabaseHelper
    
    var body: some View {
        // Header
        Text(SystemNames.GameStats.rushModeStats)
            .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title2)))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom)
    }
}
