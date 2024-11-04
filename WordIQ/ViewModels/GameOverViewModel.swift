import SwiftUI

class GameOverViewModel : ObservableObject {
    
    var gameOverModel : GameOverModel
    var BackButton : ThreeDButtonViewModel
    var PlayAgainButton : ThreeDButtonViewModel
    
    let functionButtonDimensions : (CGFloat, CGFloat) = (100, 400)
    
    init(gameOverModel: GameOverModel) {
        self.gameOverModel = gameOverModel
        self.BackButton = ThreeDButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1)
        self.PlayAgainButton = ThreeDButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1)
    }
    
    
    
}
