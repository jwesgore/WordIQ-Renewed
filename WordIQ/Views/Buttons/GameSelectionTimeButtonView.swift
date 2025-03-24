import SwiftUI

/// View to manage Game Mode selection
struct GameSelectionTimeButtonView : View {
    
    @ObservedObject var button: ThreeDRadioButtonViewModel
    var timeLimit : Int
    
    init(_ button: ThreeDRadioButtonViewModel, timeLimit: Int) {
        self.button = button
        self.timeLimit = timeLimit
    }
    
    var body : some View {
        ThreeDRadioButtonView(button) {
            Text(TimeUtility.formatTimeShort(timeLimit))
                .robotoSlabFont(.title2, .regular)
        }
    }
}
