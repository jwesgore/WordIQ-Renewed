import SwiftUI

/// View of the playable game are
struct SingleWordGameView : View {
    
    @ObservedObject var viewModel : SingleWordGameViewModel
    
    var body : some View {
        ZStack {
            switch viewModel.activeView {
            case .root:
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
            case .target:
                GameOverView(viewModel.gameOverViewModel)
                    .transition(.blurReplace)
            case .blank:
                Color.appBackground
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

extension SingleWordGameView {
    init (_ viewModel: SingleWordGameViewModel) {
        self.viewModel = viewModel
    }
}

#Preview {
    SingleWordGameView(StandardModeViewModel(gameOptions: GameModeOptionsModel(gameMode: .standardMode, gameDifficulty: .normal, timeLimit:0)))
}
