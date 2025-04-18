import SwiftUI

/// ViewModel for the game header.
///
/// The `GameHeaderViewModel` manages the header buttons (exit, pause, resume) for the game screen.
/// It interacts with the game clock and the navigation controller to coordinate state transitions
/// such as exiting the game, pausing the game, or resuming a paused game.
class GameHeaderViewModel: ObservableObject {

    // MARK: - Properties
    
    /// Indicates whether the header buttons are currently unlocked. If `false`, header button actions are disabled.
    var isHeaderButtonsUnlocked = true
    
    /// The navigation controller responsible for game navigation.
    var controller: GameNavigationController
    
    /// The view model managing the game clock.
    var clockViewModel: ClockViewModel
    
    /// The button used to exit the game.
    var exitGameButton: TopDownButtonViewModel
    
    /// The button used to pause the game.
    var pauseGameButton: TopDownButtonViewModel
    
    /// The button used to resume a paused game.
    var resumeGameButton: TopDownButtonViewModel
    
    /// The standard dimensions for header buttons.
    let headerButtonDimensions: (CGFloat, CGFloat) = (40, 40)
    
    /// The dimensions for the resume button.
    let resumeButtonDimensions: (CGFloat, CGFloat) = (50, 400)
    
    
    // MARK: - Initializer
    
    /// Initializes a new `GameHeaderViewModel` instance.
    ///
    /// - Parameters:
    ///   - clock: The `ClockViewModel` managing the game clock.
    ///   - controller: The `GameNavigationController` used for navigating between game states.
    init(clock: ClockViewModel, controller: GameNavigationController) {
        self.clockViewModel = clock
        self.controller = controller
        
        // Initialize the header buttons with the specified dimensions.
        exitGameButton = TopDownButtonViewModel(height: headerButtonDimensions.0, width: headerButtonDimensions.1, hasShadow: false)
        pauseGameButton = TopDownButtonViewModel(height: headerButtonDimensions.0, width: headerButtonDimensions.1, hasShadow: false)
        resumeGameButton = TopDownButtonViewModel(height: resumeButtonDimensions.0, width: resumeButtonDimensions.1)
        
        // Configure the button actions.
        exitGameButton.action = { [weak self] in
            self?.exitGame()
        }
        pauseGameButton.action = { [weak self] in
            self?.pauseGame()
        }
        resumeGameButton.action = { [weak self] in
            self?.resumeGame()
        }
    }
    
    
    // MARK: - Action Methods
    
    /// Exits the game and navigates back to the game mode selection screen.
    ///
    /// This method stops the game clock and calls the exit method on the shared navigation controller.
    func exitGame() {
        guard isHeaderButtonsUnlocked else { return }
        clockViewModel.stopClock()
        AppNavigationController.shared.exitFromSingleWordGame()
    }
    
    /// Pauses the game.
    ///
    /// This method stops the game clock and navigates to the pause view using the game navigation controller.
    func pauseGame() {
        guard isHeaderButtonsUnlocked else { return }
        clockViewModel.stopClock()
        controller.goToPause()
    }
    
    /// Resumes the game when paused.
    ///
    /// This method transitions back to the game view and restarts the game clock.
    func resumeGame() {
        controller.goToGameView() {
            self.clockViewModel.startClock()
        }
    }
}

