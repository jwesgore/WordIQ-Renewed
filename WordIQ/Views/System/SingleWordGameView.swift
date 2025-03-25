import SwiftUI

/// View of the playable game are
struct SingleWordGameView : View {
    
    @ObservedObject var controller : SingleWordGameNavigationController
    @ObservedObject var viewModel : SingleWordGameViewModel
    
    var body : some View {
        ZStack {
            switch controller.activeView {
            case .singleWordGame:
                VStack (spacing: 0) {
                    
                    GameHeaderView(viewModel)
                    
                    Spacer()
                    
                    GameBoardView(viewModel.gameBoardViewModel)
                    
                    Spacer()
                    
                    KeyboardView(viewModel.keyboardViewModel)
                }
                .padding([.horizontal, .bottom])
                .transition(.blurReplace)
                .fullScreenCover(isPresented: $viewModel.showPauseMenu) {
                    GamePauseView(viewModel)
                }
            case .gameOver:
                SingleWordGameOverView(viewModel.gameOverDataModel)
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
        self.controller = SingleWordGameNavigationController.shared()
    }
    
    init () {
        self.controller = SingleWordGameNavigationController.shared()
        self.viewModel = SingleWordGameNavigationController.shared().singleWordGameViewModel
    }
}

#Preview {
    SingleWordGameView(StandardModeViewModel(gameOptions: SingleWordGameModeOptionsModel(gameMode: .standardMode, gameDifficulty: .normal, timeLimit:0)))
}
