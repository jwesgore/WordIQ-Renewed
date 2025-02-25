import SwiftUI

/// View that manages the end of a game
struct GameOverView : View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var databaseHelper: GameDatabaseHelper?
    @State private var gameCount: String?
    @ObservedObject var gameoverVM : GameOverViewModel
    
    init(_ gameoverVM: GameOverViewModel) {
        self.gameoverVM = gameoverVM
    }
    
    var body: some View {
        VStack (spacing: 20) {
            Spacer()
            
            Text(gameoverVM.gameOverModel.gameResult.gameOverString)
                .font(.custom(RobotoSlabOptions.Weight.bold, size: CGFloat(RobotoSlabOptions.Size.title)))
            
            if gameoverVM.gameOverModel.gameMode == .frenzygame {
                
            } else {
                Text("The word was ")
                    .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.title3))) +
                Text(gameoverVM.gameOverModel.targetWord.word.uppercased())
                    .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title3)))
            }
            
            GroupBox {
                GameOverGroupBoxItem(image: SFAssets.gameController, label: SystemNames.GameOver.gamesPlayed, value: self.gameCount ?? "0")
                Divider()
                GameOverGroupBoxItem(image: SFAssets.numberSign, label: SystemNames.GameOver.guesses, value: self.gameoverVM.gameOverModel.numValidGuesses.description)
                Divider()
                GameOverGroupBoxItem(image: SFAssets.timer, label: SystemNames.GameOver.timeElapsed, value: TimeUtility.formatTimeShort(gameoverVM.gameOverModel.timeElapsed))
                Divider()
                GameOverGroupBoxItem(image: "", label: "Test", value: "Test")
            }
            
            Spacer()
            ThreeDButtonView(gameoverVM.PlayAgainButton) {
                Text(SystemNames.playAgain)
                    .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.title3)))
            }
            
            ThreeDButtonView(gameoverVM.BackButton) {
                Text(SystemNames.mainMenu)
                    .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.title3)))
            }
        }
        .padding()
        .onAppear {
            self.databaseHelper = GameDatabaseHelper(context: viewContext)
            self.databaseHelper?.saveGame(gameOverData: gameoverVM.gameOverModel)
            self.gameCount = self.databaseHelper?.getGameCount().description
        }
    }
}

private struct GameOverGroupBoxItem : View {
    
    var image: String
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.headline)))
                .frame(width: 25)

            Text(label)
                .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.headline)))
            Spacer()
            Text(value)
                .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.headline)))
        }
        
    }
}

struct GameOverView_Preview: PreviewProvider {
    static var previews: some View {
        let gameModeOptions = GameModeOptionsModel(gameMode: .standardgame, gameDifficulty: .normal, timeLimit: 0)
        var gameoverModel = GameOverModel(gameOptions: gameModeOptions)
        gameoverModel.gameResult = .win
        let gameoverVM = GameOverViewModel(gameoverModel)
        return VStack {
            GameOverView(gameoverVM)
        }
        .padding()
        .previewDisplayName("Game Over Preview")
        .previewLayout(.sizeThatFits)
    }
}
