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
            Text(formatTimeShort(timeLimit))
                .font(.custom(RobotoSlabOptions.Weight.regular, fixedSize: CGFloat(RobotoSlabOptions.Size.title2)))
        }
    }
    
    func formatTimeShort(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}
