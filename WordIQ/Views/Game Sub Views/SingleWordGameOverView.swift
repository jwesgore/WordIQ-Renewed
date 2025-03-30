import SwiftUI

/// View that manages the end of a game
struct SingleWordGameOverView : View {
    
    @ObservedObject var gameOverWordViewModel: GameOverWordViewModel
    var viewModel : SingleWordGameOverViewModel
    
    var gameOverData : SingleWordGameOverDataModel
    
    var body: some View {
        VStack (spacing: 20) {
            Spacer()
            
            Text(gameOverData.gameResult.gameOverString)
                .robotoSlabFont(.title, .bold)
            
            Text("The word was ")
                .robotoSlabFont(.title3, .regular)
            
            GameOverWordView(gameOverWordViewModel)
            
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
            viewModel.saveData(gameOverData)
            viewModel.setRowValues(gameOverData)

            gameOverWordViewModel.setBackgrounds(gameOverData.targetWordBackgrounds)
        }
    }
}

extension SingleWordGameOverView {
    init(_ gameOverData: SingleWordGameOverDataModel) {
        self.viewModel = SingleWordGameNavigationController.shared().singleWordGameOverViewModel
        self.gameOverData = gameOverData
        self.gameOverWordViewModel = GameOverWordViewModel(gameOverData.targetWord)
    }
}

struct GameOverView_Preview: PreviewProvider {
    static var previews: some View {
        let gameModeOptions = SingleWordGameModeOptionsModel(gameMode: .standardMode, gameDifficulty: .normal, timeLimit: 0)
        var gameoverModel = SingleWordGameOverDataModel(gameModeOptions)
        gameoverModel.gameResult = .win
        let gameoverVM = SingleWordGameOverViewModel()
        return VStack {
            SingleWordGameOverView(gameoverModel)
        }
        .padding()
        .previewDisplayName("Game Over Preview")
        .previewLayout(.sizeThatFits)
        .environment(\.managedObjectContext, GameDatabasePersistenceController.preview.container.viewContext)
    }
}
