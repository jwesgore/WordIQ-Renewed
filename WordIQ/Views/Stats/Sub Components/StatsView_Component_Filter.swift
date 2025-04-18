import SwiftUI

struct StatsView_Component_Filter : View {
    
    @ObservedObject var viewModel: StatsViewModel
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack {
                ForEach(StatsView_Filter_Enum.allCases, id: \.self) { filter in
                    StatsView_Filter_Button(viewModel: viewModel.filterButtons[filter]!, filter: filter)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
    }
}

struct StatsView_Filter_Button : View {
    
    @ObservedObject var viewModel: TopDownRadioButtonViewModel
    var filter: StatsView_Filter_Enum
    
    var body: some View {
        TopDownRadioButtonView(viewModel) {
            Text(filter.rawValue)
                .robotoSlabFont(.headline, .regular)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
        }
    }
}
