import SwiftUI

/// View to manage Game Mode selection
struct GameSelectionDifficultyButtonView : View {
    
    @ObservedObject var button: ThreeDRadioButtonViewModel
    var difficulty : GameDifficulty
    
    init(_ button: ThreeDRadioButtonViewModel, difficulty: GameDifficulty) {
        self.button = button
        self.difficulty = difficulty
    }
    
    var body : some View {
        ThreeDRadioButtonView(button) {
            Text(difficulty.asString)
                .font(.custom(RobotoSlabOptions.Weight.regular, fixedSize: CGFloat(RobotoSlabOptions.Size.title2)))
        }
    }
}
