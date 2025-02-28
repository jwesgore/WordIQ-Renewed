import SwiftUI

/// View Container for Daily Mode Stats
struct StatsDailyModeView: View {
    
    var databaseHelper: GameDatabaseHelper
    
    var body: some View {
        // Header
        Text(SystemNames.GameStats.dailyModeStats)
            .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title2)))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom)
    }
}
