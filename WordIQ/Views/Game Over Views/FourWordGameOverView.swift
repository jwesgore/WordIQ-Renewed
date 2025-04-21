import SwiftUI
import SwiftData

/// View that manages the end of a game
struct FourWordGameOverView : View {
    
    var databaseHelper: GameDatabaseClient
    var gameOverWords: [GameOverWordViewModel]
    
    @StateObject var viewModel : FourWordGameOverViewModel
    @State var gameOverData : GameOverDataModel
    
    @ObservedObject var gameViewModel: FourWordGameViewModel
    
    var body : some View {
        VStack (spacing: 20) {
            Spacer()
            
            Text(gameOverData.gameResult.gameOverString)
                .robotoSlabFont(.title, .bold)
        
            Text("The words were")
                .robotoSlabFont(.title3, .regular)

            // MARK: Words
            FourWordGameOverWordsRow(viewModel1: gameOverWords[0], viewModel2: gameOverWords[1])
            FourWordGameOverWordsRow(viewModel1: gameOverWords[2], viewModel2: gameOverWords[3])
            
            // MARK: Stats
            GroupBox {
                InfoItemView(viewModel.firstRowStat)
                Divider()
                InfoItemView(viewModel.secondRowStat)
                Divider()
                InfoItemView(viewModel.thirdRowStat)
                Divider()
                InfoItemView(viewModel.fourthRowStat)
            }
            .backgroundStyle(Color.appGroupBox)
            
            Spacer()
            
            // MARK: Buttons
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
            viewModel.setRowDefaults()
            viewModel.trySaveGameData(databaseHelper: databaseHelper)
            
            let statsModel = StatsModelFactory(databaseHelper: databaseHelper).getStatsModel(for: gameOverData.gameMode)
            
            viewModel.setRowValues(statsModel: statsModel)
            
            for gameOverWord in gameOverWords {
                if let backgrounds = gameOverData.targetWordsBackgrounds[gameOverWord.id] {
                    gameOverWord.setBackgrounds(backgrounds)
                }
            }
        }
    }
}

extension FourWordGameOverView {
    init (_ viewModel : FourWordGameViewModel, modelContext: ModelContext) {
        self.gameViewModel = viewModel
        self.gameOverData = viewModel.gameOverDataModel
        self.databaseHelper = GameDatabaseClient(context: modelContext)
        
        self._viewModel = StateObject(wrappedValue: FourWordGameOverViewModel(viewModel.gameOverDataModel, extraPlayAgainAction: viewModel.playAgain))
        
        self.gameOverWords = []

        for (id, word) in gameOverData.targetWords {
            self.gameOverWords.append(GameOverWordViewModel(word, id: id))
        }
    }
}

private struct FourWordGameOverWordsRow: View {
    
    @StateObject var viewModel1: GameOverWordViewModel
    @StateObject var viewModel2: GameOverWordViewModel
    
    var body: some View {
        HStack {
            GameOverWordView(viewModel: viewModel1)
            Spacer()
                .frame(maxWidth: 25.0)
            GameOverWordView(viewModel: viewModel2)
        }
    }
}
