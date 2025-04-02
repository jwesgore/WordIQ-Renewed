/// ViewModel to handle the specific rules of Daily Mode
class DailyModeViewModel : StandardModeViewModel {
    
    // MARK: - Overrides
    /// Override init to check for save states
    override init(gameOptions: SingleWordGameModeOptionsModel) {
        if let saveState = UserDefaultsHelper.shared.dailySaveStateModel,
            saveState.gameOverModel.targetWord.daily == gameOptions.targetWord.daily {
            super.init(gameSaveState: saveState)
        } else {
            super.init(gameOptions: gameOptions)
        }
        
        if UserDefaultsHelper.shared.lastDailyPlayed >= gameOptions.targetWord.daily {
            super.gameOverDataModel = UserDefaultsHelper.shared.dailyGameOverModel!
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
}

