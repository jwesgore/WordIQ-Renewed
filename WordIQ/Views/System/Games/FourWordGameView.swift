import SwiftUI

/// View for games with four words
struct FourWordGameView : View {
    
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var controller : GameNavigationController
    @StateObject var viewModel : FourWordGameViewModel

    var body: some View {

        ZStack {
            switch controller.activeView {
            case .game:
                VStack (spacing: 0) {
                    
                    GameHeaderView(viewModel)

                    Spacer()
                    
                    FourWordGameBoardView(viewModel.gameBoardViewModel)
                    
                    Spacer()
                    
                    KeyboardView(viewModel.keyboardViewModel)
                }
                .padding([.horizontal, .bottom])
                .transition(.opacity)
            case .gameOver:
                FourWordGameOverView(viewModel, modelContext: modelContext)
                    .transition(.opacity)
            case .pause:
                GamePauseView(viewModel)
            default:
                Color.appBackground
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

extension FourWordGameView {
    init () {
        self.controller = AppNavigationController.shared.multiWordGameNavigationController
        self._viewModel = StateObject(wrappedValue: AppNavigationController.shared.multiBoardGameOptionsModel.getFourWordGameViewModel())
    }
}
