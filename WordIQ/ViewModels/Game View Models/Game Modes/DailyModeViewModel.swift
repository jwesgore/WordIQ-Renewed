/// ViewModel responsible for managing the specific rules and logic of Daily Mode.
///
/// This class extends `StandardModeViewModel` and introduces logic for handling
/// daily gameplay, including save state management and unique rules for daily challenges.
class DailyModeViewModel : StandardModeViewModel {

    /// Initializes the `DailyModeViewModel`, handling save state restoration and checks for prior gameplay.
    ///
    /// If the daily challenge has already been played, it loads the saved game state from `UserDefaultsHelper`.
    /// Otherwise, it either restores a valid save state or starts a new game.
    /// - Parameter gameOptions: The configuration options for the daily game, including target word and gameplay settings.
    override init(gameOptions: SingleWordGameOptionsModel) {
        // Check if the daily game has already been played
        guard !AppNavigationController.shared.isDailyAlreadyPlayed else {
            super.init(gameOptions: gameOptions)
            super.gameOverDataModel = UserDefaultsHelper.shared.dailyGameOverModel!
            return
        }
        
        // Check for a valid save state or start a new game
        if let saveState = UserDefaultsHelper.shared.dailySaveStateModel,
           saveState.gameOptionsModel.targetWord.daily == gameOptions.targetWord.daily {
            super.init(gameSaveState: saveState)
        } else {
            super.init(gameOptions: gameOptions)
        }
    }
    
    /// Overrides `gameOver` to clear the daily save state when the game ends.
    ///
    /// Ensures that no save state remains after a daily game concludes.
    /// - Parameter speed: The animation speed for ending the game.
    override func gameOver(speed: Double = 1.5) {
        super.gameOver(speed: speed)
        UserDefaultsHelper.shared.dailySaveStateModel = nil
    }
    
    /// Overrides `wrongWordSubmitted` to save the game state after a word submission.
    ///
    /// Creates and stores a save state in `UserDefaultsHelper` for the most recent word submission.
    override func wrongWordSubmitted() {
        super.wrongWordSubmitted()
        let saveState = super.getGameSaveState()
        UserDefaultsHelper.shared.dailySaveStateModel = saveState
    }
}
