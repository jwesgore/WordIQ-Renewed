import SwiftUI
import SwiftData

/// View of the playable game are
struct SingleWordGameView : View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    
    @ObservedObject var controller : GameNavigationController
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
            case .gameOver:
                SingleWordGameOverView(viewModel, modelContext: modelContext)
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

extension SingleWordGameView {
    init () {
        self.controller = AppNavigationController.shared.singleWordGameNavigationController
        self._viewModel = StateObject(wrappedValue: AppNavigationController.shared.singleWordGameOptionsModel.getSingleWordGameViewModel())
    }
}
