import SwiftUI

/// View to manage Game Mode selection
struct GameSelectionDifficultyButtonView : View {
    
    @ObservedObject var viewModel: TopDownRadioButtonViewModel
    var difficulty : GameDifficulty
    
    init(_ viewModel: TopDownRadioButtonViewModel, difficulty: GameDifficulty) {
        self.viewModel = viewModel
        self.difficulty = difficulty
    }
    
    var body : some View {
        TopDownButton_Radio(viewModel) {
            Text(difficulty.asString)
                .robotoSlabFont(.title2, .regular)
        }
    }
}
