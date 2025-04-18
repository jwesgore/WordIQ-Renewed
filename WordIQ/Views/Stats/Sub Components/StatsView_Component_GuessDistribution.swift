import SwiftUI

/// View Container for displaying guess distribution chart
struct StatsView_Component_GuessDistribution: View {
    
    var guessDistribution: DefaultDictionary<Int, Int>
    var maxRows: Int = 6
    var includePlus: Bool = false
    
    var normalizeValue: Int {
        includePlus ?
        max(guessDistribution.sumValues(forKeysGreaterThan: maxRows - 1), 20) :
        max(guessDistribution.getMax()?.value ?? 0, 20)
    }
    
    var body: some View {
        VStack (spacing: 8.0) {
            StatsView_Component_Label(
                label: "Guess Distribution",
                value: ""
            )
            
            ForEach(1...maxRows, id: \.self) { index in
                StatsView_Component_GuessDistribution_Row(index: index, guessDistribution: guessDistribution, normalizeValue: normalizeValue, includePlus: includePlus && (index == maxRows))
            }
        }
    }
}

struct StatsView_Component_GuessDistribution_Row: View {
    
    var index: Int
    var guessDistribution: DefaultDictionary<Int, Int>
    var normalizeValue: Int = 20
    var includePlus: Bool = false
    
    private var label: Int {
        includePlus ?
        guessDistribution.sumValues(forKeysGreaterThan: index - 1) :
        guessDistribution[index]
    }
    
    private var barSize: Double {
        includePlus ?
        max(Double(guessDistribution.sumValues(forKeysGreaterThan: index - 1)) / Double(normalizeValue), 0.05) :
        max(Double(guessDistribution[index]) / Double(normalizeValue), 0.05)
    }
    
    var body: some View {
        HStack (spacing: 8.0) {
            Text("\(includePlus ? "+" : "" )\(index)")
                .robotoSlabFont(.title3, .regular)
                .frame(width: 24, alignment: .trailing)
            
            StatsView_Component_BarDistributionChart(barSize, percent1Label: "\(label)", percent2Label: "")
        }
    }
}

extension StatsView_Component_GuessDistribution {
    init (_ statsModel: StatsModel, maxRows: Int = 6, includePlus: Bool = false) {
        self.guessDistribution = statsModel.guessDistribution
        self.maxRows = maxRows
        self.includePlus = includePlus
    }
}
