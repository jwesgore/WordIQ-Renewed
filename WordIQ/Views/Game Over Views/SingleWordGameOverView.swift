import SwiftUI
import SwiftData

/// A view that manages the end-of-game screen for a single-word game mode.
///
/// This view displays the game result, the target word, related statistics, and buttons
/// for returning to the main menu or playing again.
struct SingleWordGameOverView: View {
    
    // MARK: - Properties
    
    /// A helper for managing game database operations.
    var databaseHelper: GameDatabaseHelper
    
    /// The view model managing game-over statistics and button actions.
    @StateObject var viewModel: SingleWordGameOverViewModel
    
    /// The view model that represents the target word for the game over screen.
    @StateObject var gameOverWord: GameOverWordViewModel
    
    /// The game over data model containing result and statistic information.
    @State var gameOverData: GameOverDataModel
    
    /// The main game view model.
    @ObservedObject var gameViewModel: SingleBoardGameViewModel<GameBoardViewModel>
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Display game result message.
            Text(gameOverData.gameResult.gameOverString)
                .robotoSlabFont(.title, .bold)
            
            // Display the target word label and word view.
            Text("The word was ")
                .robotoSlabFont(.title3, .regular)
            GameOverWordView(gameOverWord)
            
            // A GroupBox to display game over stats.
            GroupBox {
                InfoItemView(viewModel.firstRowStat)
                Divider()
                InfoItemView(viewModel.secondRowStat)
                Divider()
                InfoItemView(viewModel.thirdRowStat)
                if gameOverData.gameMode != .zenMode {
                    Divider()
                    InfoItemView(viewModel.fourthRowStat)
                }
            }
            .backgroundStyle(Color.appGroupBox)
            
            Spacer()
            
            // Buttons for navigating back or playing again.
            HStack {
                TopDownButtonView(viewModel.backButton) {
                    Text(SystemNames.Navigation.mainMenu)
                        .robotoSlabFont(.title3, .regular)
                }
                // Only show the Play Again button for non-daily game modes.
                if gameOverData.gameMode != .dailyGame {
                    TopDownButtonView(viewModel.playAgainButton) {
                        Text(SystemNames.Navigation.playAgain)
                            .robotoSlabFont(.title3, .regular)
                    }
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

// MARK: - Initializer Extension

extension SingleWordGameOverView {
    /// Initializes a SingleWordGameOverView using the provided game view model and model context.
    ///
    /// - Parameters:
    ///   - viewModel: The main SingleBoardGameViewModel managing the game.
    ///   - modelContext: The SwiftData model context for database operations.
    init(_ viewModel: SingleBoardGameViewModel<GameBoardViewModel>, modelContext: ModelContext) {
        self.gameViewModel = viewModel
        self.gameOverData = viewModel.gameOverDataModel
        self.databaseHelper = GameDatabaseHelper(context: modelContext)
        
        // Initialize the game over view model with additional play-again action.
        self._viewModel = StateObject(wrappedValue: SingleWordGameOverViewModel(
            viewModel.gameOverDataModel,
            extraPlayAgainAction: viewModel.playAgain))
        
        // Force unwrap is used here; ensure `currentTargetWord` is non-nil.
        self._gameOverWord = StateObject(wrappedValue: GameOverWordViewModel(
            viewModel.gameOverDataModel.currentTargetWord!))
    }
}
