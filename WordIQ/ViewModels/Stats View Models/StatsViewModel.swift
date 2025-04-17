import SwiftUI

class StatsViewModel : ObservableObject {
    
    // Filter
    @Published var activeFilter: StatsView_Filter_Enum = .all
    var filterButtonManager = TopDownRadioButtonGroupViewModel()
    var filterButtons = OrderedDictionary<StatsView_Filter_Enum, TopDownRadioButtonViewModel>()
    
    init() {
        // Initialize filter buttons
        for value in StatsView_Filter_Enum.allCases {
            let viewModel = TopDownRadioButtonViewModel(height: 32, width: .infinity, groupManager: filterButtonManager, hasShadow: false, isPressed: value == .all) {
                self.activeFilter = value
            }
            viewModel.cornerRadius = 8
            filterButtons[value] = viewModel
            filterButtonManager.add(viewModel)
        }
    }
}
