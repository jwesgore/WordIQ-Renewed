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
                    
                    GameHeaderView(gameViewModel.gameOptions.gameMode.asStringShort, exitGame: gameViewModel.exitGame, pauseGame: gameViewModel.pauseGame)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        ClockView(clockVM: gameViewModel.clock)
                            .font(.custom(RobotoSlabOptions.Weight.regular, fixedSize: CGFloat(RobotoSlabOptions.Size.title2)))
                    }
                    
                    GameBoardView(gameViewModel.gameBoardViewModel)
                    
                    Spacer()
                    
                    KeyboardView(viewModel: gameViewModel.keyboardViewModel)
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
    GameView(StandardModeViewModel(gameOptions: GameModeOptionsModel(gameMode: .standardMode, gameDifficulty: .normal, timeLimit:0)))
}
