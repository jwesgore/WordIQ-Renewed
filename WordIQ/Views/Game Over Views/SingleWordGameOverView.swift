import SwiftUI
import SwiftData

/// View that manages the end of a game
struct SingleWordGameOverView : View {
    
    var databaseHelper: GameDatabaseHelper
    
    @StateObject var viewModel : SingleWordGameOverViewModel
    @StateObject var gameOverWord: GameOverWordViewModel
    @State var gameOverData : GameOverDataModel
    
    @ObservedObject var gameViewModel: SingleBoardGameViewModel
    
    var body: some View {
        VStack (spacing: 20) {
            Spacer()
            
            Text(gameOverData.gameResult.gameOverString)
                .robotoSlabFont(.title, .bold)
            
            Text("The word was ")
                .robotoSlabFont(.title3, .regular)
            
            GameOverWordView(gameOverWord)
            
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
            
            // MARK: Buttons
            HStack {
                
                TopDownButtonView(viewModel.backButton) {
                    Text(SystemNames.Navigation.mainMenu)
                        .robotoSlabFont(.title3, .regular)
                }
                
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
            viewModel.setRowDefaults()
            viewModel.trySaveGameData(databaseHelper: databaseHelper)
            
            let statsModel = StatsModelFactory(databaseHelper: databaseHelper).getStatsModel(for: gameOverData.gameMode)
            
            viewModel.setRowValues(statsModel: statsModel)

            gameOverWord.setBackgrounds(gameOverData.currentTargetWordBackgrounds ?? LetterComparison.getCollection(size: 5, value: .notSet))
        }
    }
}

extension SingleWordGameOverView {
    init(_ viewModel : SingleBoardGameViewModel, modelContext: ModelContext) {
        self.gameViewModel = viewModel
        self.gameOverData = viewModel.gameOverDataModel
        self.databaseHelper = GameDatabaseHelper(context: modelContext)
        
        self._viewModel = StateObject(wrappedValue: SingleWordGameOverViewModel(viewModel.gameOverDataModel,
                                                                                extraPlayAgainAction: viewModel.playAgain))
        self._gameOverWord = StateObject(wrappedValue: GameOverWordViewModel(viewModel.gameOverDataModel.currentTargetWord!))
    }
}
