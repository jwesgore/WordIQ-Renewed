/// ViewModel to handle the specific rules of Daily Mode
class DailyModeViewModel : StandardModeViewModel {
    
    override init(gameOptions: GameModeOptionsModel) {
        // Call Base Logic
        if let saveState = UserDefaultsHelper.shared.dailySaveStateModel, saveState.gameOverModel.targetWord.daily == gameOptions.targetWord.daily {
            super.init(gameSaveState: saveState)
        } else {
            super.init(gameOptions: gameOptions)
        }

        // Check if user has already played the daily
        if UserDefaultsHelper.shared.lastDailyPlayed == gameOptions.targetWord.daily {
            self.isKeyboardActive = false
            self.showPauseMenu = false
            self.clock.stopClock()
            
            super.gameOverModel = UserDefaultsHelper.shared.dailyGameOverModel!
            super.goToTarget()
        }
    }
    
    override func gameOver(speed: Double = 1.5) {
        super.gameOver(speed: speed)
        UserDefaultsHelper.shared.dailySaveStateModel = nil
    }
    
    override func wrongWordSubmitted() {
        super.wrongWordSubmitted()
        let saveState = super.getGameSaveState()
        UserDefaultsHelper.shared.dailySaveStateModel = saveState
    }
}
