import SwiftUI

/// View Container for Standard Mode Stats
struct StatsStandardModeView: View {
    
    var databaseHelper: GameDatabaseHelper
    
    var body: some View {
        // Header
        Text(SystemNames.GameStats.standardModeStats)
            .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title2)))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom)
    }
}
