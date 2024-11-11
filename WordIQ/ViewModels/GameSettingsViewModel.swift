import SwiftUI

/// View Model to facilitate setting game settings
class GameSettingsViewModel: ObservableObject {
    
    @Published var colorBlind: Bool
    @Published var showHints: Bool
    @Published var soundEffects: Bool
    @Published var tapticFeedback: Bool
    
    @Published var quickplayMode: GameMode
    @Published var quickplayDifficulty: GameDifficulty
    @Published var quickplayTimeLimit: Int
    var quickplayTimeLimitOptions: (Int, Int, Int) {
        return GameTimeLimit.getTimesFromGameMode(quickplayMode)
    }
    
    init() {
        self.colorBlind = false
        self.showHints = false
        self.soundEffects = false
        self.tapticFeedback = false
        
        self.quickplayMode = .standardgame
        self.quickplayDifficulty = .normal
        self.quickplayTimeLimit = 0
    }
}
