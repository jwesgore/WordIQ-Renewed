import SwiftUI

struct GameModeOptionsView : View {
    
    @ObservedObject var viewModel: GameModeOptionsViewModel
    
    var body: some View {
        
        VStack (spacing: 8.0) {

            HStack {
                Spacer()
                Text("Difficulty")
                    .opacity(0.5)
            }
            .robotoSlabFont(.title1, .regular)
            
            HStack {
                GameSelectionDifficultyButtonView(viewModel.easyDifficultyButton, difficulty: .easy)
                GameSelectionDifficultyButtonView(viewModel.normalDifficultyButton, difficulty: .normal)
                GameSelectionDifficultyButtonView(viewModel.hardDifficultyButton, difficulty: .hard)
            }
            
            if viewModel.showTimeLimitOptions {
                
                HStack {
                    Spacer()
                    Text("Time Limit")
                        .opacity(0.5)
                }
                .robotoSlabFont(.title1, .regular)
                
                HStack {
                    GameSelectionTimeButtonView(viewModel.timeSelection1Button, timeLimit: viewModel.timeLimitOptions.0)
                    GameSelectionTimeButtonView(viewModel.timeSelection2Button, timeLimit: viewModel.timeLimitOptions.1)
                    GameSelectionTimeButtonView(viewModel.timeSelection3Button, timeLimit: viewModel.timeLimitOptions.2)
                }
            }
            Spacer()
            
            HStack {
                TopDownButtonView(viewModel.backButton) {
                    Text(SystemNames.Navigation.back)
                        .robotoSlabFont(.title3, .regular)
                }
                
                TopDownButtonView(viewModel.startButton) {
                    Text(SystemNames.Navigation.startGame)
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
