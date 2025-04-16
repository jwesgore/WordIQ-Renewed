import SwiftUI

/// A navigation controller for managing the single-game view flow.
///
/// This class manages navigation between game views (e.g., game, game over) and provides methods for transitioning
/// with or without animation. It is a generic class that supports custom game option models.
class GameNavigationController<TGameOptionsModel>:
    NavigationControllerBase<GameViewEnum>, GameNavigationControllerProtocol
    where TGameOptionsModel: GameOptionsBase {
    
    // MARK: - Properties
    
    /// The game options model that defines the configuration for the game.
    var gameOptions: TGameOptionsModel
    
    // MARK: - Initializer
    
    /// Initializes the navigation controller with a given game options model.
    ///
    /// - Parameter gameOptionsModel: The options model used to configure the game.
    init(_ gameOptionsModel: TGameOptionsModel) {
        self.gameOptions = gameOptionsModel
        super.init(.game) // Set the initial view state to `.game`.
    }
    
    // MARK: - Navigation Methods
    
    /// Starts the game and navigates to the game view.
    ///
    /// This method is the entry point for the `AppNavigationController` to begin the game.
    ///
    /// - Parameter complete: A closure executed after the transition is complete. Defaults to an empty closure.
    func startGame(complete: @escaping () -> Void = {}) {
        goToGameView(immediate: true) {
            complete()
        }
    }
    
    /// Navigates to the game over view.
    ///
    /// This method is the entry point for the `AppNavigationController` to display the game over screen.
    ///
    /// - Parameters:
    ///   - immediate: If `true`, the view transition happens immediately without animation. Defaults to `false`.
    ///   - complete: A closure executed after the transition is complete. Defaults to an empty closure.
    func goToGameOverView(immediate: Bool = false, complete: @escaping () -> Void = {}) {
        if immediate {
            goToView(.gameOver)
        } else {
            goToViewWithAnimation(.gameOver)
        }
    }
    
    /// Navigates to the game view.
    ///
    /// This method is the entry point for the `AppNavigationController` to switch to the game view.
    ///
    /// - Parameters:
    ///   - immediate: If `true`, the view transition happens immediately without animation. Defaults to `false`.
    ///   - complete: A closure executed after the transition is complete. Defaults to an empty closure.
    func goToGameView(immediate: Bool = false, complete: @escaping () -> Void = {}) {
        if immediate {
            goToView(.game) {
                complete()
            }
        } else {
            goToViewWithAnimation(.game, delay: 0.5) {
                complete()
            }
        }
    }
    
    /// Transitions to a specified view with animation.
    ///
    /// Overrides the `goToViewWithAnimation` method in the base class to transition to a given `GameViewEnum`.
    ///
    /// - Parameters:
    ///   - view: The target view to transition to.
    ///   - delay: The delay before starting the animation. Defaults to `1.5` seconds.
    ///   - animationLength: The duration of the animation. Defaults to `0.5` seconds.
    ///   - pauseLength: The duration to pause after the animation. Defaults to `0.0` seconds.
    ///   - onCompletion: A closure executed after the transition is complete. Defaults to an empty closure.
    override func goToViewWithAnimation(
        _ view: GameViewEnum,
        delay: Double = 1.5,
        animationLength: Double = 0.5,
        pauseLength: Double = 0.0,
        onCompletion: @escaping () -> Void = {}
    ) {
        super.goToViewWithAnimation(
            view,
            delay: delay,
            animationLength: animationLength,
            pauseLength: pauseLength,
            onCompletion: onCompletion
        )
    }
}
