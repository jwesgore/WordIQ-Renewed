import SwiftUI

/// Navigation controller for top level view AppStartingView
final class AppNavigationController : NavigationControllerBase {
    
    static var shared = AppNavigationController()
    
    var isDailyAlreadyPlayed : Bool {
        UserDefaultsHelper.shared.lastDailyPlayed >= WordDatabaseHelper.shared.fetchDailyFiveLetterWord().daily
    }
    
    // MARK: - Controllers
    let singleWordGameNavigationController : SingleWordGameNavigationController
    let multiWordGameNavigationController : MultiWordGameNavigationController
    let gameSelectionNavigationController : GameSelectionNavigationController
    
    // MARK: - Models
    let singleWordGameOptionsModel : SingleBoardGameOptionsModel
    let multiBoardGameOptionsModel : MultiBoardGameOptionsModel
    
    // MARK: - Initializer
    private init() {
        singleWordGameNavigationController = SingleWordGameNavigationController()
        multiWordGameNavigationController = MultiWordGameNavigationController()
        gameSelectionNavigationController = GameSelectionNavigationController()
        
        singleWordGameOptionsModel = SingleBoardGameOptionsModel()
        multiBoardGameOptionsModel = MultiBoardGameOptionsModel()
    }
    
    // MARK: - Single Word Game Functions
    /// Exit point from a single word game
    func exitFromSingleWordGame() {
        goToGameModeSelection()
    }
    
    /// Starts a daily word game
    func goToDailyWordGame() {
        if isDailyAlreadyPlayed {
            goToSingleWordGameOver(immediate: true) { [weak self] in
                self?.goToViewWithAnimation(.singleWordGame, delay: 0.25, pauseLength: 0.25)
            }
        } else {
            singleWordGameNavigationController.startGame { [weak self] in
                self?.goToViewWithAnimation(.singleWordGame, delay: 0.25, pauseLength: 0.25)
            }
        }
    }
    
    /// Starts a single word game with the defined game options
    func goToSingleWordGame() {
        singleWordGameOptionsModel.resetTargetWord()
        singleWordGameNavigationController.startGame { [weak self] in
            self?.goToViewWithAnimation(.singleWordGame, delay: 0.25, pauseLength: 0.25)
        }
    }
    
    /// Used to transition single word game view to game over view
    func goToSingleWordGameOver(immediate: Bool = false, complete: @escaping () -> Void = {}) {
        singleWordGameNavigationController.goToGameOverView(immediate: immediate) {
            complete()
        }
    }
    
    /// Used to play single word game mode again
    func playAgainSingleWordGame() {
        singleWordGameNavigationController.goToGameView() {
            
        }
    }
    
    // MARK: - Multi Word Game Functions
    /// Exit point from a four word game
    func exitFromFourWordGame() {
        goToGameModeSelection()
    }
    
    /// Starts a four word game with the defined game options
    func goToFourWordGame() {
        multiBoardGameOptionsModel.resetTargetWords()
        multiWordGameNavigationController.startGame { [weak self] in
            self?.goToViewWithAnimation(.fourWordGame, delay: 0.25, pauseLength: 0.25)
        }
    }
    
    /// Used to transition four word game view to game over view
    func goToFourWordGameOver() {
        multiWordGameNavigationController.goToGameOverView()
    }
    
    /// Used to play four word game mode again
    func playAgainFourWordGame() {
        multiWordGameNavigationController.goToGameView() {
            
        }
    }
    
    // MARK: - Game Options Functions
    /// Go to game mode selection view
    func goToGameModeSelection(immediate: Bool = true) {
        gameSelectionNavigationController.goToGameModeSelection(immediate: immediate) { [weak self] in
            self?.goToViewWithAnimation(.gameModeSelection)
        }
    }
    
    // MARK: - Misc Functions
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
