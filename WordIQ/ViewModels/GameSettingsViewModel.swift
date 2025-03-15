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
    @Published var hapticFeedback: Bool {
        didSet {
            UserDefaultsHelper.shared.setting_hapticFeedback = hapticFeedback
        }
    }
    
    // MARK: Notification Settings
    @Published var notificationsOn: Bool {
        didSet {
            UserDefaultsHelper.shared.setting_notificationsOn = notificationsOn
        }
    }
    @Published var notificationsDaily1: Bool {
        didSet {
            UserDefaultsHelper.shared.setting_notificationsDaily1 = notificationsDaily1
        }
    }
    @Published var notificationsDaily1Time: Date {
        didSet {
            UserDefaultsHelper.shared.setting_notificationsDaily1Time = notificationsDaily1Time
        }
    }
    @Published var notificationsDaily2: Bool {
        didSet {
            UserDefaultsHelper.shared.setting_notificationsDaily2 = notificationsDaily2
        }
    }
    @Published var notificationsDaily2Time: Date {
        didSet {
            UserDefaultsHelper.shared.setting_notificationsDaily2Time = notificationsDaily2Time
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
        self.hapticFeedback = UserDefaultsHelper.shared.setting_hapticFeedback
        
        self.notificationsOn = UserDefaultsHelper.shared.setting_notificationsOn
        self.notificationsDaily1 = UserDefaultsHelper.shared.setting_notificationsDaily1
        self.notificationsDaily1Time = UserDefaultsHelper.shared.setting_notificationsDaily1Time ?? Date()
        
        self.notificationsDaily2 = UserDefaultsHelper.shared.setting_notificationsDaily2
        self.notificationsDaily2Time = UserDefaultsHelper.shared.setting_notificationsDaily2Time ?? Date()
        
        self.quickplayMode = UserDefaultsHelper.shared.quickplaySetting_mode
        self.quickplayDifficulty = UserDefaultsHelper.shared.quickplaySetting_difficulty
        self.quickplayTimeLimit = UserDefaultsHelper.shared.quickplaySetting_timeLimit
    }
}
