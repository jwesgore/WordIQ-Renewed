import SwiftUI
import Charts

struct StatsGameModeDistribution : View {
    
    var distribution: [GameMode: Int]
    var favoriteMode: GameMode
    var totalGamesPlayed: Int
    
    var body: some View {
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
                    .font(.custom(RobotoSlabOptions.Weight.regular, fixedSize: CGFloat(RobotoSlabOptions.Size.headline)))
                    
                    // Displays chart without legends
                    donutChartView
                        .frame(maxHeight: 150)
                        .chartLegend(.hidden)
                }
                
                // Spreads the legend across the bottom
                donutChartView
                    .frame(maxWidth: .infinity, maxHeight: 0)
                    .chartLegend(alignment: .center) {
                        HStack {
                            distributionChartLegend(.dailyGame)
                            distributionChartLegend(.standardMode)
                            distributionChartLegend(.rushMode)
                            distributionChartLegend(.frenzyMode)
                            distributionChartLegend(.zenMode)
                        }
                    }
                    .padding(.bottom)
            }
        }
        .frame(maxWidth: .infinity)
        .backgroundStyle(Color.appGroupBox)
    }
}


private struct distributionChartLegend: View {
    
    let gameMode: GameMode
    
    init(_ gameMode: GameMode) {
        self.gameMode = gameMode
    }
    
    var body: some View {
        HStack {
            BasicChartSymbolShape.circle
                .foregroundStyle(gameMode.chartColor)
                .frame(width: 8, height: 8)
            
            Text(gameMode.asStringShort)
                .foregroundColor(.gray)
                .font(.custom(RobotoSlabOptions.Weight.regular, fixedSize: CGFloat(RobotoSlabOptions.Size.caption)))
        }
    }
}

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
