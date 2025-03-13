
/// ViewModel to handle the specific rules of Daily Mode
class DailyModeViewModel : StandardModeViewModel {
    
    override init(gameOptions: GameModeOptionsModel) {
        // Call Base Logic
        super.init(gameOptions: gameOptions)
        
        if let saveStateModel = UserDefaultsHelper.shared.dailyGameOverModel {
            if saveStateModel.targetWord == super.TargetWord {
                super.gameOverModel = saveStateModel
                
                self.IsKeyboardActive = false
                self.showPauseMenu = false
                self.Clock.stopClock()
                super.goToTarget()
            } else {
                UserDefaultsHelper.shared.dailyGameOverModel = nil
            }
        }
    }
}
