import SwiftUI

/// View to manage Game Mode selection
struct GameSelectionTimeButtonView : View {
    
    @ObservedObject var viewModel: TopDownRadioButtonViewModel
    var timeLimit : Int
    
    init(_ viewModel: TopDownRadioButtonViewModel, timeLimit: Int) {
        self.viewModel = viewModel
        self.timeLimit = timeLimit
    }
    
    var body : some View {
        TopDownButton_Radio(viewModel) {
            Text(TimeUtility.formatTimeShort(timeLimit))
                .robotoSlabFont(.title2, .regular)
        }
    }
}
