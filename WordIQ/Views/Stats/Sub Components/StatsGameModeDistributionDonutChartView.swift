import SwiftUI
import Charts

struct StatsGameModeDistributionDonutChartView : View {
    var distribution: [GameMode: Int]
    
    var body: some View {
        Chart {
            SectorMark(angle: .value(GameMode.standardgame.value, distribution[GameMode.standardgame] ?? 0), innerRadius: .ratio(0.6))
                .foregroundStyle(by: .value("Name", GameMode.standardgame.value))
            
            SectorMark(angle: .value(GameMode.rushgame.value, distribution[GameMode.rushgame] ?? 0), innerRadius: .ratio(0.6))
                .foregroundStyle(by: .value("Name", GameMode.rushgame.value))
            
            SectorMark(angle: .value(GameMode.frenzygame.value, distribution[GameMode.frenzygame] ?? 0), innerRadius: .ratio(0.6))
                .foregroundStyle(by: .value("Name", GameMode.frenzygame.value))
            
            SectorMark(angle: .value(GameMode.zengame.value, distribution[GameMode.zengame] ?? 0), innerRadius: .ratio(0.6))
                .foregroundStyle(by: .value("Name", GameMode.zengame.value))
            
            SectorMark(angle: .value(GameMode.daily.value, distribution[GameMode.daily] ?? 0), innerRadius: .ratio(0.6))
                .foregroundStyle(by: .value("Name", GameMode.daily.value))
        }
    }
}
