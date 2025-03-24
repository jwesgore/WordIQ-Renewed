import SwiftUI

/// View that manages the end of a game
struct GameOverView : View {
    
    @ObservedObject var viewModel : SingleWordGameOverViewModel
    @State var gameMode : GameMode
    
    init(_ gameOverVM: SingleWordGameOverViewModel) {
        self.viewModel = gameOverVM
        self.gameMode = gameOverVM.gameOverData.gameMode
    }
    
    var body: some View {
        VStack (spacing: 20) {
            Spacer()
            
            Text(viewModel.gameOverData.gameResult.gameOverString)
                .robotoSlabFont(.title, .bold)
            
            Text("The word was ")
                .robotoSlabFont(.title3, .regular) +
            Text(viewModel.gameOverData.targetWord.word.uppercased())
                .robotoSlabFont(.title3, .regular)
            
            GroupBox {
                InfoItemView(viewModel.firstRowStat)
                Divider()
                InfoItemView(viewModel.secondRowStat)
                Divider()
                InfoItemView(viewModel.thirdRowStat)
                if gameMode != .zenMode {
                    Divider()
                    InfoItemView(viewModel.fourthRowStat)
                }
            }
            .backgroundStyle(Color.appGroupBox)
            
            Spacer()
            
            if gameMode != .dailyGame {
                ThreeDButtonView(viewModel.PlayAgainButton) {
                    Text(SystemNames.Navigation.playAgain)
                        .robotoSlabFont(.title3, .regular)
                }
            }
            
            ThreeDButtonView(viewModel.BackButton) {
                Text(SystemNames.Navigation.mainMenu)
                    .robotoSlabFont(.title3, .regular)
            }
        }
        .padding()
        .onAppear {
            self.viewModel.saveData()
            self.viewModel.setRowValues(gameMode)
        }
    }
}

struct GameOverView_Preview: PreviewProvider {
    static var previews: some View {
        let gameModeOptions = SingleWordGameModeOptionsModel(gameMode: .standardMode, gameDifficulty: .normal, timeLimit: 0)
        var gameoverModel = SingleWordGameOverDataModel(gameModeOptions)
        gameoverModel.gameResult = .win
        let gameoverVM = SingleWordGameOverViewModel(gameoverModel)
        return VStack {
            GameOverView(gameoverVM)
        }
        .padding()
        .previewDisplayName("Game Over Preview")
        .previewLayout(.sizeThatFits)
        .environment(\.managedObjectContext, GameDatabasePersistenceController.preview.container.viewContext)
    }
}
