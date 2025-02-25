import SwiftUI

/// View Model for pause menu
class GamePauseViewModel {
    
    var ResumeGameButton : ThreeDButtonViewModel
    var EndGameButton : ThreeDButtonViewModel
    
    let functionButtonDimensions : (CGFloat, CGFloat) = (50, 400)
    
    init() {
        ResumeGameButton = ThreeDButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1)
        EndGameButton = ThreeDButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1)
    }
}
