import SwiftUI

/// View that manages the end of a game
struct GameOverView : View {
    
    @ObservedObject var gameoverVM : GameOverViewModel
    @State var gameMode : GameMode
    
    init(_ gameoverVM: GameOverViewModel) {
        self.gameoverVM = gameoverVM
        self.gameMode = gameoverVM.gameOverData.gameMode
    }
    
    var body: some View {
        VStack (spacing: 20) {
            Spacer()
            
            Text(gameoverVM.gameOverData.gameResult.gameOverString)
                .font(.custom(RobotoSlabOptions.Weight.bold, size: CGFloat(RobotoSlabOptions.Size.title)))
            
            Text("The word was ")
                .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.title3))) +
            Text(gameoverVM.gameOverData.targetWord.word.uppercased())
                .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title3)))
            
            
            GroupBox {
                InfoItemView(gameoverVM.firstRowStat)
                Divider()
                InfoItemView(gameoverVM.secondRowStat)
                Divider()
                InfoItemView(gameoverVM.thirdRowStat)
                if gameMode != .zengame {
                    Divider()
                    InfoItemView(gameoverVM.fourthRowStat)
                }
            }
            .backgroundStyle(Color.appGroupBox)
            
            Spacer()
            
            if gameMode != .daily {
                ThreeDButtonView(gameoverVM.PlayAgainButton) {
                    Text(SystemNames.playAgain)
                        .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.title3)))
                }
            }
            
            ThreeDButtonView(gameoverVM.BackButton) {
                Text(SystemNames.mainMenu)
                    .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.title3)))
            }
        }
        .padding()
        .onAppear {
            self.gameoverVM.saveData()
            self.gameoverVM.setRowValues(gameMode)
        }
    }
}

struct GameOverView_Preview: PreviewProvider {
    static var previews: some View {
        let gameModeOptions = GameModeOptionsModel(gameMode: .standardgame, gameDifficulty: .normal, timeLimit: 0)
        var gameoverModel = GameOverDataModel(gameModeOptions)
        gameoverModel.gameResult = .win
        let gameoverVM = GameOverViewModel(gameoverModel)
        return VStack {
            GameOverView(gameoverVM)
        }
        .padding()
        .previewDisplayName("Game Over Preview")
        .previewLayout(.sizeThatFits)
        .environment(\.managedObjectContext, GameDatabasePersistenceController.preview.container.viewContext)
    }
}
