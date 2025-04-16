import SwiftUI

/// Controller for navigation within the game selection subview.
///
/// This controller coordinates transitions between different game selection screens
/// such as mode selection, mode options, settings, and stats. It leverages the base
/// navigation controller (`NavigationControllerBase`) with the `GameSelectionViewEnum`
/// type to handle common navigation transitions.
class GameSelectionNavigationController: NavigationControllerBase<GameSelectionViewEnum> {
    
    // MARK: - View Model Properties
    
    /// The view model responsible for managing the game mode selection view.
    let gameModeSelectionViewModel: GameModeSelectionViewModel
    
    /// The view model responsible for managing game mode options.
    let gameModeOptionsViewModel: GameModeOptionsViewModel
    
    // MARK: - Initializer
    
    /// Initializes a new instance of `GameSelectionNavigationController`.
    ///
    /// This initializer sets up the initial navigation to the mode selection view and instantiates
    /// the necessary view models for game mode selection and options.
    init() {
        gameModeSelectionViewModel = GameModeSelectionViewModel()
        gameModeOptionsViewModel = GameModeOptionsViewModel()
        super.init(.modeSelection)
    }
    
    // MARK: - Navigation Functions
    
    /// Launches the daily puzzle mode.
    ///
    /// Configures the game mode options view model to `.dailyGame` and instructs the main
    /// `AppNavigationController` to transition to the daily word game.
    func goToDailyMode() {
        gameModeOptionsViewModel.setSingleWordGameMode(.dailyGame)
        AppNavigationController.shared.goToDailyWordGame()
    }
    
    /// Transitions to the four-word game screen.
    ///
    /// Instructs the main `AppNavigationController` to navigate to the four-word game view.
    func goToFourWordGame() {
        AppNavigationController.shared.goToFourWordGame()
    }
    
    /// Transitions to the game mode options view.
    ///
    /// Updates the game mode options with the provided game mode and performs an animated
    /// transition to the mode options view.
    ///
    /// - Parameter gameMode: The game mode to set in the options view.
    func goToGameModeOptions(_ gameMode: GameMode) {
        gameModeOptionsViewModel.setSingleWordGameMode(gameMode)
        goToViewWithAnimation(.modeOptions)
    }
    
    /// Navigates back to the game mode selection view.
    ///
    /// Resets the single-word game options to their defaults and transitions back to the mode
    /// selection view. The transition can be immediate or animated.
    ///
    /// - Parameters:
    ///   - immediate: If `true`, the transition occurs without animation. The default is `false`.
    ///   - complete: A closure to execute once the transition is complete.
    func goToGameModeSelection(immediate: Bool = false, complete: @escaping () -> Void = {}) {
        goToViewInternal(.modeSelection, immediate: immediate) {
            AppNavigationController.shared.singleWordGameOptionsModel.resetToDefaults()
            complete()
        }
    }
    
    /// Transitions to quick play mode.
    ///
    /// Sets the game mode options view model to `.quickplay` and instructs the main
    /// `AppNavigationController` to navigate to the single-word game view.
    func goToQuickPlay() {
        gameModeOptionsViewModel.setSingleWordGameMode(.quickplay)
        AppNavigationController.shared.goToSingleWordGame()
    }
    
    /// Navigates to the settings view.
    ///
    /// Depending on the `immediate` parameter, this function transitions instantly or with animation,
    /// then executes the provided completion handler.
    ///
    /// - Parameters:
    ///   - immediate: A Boolean value indicating whether the transition should occur without animation.
    ///                Defaults to `false`.
    ///   - complete: A closure executed after the transition is complete.
    func goToSettings(immediate: Bool = false, complete: @escaping () -> Void = {}) {
        goToViewInternal(.settings, immediate: immediate, complete: complete)
    }
    
    /// Navigates to the statistics view.
    ///
    /// Depending on whether the transition is immediate or animated, this function invokes the
    /// corresponding navigation method and then executes an optional completion handler.
    ///
    /// - Parameters:
    ///   - immediate: If `true`, the transition occurs immediately. Defaults to `false`.
    ///   - complete: A closure executed after the transition is complete.
    func goToStats(immediate: Bool = false, complete: @escaping () -> Void = {}) {
        goToViewInternal(.stats, immediate: immediate, complete: complete)
    }
    
    /// Transitions to the twenty questions game view.
    ///
    /// Instructs the main `AppNavigationController` to navigate to the twenty questions game.
    func goToTwentyQuestionsGame() {
        AppNavigationController.shared.goToTwentyQuestionsGame()
    }
    
    /// Transitions to the specified view with animation.
    ///
    /// Overrides the base class implementation to provide custom default values for the delay,
    /// animation length, and pause length.
    ///
    /// - Parameters:
    ///   - view: The target view of type `GameSelectionViewEnum`.
    ///   - delay: The delay before the animation starts, in seconds. Defaults to `0.0`.
    ///   - animationLength: The duration of the animation, in seconds. Defaults to `0.2`.
    ///   - pauseLength: The pause time after the animation before the completion closure is triggered.
    ///                 Defaults to `0.0`.
    ///   - onCompletion: A closure called after the transition is complete.
    override func goToViewWithAnimation(
        _ view: GameSelectionViewEnum,
        delay: Double = 0.0,
        animationLength: Double = 0.2,
        pauseLength: Double = 0.0,
        onCompletion: @escaping () -> Void = {}
    ) {
        super.goToViewWithAnimation(view, delay: delay, animationLength: animationLength, pauseLength: pauseLength, onCompletion: onCompletion)
    }
}
