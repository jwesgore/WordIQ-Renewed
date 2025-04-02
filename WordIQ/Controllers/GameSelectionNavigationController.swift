import SwiftUI

/// Controller for navigation within the game selection sub view
class GameSelectionNavigationController : NavigationControllerBase {

    // MARK: - View Models
    let gameModeSelectionViewModel : GameModeSelectionViewModel
    let gameModeOptionsViewModel : GameModeOptionsViewModel
    
    // MARK: - Initializer
    init() {
        gameModeSelectionViewModel = GameModeSelectionViewModel()
        gameModeOptionsViewModel = GameModeOptionsViewModel()
        
        super.init(.gameModeSelection)
    }
    
    // MARK: - Navigation Functions
    /// Launch the daily puzzle
    func goToDailyMode() {
        gameModeOptionsViewModel.setSingleWordGameMode(.dailyGame)
        AppNavigationController.shared.goToSingleWordGame()
    }
    
    /// Transition to a four word game
    func goToFourWordGame() {
        AppNavigationController.shared.goToFourWordGame()
    }
    
    /// Transition to game mode options view
    func goToGameModeOptions(_ gameMode: GameMode) {
        gameModeOptionsViewModel.setSingleWordGameMode(gameMode)
        goToViewWithAnimation(.gameModeSelectionOptions)
    }
    
    /// Transition to game mode selection view
    func goToGameModeSelection(immediate: Bool = false, complete: @escaping () -> Void = {}) {
        if immediate {
            goToView(.gameModeSelection) {
                AppNavigationController.shared.singleWordGameModeOptionsModel.resetToDefaults()
                complete()
            }
        } else {
            goToViewWithAnimation(.gameModeSelection) {
                AppNavigationController.shared.singleWordGameModeOptionsModel.resetToDefaults()
                complete()
            }
        }
    }
    
    /// Transition to a game view using the saved quick play defaults
    func goToQuickPlay() {
        gameModeOptionsViewModel.setSingleWordGameMode(.quickplay)
        AppNavigationController.shared.goToSingleWordGame()
    }
    
    /// Transition to a view with animation fading to a blank view
    override func goToViewWithAnimation(_ view: SystemView,
                                        delay: Double = 0.0,
                                        animationLength: Double = 0.2,
                                        pauseLength: Double = 0.0,
                                        onCompletion: @escaping () -> Void = {}) {
        super.goToViewWithAnimation(view, delay: delay, animationLength: animationLength, pauseLength: pauseLength, onCompletion: onCompletion)
    }
}
