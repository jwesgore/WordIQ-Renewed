import SwiftUI

/// View that manages the end of a game
struct GameOverView : View {
    
    @ObservedObject var gameoverVM : GameOverViewModel
    
    var body: some View {
        VStack {
            
        }
    }
}

struct GameOverView_Preview: PreviewProvider {
    static var previews: some View {
        let gameModeOptions = GameModeOptionsModel(gameMode: .standardgame, gameDifficulty: .normal, timeLimit: 0)
        let gameoverModel = GameOverModel(gameOptions: gameModeOptions, targetWord: gameModeOptions.targetWord)
        let gameoverVM = GameOverViewModel(gameOverModel: gameoverModel)
        return GameOverView(gameoverVM: gameoverVM)
    }
}
