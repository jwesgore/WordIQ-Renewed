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
                        Button {
                            self.gameViewModel.exitGame()
                        } label: {
                            Image(systemName: SFAssets.backArrow)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: CGFloat(RobotoSlabOptions.Size.title2), maxHeight: CGFloat(RobotoSlabOptions.Size.title2))
                        }
                        
                        Spacer()
                        Text(gameViewModel.gameOptions.gameMode.asStringShort)
                            .font(.custom(RobotoSlabOptions.Weight.bold, fixedSize: CGFloat(RobotoSlabOptions.Size.title3)))
                        Spacer()
                        
                        Button {
                            self.gameViewModel.pauseGame()
                        } label: {
                            Image(systemName: SFAssets.pause)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: CGFloat(RobotoSlabOptions.Size.title2), maxHeight: CGFloat(RobotoSlabOptions.Size.title2))
                        }
                        
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        ClockView(clockVM: gameViewModel.clock)
                            .font(.custom(RobotoSlabOptions.Weight.regular, fixedSize: CGFloat(RobotoSlabOptions.Size.title2)))
                    }
                    
                    GameBoardView(gameViewModel.gameBoardWords)
                    
                    Spacer()
                    
                    KeyboardView(keyboardLetters: gameViewModel.keyboardLetterButtons,
                                 enterKey: gameViewModel.keyboardEnterButton,
                                 deleteKey: gameViewModel.keyboardDeleteButton)
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
