
/// ViewModel to handle the specific rules of Daily Mode
class DailyModeViewModel : StandardModeViewModel {
    
    override func gameStartedOverride() {
        if let saveStateModel = UserDefaultsHelper.shared.dailyGameOverModel {
            if saveStateModel.targetWord == super.TargetWord.word {
                super.gameOverModel = saveStateModel.getGameOverModel()
                
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
