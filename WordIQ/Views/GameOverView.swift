import SwiftUI

/// View that manages the end of a game
struct GameOverView : View {
    
    @ObservedObject var gameoverVM : GameOverViewModel
    
    init(_ gameoverVM: GameOverViewModel) {
        self.gameoverVM = gameoverVM
    }
    
    var body: some View {
        VStack (spacing: 20) {
            Spacer()
            Text(gameoverVM.gameOverModel.gameResult.gameOverString)
                .font(.custom(RobotoSlabOptions.Weight.bold, size: CGFloat(RobotoSlabOptions.Size.title)))
            
            Spacer()
            ThreeDButtonView(gameoverVM.PlayAgainButton) {
                Text(SystemNames.playAgain)
                    .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.title3)))
            }
            
            ThreeDButtonView(gameoverVM.BackButton) {
                Text(SystemNames.back)
                    .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.title3)))
            }
        }
        .padding()
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
