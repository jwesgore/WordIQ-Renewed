import SwiftUI

/// View that manages the end of a game
struct SingleWordGameOverView : View {
    
    @StateObject var viewModel : SingleWordGameOverViewModel
    @StateObject var gameOverWord: GameOverWordViewModel
    
    @ObservedObject var gameViewModel: SingleBoardGameViewModel
    
    @State var gameOverData : GameOverDataModel
    
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
            viewModel.saveData()
            viewModel.setRowValues()

            // gameOverWord.setBackgrounds(gameOverData.targetWordBackgrounds)
        }
    }
}

extension SingleWordGameOverView {
    init(_ viewModel : SingleBoardGameViewModel) {
        self.gameViewModel = viewModel
        self.gameOverData = viewModel.gameOverDataModel
        
        self._viewModel = StateObject(wrappedValue: SingleWordGameOverViewModel(viewModel.gameOverDataModel,
                                                                                extraPlayAgainAction: viewModel.playAgain))
        self._gameOverWord = StateObject(wrappedValue: GameOverWordViewModel(viewModel.gameOverDataModel.currentTargetWord!))
    }
}

//struct GameOverView_Preview: PreviewProvider {
//    static var previews: some View {
//        let gameModeOptions = SingleWordGameModeOptionsModel(gameMode: .standardMode, gameDifficulty: .normal, timeLimit: 0)
//        var gameoverModel = SingleWordGameOverDataModel(gameModeOptions)
//        gameoverModel.gameResult = .win
//        // let gameoverVM = SingleWordGameOverViewModel()
//        return VStack {
//            SingleWordGameOverView(gameoverModel)
//        }
//        .padding()
//        .previewDisplayName("Game Over Preview")
//        .previewLayout(.sizeThatFits)
//        .environment(\.managedObjectContext, GameDatabasePersistenceController.preview.container.viewContext)
//    }
//}
