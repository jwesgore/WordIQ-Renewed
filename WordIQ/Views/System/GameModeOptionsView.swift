import SwiftUI

struct GameModeOptionsView : View {
    
    @ObservedObject var gameModeSelectionVM: GameModeSelectionViewModel
    
    var body: some View {
        let optionsHeader = gameModeSelectionVM.showTimeLimitOptions ?
            "\(gameModeSelectionVM.GameModeOptions.gameMode.asStringShort): \(gameModeSelectionVM.GameModeOptions.gameDifficulty.asString), \(TimeUtility.formatTimeShort(gameModeSelectionVM.GameModeOptions.timeLimit))" :
            "\(gameModeSelectionVM.GameModeOptions.gameMode.asStringShort): \(gameModeSelectionVM.GameModeOptions.gameDifficulty.asString)"
            
        VStack {
            VStack {
                Spacer().frame(height: 20)
                
                Text(optionsHeader)
                    .robotoSlabFont(.title2, .semiBold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(gameModeSelectionVM.GameModeOptions.gameMode.description)
                    .robotoSlabFont(.subheading, .regular)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            VStack {
                GameSelectionDifficultyButtonView(gameModeSelectionVM.EasyDifficultyButton, difficulty: .easy)
                GameSelectionDifficultyButtonView(gameModeSelectionVM.NormalDifficultyButton, difficulty: .normal)
                GameSelectionDifficultyButtonView(gameModeSelectionVM.HardDifficultyButton, difficulty: .hard)
            }
            
            if gameModeSelectionVM.showTimeLimitOptions {
                HStack {
                    GameSelectionTimeButtonView(gameModeSelectionVM.TimeSelection1Button, timeLimit: gameModeSelectionVM.TimeLimitOptions.0)
                    GameSelectionTimeButtonView(gameModeSelectionVM.TimeSelection2Button, timeLimit: gameModeSelectionVM.TimeLimitOptions.1)
                    GameSelectionTimeButtonView(gameModeSelectionVM.TimeSelection3Button, timeLimit: gameModeSelectionVM.TimeLimitOptions.2)
                }
            }
            Spacer()
            
            VStack {
                ThreeDButtonView(gameModeSelectionVM.StartButton) {
                    Text(SystemNames.Navigation.startGame)
                        .robotoSlabFont(.title3, .regular)
                }
                
                ThreeDButtonView(gameModeSelectionVM.BackButton) {
                    Text(SystemNames.Navigation.back)
                        .robotoSlabFont(.title3, .regular)
                }
            }
        }
    }
}

extension GameModeOptionsView {
    init(_ gameModeSelectionVM: GameModeSelectionViewModel) {
        self.gameModeSelectionVM = gameModeSelectionVM
    }
}

#Preview {
    GameModeOptionsView(GameModeSelectionViewModel())
}
