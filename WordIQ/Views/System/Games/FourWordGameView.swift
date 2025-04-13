import SwiftUI

/// View for games with four words
struct FourWordGameView : View {
    
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var controller : MultiWordGameNavigationController
    @StateObject var viewModel : FourWordGameViewModel

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
                .transition(.opacity)
                .fullScreenCover(isPresented: $viewModel.showPauseMenu) {
                    GamePauseView(viewModel)
                }
            case .gameOver:
                FourWordGameOverView(viewModel, modelContext: modelContext)
                    .transition(.opacity)
            default:
                Color.appBackground
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

extension FourWordGameView {
    init (_ controller: MultiWordGameNavigationController = AppNavigationController.shared.multiWordGameNavigationController) {
        self.controller = controller
        self._viewModel = StateObject(wrappedValue: controller.gameOptions.getFourWordGameViewModel())
    }
}
