import SwiftUI

/// View Model for the game over screen
class GameOverViewModel : ObservableObject {
    
    var gameOverModel : GameOverModel
    var BackButton : ThreeDButtonViewModel
    var PlayAgainButton : ThreeDButtonViewModel
    
    let functionButtonDimensions : (CGFloat, CGFloat) = (50, 400)
    
    init(_ gameOverModel: GameOverModel) {
        self.gameOverModel = gameOverModel
        self.BackButton = ThreeDButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1)
        self.PlayAgainButton = ThreeDButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1)
    }
    
    
}
