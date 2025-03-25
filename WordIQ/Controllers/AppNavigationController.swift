import SwiftUI

/// Navigation controller for top level view AppStartingView
class AppNavigationController : NavigationControllerBase {
    
    static let shared = AppNavigationController()
        
    // MARK: Models
    let singleWordGameModeOptions = SingleWordGameModeOptionsModel()
    let multiWordGameModeOptions = FourWordGameModeOptionsModel()
    
    // MARK: View Models
    /// Creates a game mode selection view model
    let gameModeSelectionViewModel = GameModeSelectionViewModel()
    let fourWordGameViewModel : FourWordGameViewModel
    
    init() {
        self.fourWordGameViewModel = FourWordGameViewModel(gameOptions: multiWordGameModeOptions)
    }

    /// Starts the game with the defined game options
    func goToSingleWordGame() {
        if singleWordGameModeOptions.gameMode != .dailyGame {
            singleWordGameModeOptions.resetTargetWord()
        }
        goToViewWithAnimation(.singleWordGame, delay:0.25, pauseLength: 0.25)
    }
    
    func goToGameModeSelection() {
        goToViewWithAnimation(.gameModeSelection)
    }
    
    // MARK: Functions
    /// Performs the necessary checks for notification permissions as well as setting up notifications for the first time
    func notificationFirstLaunch() async {
        let notificationHelper = NotificationHelper()
        
        // If notifications are not determined, ask for permission
        if await notificationHelper.checkNotificationPermission() == .notDetermined {
            await notificationHelper.requestNotificationPermission()
            
            // If first time setup is authorized, set up notification reminders
            if await notificationHelper.checkNotificationPermission() == .authorized {
                notificationHelper.dailyNotificationsEnable()
            }
        }
    }
}
