import SwiftUI
import SwiftData

/// View of the playable game are
struct SingleWordGameView : View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    
    @ObservedObject var controller : SingleWordGameNavigationController
    @StateObject var viewModel : SingleBoardGameViewModel<GameBoardViewModel>
    
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
    init (_ controller: SingleWordGameNavigationController = AppNavigationController.shared.singleWordGameNavigationController) {
        self.controller = controller
        self._viewModel = StateObject(wrappedValue: controller.gameOptions.getSingleWordGameViewModel())
    }
}
