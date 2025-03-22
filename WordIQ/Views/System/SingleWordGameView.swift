import SwiftUI

/// View of the playable game are
struct SingleWordGameView : View {
    
    @ObservedObject var navigationController : SingleWordGameNavigationController
    @ObservedObject var viewModel : SingleWordGameViewModel
    
    var body : some View {
        ZStack {
            switch navigationController.activeView {
            case .game:
                VStack (spacing: 0) {
                    
                    GameHeaderView(viewModel)
                    
                    Spacer()
                    
                    GameBoardView(viewModel.gameBoardViewModel)
                    
                    Spacer()
                    
                    KeyboardView(viewModel.keyboardViewModel)
                }
                .padding()
                .transition(.blurReplace)
                .fullScreenCover(isPresented: $viewModel.showPauseMenu) {
                    GamePauseView(viewModel)
                }
            case .gameOver:
                GameOverView(viewModel.gameOverViewModel)
                    .transition(.blurReplace)
            default:
                Color.appBackground
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

extension SingleWordGameView {
    init (_ viewModel: SingleWordGameViewModel) {
        self.viewModel = viewModel
        self.navigationController = SingleWordGameNavigationController.shared
    }
}

#Preview {
    SingleWordGameView(StandardModeViewModel(gameOptions: GameModeOptionsModel(gameMode: .standardMode, gameDifficulty: .normal, timeLimit:0)))
}
