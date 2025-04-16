import SwiftUI

/// View Model for game header
class GameHeaderViewModel: ObservableObject {
    
    /// Boolean to indicate whether the pause menu is displayed.
    var isHeaderButtonsUnlocked = true
    
    var controller : GameNavigationController
    
    var clockViewModel : ClockViewModel
    
    var exitGameButton : TopDownButtonViewModel
    var pauseGameButton : TopDownButtonViewModel
    var resumeGameButton : TopDownButtonViewModel
    
    let headerButtonDimensions : (CGFloat, CGFloat) = (40, 40)
    let resumeButtonDimensions : (CGFloat, CGFloat) = (50, 400)
    
    init(clock: ClockViewModel, controller: GameNavigationController) {
        clockViewModel = clock
        
        self.controller = controller
        
        exitGameButton = TopDownButtonViewModel(height: headerButtonDimensions.0, width: headerButtonDimensions.1)
        pauseGameButton = TopDownButtonViewModel(height: headerButtonDimensions.0, width: headerButtonDimensions.1)
        resumeGameButton = TopDownButtonViewModel(height: resumeButtonDimensions.0, width: resumeButtonDimensions.1)
        
        exitGameButton.action = {
            self.exitGame()
        }
        pauseGameButton.action = {
            self.pauseGame()
        }
        resumeGameButton.action = {
            self.resumeGame()
        }
    }
    
    /// Exits the game and navigates to game mode selection.
    func exitGame() {
        guard isHeaderButtonsUnlocked else { return }
        clockViewModel.stopClock()
        AppNavigationController.shared.exitFromSingleWordGame()
    }
    
    /// Pauses the game.
    func pauseGame() {
        guard isHeaderButtonsUnlocked else { return }
        clockViewModel.stopClock()
        controller.goToPause()
    }
    
    /// Resumes the game when paused.
    func resumeGame() {
        controller.goToGameView() {
            self.clockViewModel.startClock()
        }
    }
}
