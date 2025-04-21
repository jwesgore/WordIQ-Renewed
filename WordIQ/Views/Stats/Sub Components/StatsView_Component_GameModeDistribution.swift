import SwiftUI

struct StatsView_Component_GameModeDistribution : View {
    
    var modeDistribution: DefaultDictionary<GameMode, Int>
    
    private var barSize: Int {
        modeDistribution.getSumValues()
    }
    
    var body: some View {
        VStack (spacing: 8.0) {
            // Title Label
            StatsView_Component_Label(
                label: "Mode Distribution",
                value: ""
            )
            
            
        }
    }
}
