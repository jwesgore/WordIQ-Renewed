import SwiftUI

struct GameModeOptionsView : View {
    
    @ObservedObject var gameModeSelectionVM: GameModeSelectionViewModel
    
    init(_ gameModeSelectionVM: GameModeSelectionViewModel) {
        self.gameModeSelectionVM = gameModeSelectionVM
    }
    
    var body: some View {
        let optionsHeader = gameModeSelectionVM.showTimeLimitOptions ?
        "\(gameModeSelectionVM.GameModeOptions.gameMode.value): \(gameModeSelectionVM.GameModeOptions.gameDifficulty.asString), \(TimeUtility.formatTimeShort(gameModeSelectionVM.GameModeOptions.timeLimit))" :
        "\(gameModeSelectionVM.GameModeOptions.gameMode.value): \(gameModeSelectionVM.GameModeOptions.gameDifficulty.asString)"
            
        VStack (spacing: 10) {
            VStack {
                Spacer().frame(height: 20)
                
                Text(optionsHeader)
                    .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title2)))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(gameModeSelectionVM.GameModeOptions.gameMode.description)
                    .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.subheading)))
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
            VStack (spacing: 10) {
                ThreeDButtonView(gameModeSelectionVM.StartButton) {
                    Text(SystemNames.startGame)
                        .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.title3)))
                }
                
                ThreeDButtonView(gameModeSelectionVM.BackButton) {
                    Text(SystemNames.back)
                        .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.title3)))
                }
            }
        }
        .background(Color.appBackground)
    }
}

#Preview {
    GameModeOptionsView(GameModeSelectionViewModel())
}
