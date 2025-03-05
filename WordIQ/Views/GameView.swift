import SwiftUI

/// View of the playable game are
struct GameView : View {
    
    @ObservedObject var gameViewModel : GameViewModel
    
    init (_ gameViewModel: GameViewModel) {
        self.gameViewModel = gameViewModel
    }
    
    var body : some View {
        ZStack {
            switch gameViewModel.activeView {
            case .root:
                VStack (spacing: 0) {
                    HStack (spacing: 0) {
                        Button (
                            action: {
                                self.gameViewModel.exitGame()
                            },
                            label: {
                                Image(systemName: SFAssets.backArrow)
                            }
                        )
                        Spacer()
                        Text(gameViewModel.gameOptions.gameMode.value)
                            .font(.custom(RobotoSlabOptions.Weight.bold, size: CGFloat(RobotoSlabOptions.Size.title3)))
                        Spacer()
                        Button(
                            action: {
                                self.gameViewModel.pauseGame()
                            },
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
                .transition(.blurReplace)
                .fullScreenCover(isPresented: $gameViewModel.showPauseMenu) {
                    GamePauseView(gameViewModel)
                }
            case .target:
                GameOverView(gameViewModel.gameOverViewModel)
                    .transition(.blurReplace)
            case .blank:
                Color.appBackground
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

#Preview {
    GameView(StandardModeViewModel(gameOptions: GameModeOptionsModel(gameMode: .standardgame, gameDifficulty: .normal, timeLimit:0)))
}
