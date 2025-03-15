/// ViewModel to handle the specific rules of Daily Mode
class DailyModeViewModel : StandardModeViewModel {
    
    // MARK: Overrides
    /// Override init to check for save states
    override init(gameOptions: GameModeOptionsModel) {
        // First Check to make sure that the user has not "time traveled" or already played todays game
        if UserDefaultsHelper.shared.lastDailyPlayed >= gameOptions.targetWord.daily {
            super.init(gameOptions: gameOptions)
            self.quickGameOver()
        }
        
        // If the save state is not null and is the same save state for today's game then call the save state initializer
        else if let saveState = UserDefaultsHelper.shared.dailySaveStateModel, saveState.gameOverModel.targetWord.daily == gameOptions.targetWord.daily {
            super.init(gameSaveState: saveState)
        }
        
        // Else call base initializer
        else {
            super.init(gameOptions: gameOptions)
        }
    }
    
    /// Override game over to clear out save state
    override func gameOver(speed: Double = 1.5) {
        super.gameOver(speed: speed)
        UserDefaultsHelper.shared.dailySaveStateModel = nil
    }
    
    /// Override wrong word to create a save state for the most recent word submission
    override func wrongWordSubmitted() {
        super.wrongWordSubmitted()
        let saveState = super.getGameSaveState()
        UserDefaultsHelper.shared.dailySaveStateModel = saveState
    }
    
    // MARK: Daily Specific Functions
    /// Ends the game without any animations
    func quickGameOver() {
        self.isKeyboardActive = false
        self.showPauseMenu = false
        self.clock.stopClock()
        
        super.gameOverModel = UserDefaultsHelper.shared.dailyGameOverModel!
        super.goToTarget()
    }
}
