import Foundation
import Combine

/// View Model to facilitate setting game settings
class GameSettingsViewModel: ObservableObject {
    
    // MARK: Gameplay Settings
    @Published var colorBlind: Bool {
        didSet {
            UserDefaultsHelper.shared.setting_colorBlindMode = colorBlind
        }
    }
    @Published var showHints: Bool {
        didSet {
            UserDefaultsHelper.shared.setting_showHints = showHints
        }
    }
    @Published var soundEffects: Bool {
        didSet {
            UserDefaultsHelper.shared.setting_soundEffects = soundEffects
        }
    }
    @Published var tapticFeedback: Bool {
        didSet {
            UserDefaultsHelper.shared.setting_hapticFeedback = tapticFeedback
        }
    }
    
    // MARK: Quickplay Settings
    @Published var quickplayMode: GameMode {
        didSet {
            UserDefaultsHelper.shared.quickplaySetting_mode = quickplayMode
        }
    }
    @Published var quickplayDifficulty: GameDifficulty {
        didSet {
            UserDefaultsHelper.shared.quickplaySetting_difficulty = quickplayDifficulty
        }
    }
    @Published var quickplayTimeLimit: Int {
        didSet {
            UserDefaultsHelper.shared.quickplaySetting_timeLimit = quickplayTimeLimit
        }
    }
    
    var quickplayTimeLimitOptions: (Int, Int, Int) {
        return GameTimeLimit.getTimesFromGameMode(quickplayMode)
    }
    var showTimeLimitOptions: Bool {
        return [GameMode.rushgame, GameMode.frenzygame].contains(quickplayMode)
    }
    
    init() {
        self.colorBlind = UserDefaultsHelper.shared.setting_colorBlindMode
        self.showHints = UserDefaultsHelper.shared.setting_showHints
        self.soundEffects = UserDefaultsHelper.shared.setting_soundEffects
        self.tapticFeedback = UserDefaultsHelper.shared.setting_hapticFeedback
        self.quickplayMode = UserDefaultsHelper.shared.quickplaySetting_mode
        self.quickplayDifficulty = UserDefaultsHelper.shared.quickplaySetting_difficulty
        self.quickplayTimeLimit = UserDefaultsHelper.shared.quickplaySetting_timeLimit ?? 0
    }
}
