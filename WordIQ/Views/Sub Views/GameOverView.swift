import SwiftUI

/// View that manages the end of a game
struct GameOverView : View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var databaseHelper: GameDatabaseHelper?
    
    private var thirdRowSymbol : String = ""
    private var thirdRowLabel : String = ""
    @State private var thirdRowValue : String = ""
    
    private var fourthRowVisible : Bool = true
    private var fourthRowSymbol : String = ""
    private var fourthRowLabel : String = ""
    @State private var fourthRowValue : String = ""
    
    @ObservedObject var gameoverVM : GameOverViewModel
    
    init(_ gameoverVM: GameOverViewModel) {
        self.gameoverVM = gameoverVM
        
        switch gameoverVM.gameOverModel.gameMode {
        case .frenzygame:
            thirdRowSymbol = SFAssets.star
            thirdRowLabel = SystemNames.GameOver.score
            fourthRowSymbol = SFAssets.timer
            fourthRowLabel = SystemNames.GameOver.timePerWord
        case .zengame:
            thirdRowSymbol = SFAssets.stats
            thirdRowLabel = SystemNames.GameOver.gamesPlayed
            fourthRowVisible = false
        default:
            thirdRowSymbol = SFAssets.stats
            thirdRowLabel = SystemNames.GameOver.currentStreak
            fourthRowSymbol = SFAssets.stats
            fourthRowLabel = SystemNames.GameOver.winPercent
        }
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
                GameOverGroupBoxItem(image: SFAssets.timer,
                                     label: SystemNames.GameOver.timeElapsed,
                                     value: TimeUtility.formatTimeShort(gameoverVM.gameOverModel.timeElapsed))
                Divider()
                GameOverGroupBoxItem(image: SFAssets.numberSign,
                                     label: SystemNames.GameOver.guesses,
                                     value: self.gameoverVM.gameOverModel.numValidGuesses.description)
                Divider()
                GameOverGroupBoxItem(image: thirdRowSymbol,
                                     label: thirdRowLabel,
                                     value: thirdRowValue)
                if fourthRowVisible {
                    Divider()
                    GameOverGroupBoxItem(image: fourthRowSymbol,
                                         label: fourthRowLabel,
                                         value: fourthRowValue)
                }
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
            // Initialize helper
            self.databaseHelper = GameDatabaseHelper(context: viewContext)

            // Save game
            self.databaseHelper?.saveGame(gameOverData: gameoverVM.gameOverModel)
            
            // Parse values for end screen based on game mode
            switch gameoverVM.gameOverModel.gameMode {
            case .frenzygame:
                thirdRowValue = gameoverVM.gameOverModel.numCorrectWords.description
                fourthRowValue = ValueConverter.DoubleToPercent(
                    databaseHelper?.getGameModeWinPercentage(mode: gameoverVM.gameOverModel.gameMode) ?? 0)
            case .zengame:
                thirdRowValue = databaseHelper?.getGameModeCount(mode: gameoverVM.gameOverModel.gameMode).description ?? "1"
            default:
                thirdRowValue = "0"
                fourthRowValue = ValueConverter.DoubleToPercent(
                    databaseHelper?.getGameModeWinPercentage(mode: gameoverVM.gameOverModel.gameMode) ?? 0)
            }
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
