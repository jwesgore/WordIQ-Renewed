import SwiftUI

/// View of the playable game area
struct GameView : View {
    
    @ObservedObject var gameViewModel : GameViewModel
    
    var body : some View {
        VStack (spacing: 0) {
            HStack (spacing: 0) {
                Text(gameViewModel.gameOptions.gameMode.value)
                    .font(.custom(RobotoSlabOptions.Weight.bold, size: CGFloat(RobotoSlabOptions.Size.title3)))
                Spacer()
                Button(
                    action: {},
                    label: {
                        Image(systemName: SFAssets.pause)
                    }
                )
            }
            
            Spacer()
  
            HStack {
                Spacer()
                ClockView(clockVM: gameViewModel.Clock)
            }

            GameBoardView(gameViewModel.GameBoardWords)
            
            Spacer()
            
            KeyboardView(keyboardLetters: gameViewModel.KeyboardLetterButtons,
                         enterKey: gameViewModel.KeyboardEnterButton,
                         deleteKey: gameViewModel.KeyboardDeleteButton)
        }
        .padding()
    }
} 

#Preview {
    GameView(gameViewModel: RushModeViewModel(gameOptions: GameModeOptionsModel(gameMode: .standardgame, gameDifficulty: .normal, timeLimit:0)))
}
