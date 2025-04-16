import SwiftUI
import SwiftData

/// View of the playable game are
struct TwentyQuestionsGameView : View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    
    @ObservedObject var controller : GameNavigationController<SingleWordGameOptionsModel>
    @StateObject var viewModel : TwentyQuestionsViewModel
    
    var body : some View {
        ZStack {
            switch controller.activeView {
            case .game:
                VStack (spacing: 0) {
                    
                    GameHeaderView(viewModel)
                    
                    Spacer()
                    
                    TwentyQuestionsGameBoardView(viewModel.gameBoardViewModel)
                    
                    Spacer()
                    
                    KeyboardView(viewModel.keyboardViewModel)
                }
                .padding([.horizontal, .bottom])
                .transition(.opacity)
                .fullScreenCover(isPresented: $viewModel.showPauseMenu) {
                    // GamePauseView(viewModel)
                }
            case .gameOver:
                TwentyQuestionsGameOverView(viewModel, modelContext: modelContext)
                    .transition(.opacity)
            default:
                Color.appBackground
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

extension TwentyQuestionsGameView {
    init (_ controller: GameNavigationController<SingleWordGameOptionsModel> = AppNavigationController.shared.twentyQuestionsNavigationController) {
        self.controller = controller
        self._viewModel = StateObject(wrappedValue: controller.gameOptions.getTwentyQuestionsGameViewModel())
    }
}

#Preview {
    TwentyQuestionsGameView()
}
