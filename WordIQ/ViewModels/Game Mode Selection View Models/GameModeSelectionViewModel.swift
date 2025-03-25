import SwiftUI

/// ViewModel to manage the GameModeSelectionView
class GameModeSelectionViewModel : ObservableObject {
    
    @Published var displaySettings: Bool = false
    @Published var displayStats: Bool = false
    
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
        self.dailyGameButton = TopDownButtonViewModel(height: halfButtonDimensions.0, width: halfButtonDimensions.1)
        self.quickplayGameButton = TopDownButtonViewModel(height: halfButtonDimensions.0, width: halfButtonDimensions.1)
        self.standardGameModeButton = TopDownButtonViewModel(height: gameModeButtonDimension.0, width: gameModeButtonDimension.1)
        self.rushGameModeButton = TopDownButtonViewModel(height: gameModeButtonDimension.0, width: gameModeButtonDimension.1)
        self.frenzyGameModeButton = TopDownButtonViewModel(height: gameModeButtonDimension.0, width: gameModeButtonDimension.1)
        self.zenGameModeButton = TopDownButtonViewModel(height: gameModeButtonDimension.0, width: gameModeButtonDimension.1)
        self.fourWordGameModeButton = TopDownButtonViewModel(height: gameModeButtonDimension.0, width: gameModeButtonDimension.1)
        
        // Add actions to buttons
        self.dailyGameButton.action = {
            GameSelectionNavigationController.shared.goToDailyMode()
        }
        self.quickplayGameButton.action = {
            GameSelectionNavigationController.shared.goToQuickPlay()
        }
        self.standardGameModeButton.action = {
            GameSelectionNavigationController.shared.goToGameModeOptions(.standardMode)
        }
        self.rushGameModeButton.action = {
            GameSelectionNavigationController.shared.goToGameModeOptions(.rushMode)
        }
        self.frenzyGameModeButton.action = {
            GameSelectionNavigationController.shared.goToGameModeOptions(.frenzyMode)
        }
        self.zenGameModeButton.action = {
            GameSelectionNavigationController.shared.goToGameModeOptions(.zenMode)
        }
        self.fourWordGameModeButton.action = {
            self.startMultiWordGame()
        }
    }
    
    // MARK: Navigation Functions    
    func startMultiWordGame() {
        AppNavigationController.shared.goToViewWithAnimation(.fourWordGame, delay:0.25, pauseLength: 0.25)
    }
}
