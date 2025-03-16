import SwiftUI
import Charts

struct StatsGameModeDistributionDonutChartView : View {
    var distribution: [GameMode: Int]
    
    var body: some View {
        Chart {
            SectorMark(angle: .value(GameMode.standardMode.asStringShort, distribution[GameMode.standardMode] ?? 0), innerRadius: .ratio(0.6))
                .foregroundStyle(by: .value("Name", GameMode.standardMode.asStringShort))
            
            SectorMark(angle: .value(GameMode.rushMode.asStringShort, distribution[GameMode.rushMode] ?? 0), innerRadius: .ratio(0.6))
                .foregroundStyle(by: .value("Name", GameMode.rushMode.asStringShort))
            
            SectorMark(angle: .value(GameMode.frenzyMode.asStringShort, distribution[GameMode.frenzyMode] ?? 0), innerRadius: .ratio(0.6))
                .foregroundStyle(by: .value("Name", GameMode.frenzyMode.asStringShort))
            
            SectorMark(angle: .value(GameMode.zenMode.asStringShort, distribution[GameMode.zenMode] ?? 0), innerRadius: .ratio(0.6))
                .foregroundStyle(by: .value("Name", GameMode.zenMode.asStringShort))
            
            SectorMark(angle: .value(GameMode.dailyGame.asStringShort, distribution[GameMode.dailyGame] ?? 0), innerRadius: .ratio(0.6))
                .foregroundStyle(by: .value("Name", GameMode.dailyGame.asStringShort))
        }
    }
}
