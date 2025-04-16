import SwiftUI

/// A navigation controller for managing the single-game view flow.
///
/// This class coordinates transitions between different game views (such as game, game over, pause)
/// and provides methods for performing these transitions either immediately or with animation.
/// It subclasses `NavigationControllerBase<GameViewEnum>` and conforms to `GameNavigationControllerProtocol`.
class GameNavigationController: NavigationControllerBase<GameViewEnum>, GameNavigationControllerProtocol {
    
    // MARK: - Initializer
    
    /// Initializes a new instance of `GameNavigationController`.
    ///
    /// This initializer sets the initial navigation view state to `.game`.
    init() {
        super.init(.game) // Set the initial view state to `.game`.
    }
    
    // MARK: - Navigation Methods
    
    /// Starts the game and navigates to the game view.
    ///
    /// This method is the entry point for the `AppNavigationController` to begin the game.
    ///
    /// - Parameter complete: A closure executed after the transition is complete. The default value is an empty closure.
    func startGame(complete: @escaping () -> Void = {}) {
        goToGameView(immediate: true) {
            complete()
        }
    }
    
    /// Navigates to the game over view.
    ///
    /// This method is used by the `AppNavigationController` to display the game over screen.
    ///
    /// - Parameters:
    ///   - immediate: If `true`, the view transition occurs immediately without animation. The default is `false`.
    ///   - complete: A closure executed after the transition is finished. The default value is an empty closure.
    func goToGameOverView(immediate: Bool = false, complete: @escaping () -> Void = {}) {
        // A delay of 1.5 seconds is applied for animated transitions.
        goToViewInternal(.gameOver, immediate: immediate, delay: 1.5, complete: complete)
    }
    
    /// Navigates to the game view.
    ///
    /// This method transitions to the main game view.
    ///
    /// - Parameters:
    ///   - immediate: If `true`, the transition occurs instantly without animation; otherwise, the transition is animated.
    ///                The default value is `false`.
    ///   - complete: A closure executed after the transition completes. The default value is an empty closure.
    func goToGameView(immediate: Bool = false, complete: @escaping () -> Void = {}) {
        goToViewInternal(.game, immediate: immediate, complete: complete)
    }
    
    /// Navigates to the pause view.
    ///
    /// This method transitions the display to the game pause screen, allowing the user to pause the game.
    ///
    /// - Parameters:
    ///   - immediate: If `true`, the transition happens immediately without animation. Otherwise, it is animated.
    ///                The default value is `false`.
    ///   - complete: A closure executed after the pause transition is complete. The default value is an empty closure.
    func goToPause(immediate: Bool = false, complete: @escaping () -> Void = {}) {
        goToViewInternal(.pause, immediate: immediate, complete: complete)
    }
}
