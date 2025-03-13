
/// ViewModel to handle the specific rules of Daily Mode
class DailyModeViewModel : StandardModeViewModel {
    
    override init(gameOptions: GameModeOptionsModel) {
        // Call Base Logic
        super.init(gameOptions: gameOptions)
        
        // Check if user has already played the daily
        if UserDefaultsHelper.shared.lastDailyPlayed == gameOptions.targetWord.daily {
            self.IsKeyboardActive = false
            self.showPauseMenu = false
            self.Clock.stopClock()
            
            super.gameOverModel = UserDefaultsHelper.shared.dailyGameOverModel!
            super.goToTarget()
        }
    }
}
