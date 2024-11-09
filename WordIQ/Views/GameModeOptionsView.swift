import SwiftUI

struct GameModeOptionsView : View {
    
    @ObservedObject var gameModeSelectionVM: GameModeSelectionViewModel
    
    init(_ gameModeSelectionVM: GameModeSelectionViewModel) {
        self.gameModeSelectionVM = gameModeSelectionVM
    }
    
    var body: some View {
        VStack (spacing: 10) {
            VStack {
                Text("Test")
            }
            Spacer()
            VStack {
                GameSelectionDifficultyButtonView(gameModeSelectionVM.EasyDifficultyButton, difficulty: .easy)
                GameSelectionDifficultyButtonView(gameModeSelectionVM.NormalDifficultyButton, difficulty: .normal)
                GameSelectionDifficultyButtonView(gameModeSelectionVM.HardDifficultyButton, difficulty: .hard)
            }
            if gameModeSelectionVM.TimeLimitOptions != (0,0,0) {
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
    }
}
