import SwiftUI

/// ViewModel to manage the GameModeSelectionView
class GameModeSelectionViewModel : ObservableObject {
    
    @Published var displaySettings: Bool = false
    @Published var displayStats: Bool = false
    
    var gameSelectionController : GameSelectionNavigationController {
        return AppNavigationController.shared.gameSelectionNavigationController
    }
    
    let halfButtonDimensions: (CGFloat, CGFloat) = (70, 200)
    let gameModeButtonDimension: (CGFloat, CGFloat) = (70, 400)
        
    var dailyGameButton : TopDownButtonViewModel
    var frenzyGameModeButton : TopDownButtonViewModel
    var quickplayGameButton : TopDownButtonViewModel
    var rushGameModeButton : TopDownButtonViewModel
    var standardGameModeButton : TopDownButtonViewModel
    var zenGameModeButton : TopDownButtonViewModel
    
    var fourWordGameModeButton : TopDownButtonViewModel

    init() {
        // Initialize all buttons without action
        dailyGameButton = TopDownButtonViewModel(height: halfButtonDimensions.0, width: halfButtonDimensions.1)
        quickplayGameButton = TopDownButtonViewModel(height: halfButtonDimensions.0, width: halfButtonDimensions.1)
        standardGameModeButton = TopDownButtonViewModel(height: gameModeButtonDimension.0, width: gameModeButtonDimension.1)
        rushGameModeButton = TopDownButtonViewModel(height: gameModeButtonDimension.0, width: gameModeButtonDimension.1)
        frenzyGameModeButton = TopDownButtonViewModel(height: gameModeButtonDimension.0, width: gameModeButtonDimension.1)
        zenGameModeButton = TopDownButtonViewModel(height: gameModeButtonDimension.0, width: gameModeButtonDimension.1)
        fourWordGameModeButton = TopDownButtonViewModel(height: gameModeButtonDimension.0, width: gameModeButtonDimension.1)
        
        // Add actions to buttons
        dailyGameButton.action = {
            self.gameSelectionController.goToDailyMode()
        }
        quickplayGameButton.action = {
            self.gameSelectionController.goToQuickPlay()
        }
        standardGameModeButton.action = {
            self.gameSelectionController.goToGameModeOptions(.standardMode)
        }
        rushGameModeButton.action = {
            self.gameSelectionController.goToGameModeOptions(.rushMode)
        }
        frenzyGameModeButton.action = {
            self.gameSelectionController.goToGameModeOptions(.frenzyMode)
        }
        zenGameModeButton.action = {
            self.gameSelectionController.goToGameModeOptions(.zenMode)
        }
        fourWordGameModeButton.action = {
            self.gameSelectionController.goToFourWordGame()
        }
    }
}
