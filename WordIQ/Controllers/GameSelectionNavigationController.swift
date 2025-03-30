import SwiftUI

/// Controller for navigation within the game selection sub view
class GameSelectionNavigationController : NavigationControllerBase {
    static let shared = GameSelectionNavigationController()

    init() {
        super.init(.gameModeSelection)
    }
    
    let singleWordGameModeOptions = AppNavigationController.shared.singleWordGameModeOptions
    
    let gameModeOptionsViewModel = GameModeOptionsViewModel()
    
    /// Exit from a game view to the game mode selection view
    func exitFromGame() {
        goToGameModeSelectionImmediate() {
            AppNavigationController.shared.goToViewWithAnimation(.gameModeSelection) {
                SingleWordGameNavigationController.destroy()
                MultiWordGameNavigationController.destroy()
                AppNavigationController.shared.multiWordGameModeOptions.resetTargetWords()
            }
        }
    }
    
    /// Launch the daily puzzle
    func goToDailyMode() {
        gameModeOptionsViewModel.setSingleWordGameMode(.dailyGame)
        AppNavigationController.shared.goToSingleWordGame()
    }
    
    /// Transition to game mode options view
    func goToGameModeOptions(_ gameMode: GameMode) {
        gameModeOptionsViewModel.setSingleWordGameMode(gameMode)
        goToViewWithAnimation(.gameModeSelectionOptions)
    }
    
    /// Transition to game mode selection view
    func goToGameModeSelection(_ complete: @escaping () -> Void = {}) {
        goToViewWithAnimation(.gameModeSelection) {
            self.singleWordGameModeOptions.resetToDefaults()
            complete()
        }
    }
    
    /// Transition to game mode selection view with no animation
    func goToGameModeSelectionImmediate(_ complete: @escaping () -> Void = {}) {
        singleWordGameModeOptions.resetToDefaults()
        goToView(.gameModeSelection)
        complete()
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
