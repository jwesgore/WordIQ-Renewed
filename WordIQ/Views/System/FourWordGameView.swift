import SwiftUI

/// View for games with four words
struct FourWordGameView : View {
    
    @ObservedObject var controller : MultiWordGameNavigationController
    @ObservedObject var viewModel : FourWordGameViewModel
    
    var body: some View {

        ZStack {
            switch controller.activeView {
            case .fourWordGame:
                VStack (spacing: 0) {
                    
                    GameHeaderView(viewModel)

                    Spacer()
                    
                    FourWordGameBoardView(viewModel.gameBoardViewModel)
                    
                    Spacer()
                    
                    KeyboardView(viewModel.keyboardViewModel)
                }
                .padding([.horizontal, .bottom])
                .transition(.blurReplace)
                .fullScreenCover(isPresented: $viewModel.showPauseMenu) {
                    GamePauseView(viewModel)
                }
            case .gameOver:
                FourWordGameOverView(viewModel.gameOverDataModel)
                    .transition(.blurReplace)
            default:
                Color.appBackground
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

extension FourWordGameView {
    init (_ viewModel : FourWordGameViewModel) {
        self.viewModel = viewModel
        self.controller = MultiWordGameNavigationController.shared()
    }
}

#Preview {
    FourWordGameView(FourWordGameViewModel(gameOptions: FourWordGameModeOptionsModel()))
}
