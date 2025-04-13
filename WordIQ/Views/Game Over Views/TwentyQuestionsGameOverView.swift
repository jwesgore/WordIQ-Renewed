import SwiftUI
import SwiftData

/// Game Over view for the twenty questions game mode
struct TwentyQuestionsGameOverView : View {
    
    var databaseHelper: GameDatabaseHelper
    
    @StateObject var viewModel : SingleWordGameOverViewModel
    @StateObject var gameOverWord: GameOverWordViewModel
    @State var gameOverData : GameOverDataModel
    
    @ObservedObject var gameViewModel: TwentyQuestionsViewModel
    
    var body: some View {
        
    }
}

extension TwentyQuestionsGameOverView {
    init (_ viewModel : TwentyQuestionsViewModel, modelContext: ModelContext) {
        self.gameViewModel = viewModel
        self.gameOverData = viewModel.gameOverDataModel
        self.databaseHelper = GameDatabaseHelper(context: modelContext)
        
        self._viewModel = StateObject(wrappedValue: SingleWordGameOverViewModel(viewModel.gameOverDataModel,
                                                                                extraPlayAgainAction: viewModel.playAgain))
        self._gameOverWord = StateObject(wrappedValue: GameOverWordViewModel(viewModel.gameOverDataModel.currentTargetWord!))
    }
}
