import SwiftUI

/// View that manages the end of a game
struct SingleWordGameOverView : View {
    
    @ObservedObject var viewModel : SingleWordGameOverViewModel
    var gameOverData : SingleWordGameOverDataModel
    
    var body: some View {
        VStack (spacing: 20) {
            Spacer()
            
            Text(gameOverData.gameResult.gameOverString)
                .robotoSlabFont(.title, .bold)
            
            Text("The word was ")
                .robotoSlabFont(.title3, .regular) +
            Text(gameOverData.targetWord.word.uppercased())
                .robotoSlabFont(.title3, .regular)
            
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
            
            if gameOverData.gameMode != .dailyGame {
                TopDownButtonView(viewModel.playAgainButton) {
                    Text(SystemNames.Navigation.playAgain)
                        .robotoSlabFont(.title3, .regular)
                }
            }
            
            TopDownButtonView(viewModel.backButton) {
                Text(SystemNames.Navigation.mainMenu)
                    .robotoSlabFont(.title3, .regular)
            }
        }
        .padding()
        .onAppear {
            viewModel.setRowDefaults()
            viewModel.saveData(gameOverData)
            viewModel.setRowValues(gameOverData)
        }
    }
}

extension SingleWordGameOverView {
    init(_ gameOverData: SingleWordGameOverDataModel) {
        self.viewModel = SingleWordGameNavigationController.shared().singleWordGameOverViewModel
        self.gameOverData = gameOverData
    }
}

//struct GameOverView_Preview: PreviewProvider {
//    static var previews: some View {
//        let gameModeOptions = SingleWordGameModeOptionsModel(gameMode: .standardMode, gameDifficulty: .normal, timeLimit: 0)
//        var gameoverModel = SingleWordGameOverDataModel(gameModeOptions)
//        gameoverModel.gameResult = .win
//        let gameoverVM = SingleWordGameOverViewModel(gameoverModel)
//        return VStack {
//            SingleWordGameOverView(gameoverVM)
//        }
//        .padding()
//        .previewDisplayName("Game Over Preview")
//        .previewLayout(.sizeThatFits)
//        .environment(\.managedObjectContext, GameDatabasePersistenceController.preview.container.viewContext)
//    }
//}
