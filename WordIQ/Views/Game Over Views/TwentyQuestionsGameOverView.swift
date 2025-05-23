import SwiftUI
import SwiftData

/// Game Over view for the twenty questions game mode
struct TwentyQuestionsGameOverView : View {
    
    var databaseHelper: GameDatabaseClient
    
    @StateObject var viewModel : SingleWordGameOverViewModel
    @StateObject var gameOverWord: GameOverWordViewModel
    @State var gameOverData : GameOverDataModel
    
    @ObservedObject var gameViewModel: TwentyQuestionsViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            // Display game result message.
            if gameOverData.gameResult == .lose {
                Text("Game Over")
            } else {
                Text("Congratulations! You Won!")
                    .robotoSlabFont(.title, .bold)
            }
            
            // MARK: - Buttons
            HStack {
                TopDownButton(viewModel.backButton) {
                    Text(SystemNames.Navigation.mainMenu)
                        .robotoSlabFont(.title3, .regular)
                }
                
                TopDownButton(viewModel.playAgainButton) {
                    Text(SystemNames.Navigation.playAgain)
                        .robotoSlabFont(.title3, .regular)
                }
            }
        }
        .padding()
        .onAppear {
            // Configure default row labels/icons.
            viewModel.setRowDefaults()
            // Attempt to persist game over data.
            viewModel.trySaveGameData(databaseHelper: databaseHelper)
            // Retrieve and set up game statistic values for display.
            let statsModel = StatsModelFactory(databaseHelper: databaseHelper)
                .getStatsModel(for: gameOverData.gameMode)
            viewModel.setRowValues(statsModel: statsModel)
            // Update the target word display's background.
            gameOverWord.setBackgrounds(
                gameOverData.currentTargetWordBackgrounds ??
                LetterComparison.getCollection(size: 5, value: .notSet)
            )
        }
    }
}

extension TwentyQuestionsGameOverView {
    init (_ viewModel : TwentyQuestionsViewModel, modelContext: ModelContext) {
        self.gameViewModel = viewModel
        self.gameOverData = viewModel.gameOverDataModel
        self.databaseHelper = GameDatabaseClient(context: modelContext)
        
        self._viewModel = StateObject(wrappedValue: SingleWordGameOverViewModel(viewModel.gameOverDataModel,
                                                                                extraPlayAgainAction: viewModel.playAgain))
        self._gameOverWord = StateObject(wrappedValue: GameOverWordViewModel(viewModel.gameOverDataModel.currentTargetWord!))
    }
}
