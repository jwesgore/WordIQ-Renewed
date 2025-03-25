import SwiftUI

struct GameModeOptionsView : View {
    
    @ObservedObject var viewModel: GameModeOptionsViewModel
    
    var body: some View {
        let optionsHeader = viewModel.showTimeLimitOptions ?
            "\(viewModel.singleWordGameModeOptions.gameMode.asStringShort): \(viewModel.singleWordGameModeOptions.gameDifficulty.asString), \(TimeUtility.formatTimeShort(viewModel.singleWordGameModeOptions.timeLimit))" :
            "\(viewModel.singleWordGameModeOptions.gameMode.asStringShort): \(viewModel.singleWordGameModeOptions.gameDifficulty.asString)"
            
        VStack {
            VStack {
                Spacer().frame(height: 20)
                
                Text(optionsHeader)
                    .robotoSlabFont(.title2, .semiBold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(viewModel.singleWordGameModeOptions.gameMode.description)
                    .robotoSlabFont(.subheading, .regular)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            VStack {
                GameSelectionDifficultyButtonView(viewModel.easyDifficultyButton, difficulty: .easy)
                GameSelectionDifficultyButtonView(viewModel.normalDifficultyButton, difficulty: .normal)
                GameSelectionDifficultyButtonView(viewModel.hardDifficultyButton, difficulty: .hard)
            }
            
            if viewModel.showTimeLimitOptions {
                HStack {
                    GameSelectionTimeButtonView(viewModel.timeSelection1Button, timeLimit: viewModel.timeLimitOptions.0)
                    GameSelectionTimeButtonView(viewModel.timeSelection2Button, timeLimit: viewModel.timeLimitOptions.1)
                    GameSelectionTimeButtonView(viewModel.timeSelection3Button, timeLimit: viewModel.timeLimitOptions.2)
                }
            }
            Spacer()
            
            VStack {
                TopDownButtonView(viewModel.startButton) {
                    Text(SystemNames.Navigation.startGame)
                        .robotoSlabFont(.title3, .regular)
                }
                
                TopDownButtonView(viewModel.backButton) {
                    Text(SystemNames.Navigation.back)
                        .robotoSlabFont(.title3, .regular)
                }
            }
        }
    }
}

extension GameModeOptionsView {
    init(_ viewModel: GameModeOptionsViewModel) {
        self.viewModel = viewModel
    }
}

#Preview {
    GameModeOptionsView(GameModeOptionsViewModel())
}
