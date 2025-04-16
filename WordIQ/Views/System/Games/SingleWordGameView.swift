import SwiftUI
import SwiftData

/// View of the playable game are
struct SingleWordGameView : View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    
    @ObservedObject var controller : GameNavigationController<SingleWordGameOptionsModel>
    @StateObject var viewModel : SingleBoardGameViewModel<GameBoardViewModel>
    
    var body : some View {
        ZStack {
            switch controller.activeView {
            case .game:
                VStack (spacing: 0) {
                    
                    GameHeaderView(viewModel)
                    
                    Spacer()
                    
                    GameBoardView(viewModel.gameBoardViewModel)
                    
                    Spacer()
                    
                    KeyboardView(viewModel.keyboardViewModel)
                }
                .padding([.horizontal, .bottom])
                .transition(.opacity)
                .fullScreenCover(isPresented: $viewModel.showPauseMenu) {
                    GamePauseView(viewModel)
                }
            case .gameOver:
                SingleWordGameOverView(viewModel, modelContext: modelContext)
                    .transition(.opacity)
            default:
                Color.appBackground
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

extension SingleWordGameView {
    init (_ controller: GameNavigationController<SingleWordGameOptionsModel> = AppNavigationController.shared.singleWordGameNavigationController) {
        self.controller = controller
        self._viewModel = StateObject(wrappedValue: controller.gameOptions.getSingleWordGameViewModel())
    }
}
