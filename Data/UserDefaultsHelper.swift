import Foundation

/// Helper for accessing User Defaults data
class UserDefaultsHelper {
    
    static let shared = UserDefaultsHelper()
    
    // Keys
    private let colorBlindModeKey = "setting_colorBlindMode"
    private let showHintsKey = "setting_showHints"
    private let soundEffectsKey = "setting_soundEffects"
    private let hapticFeedbackKey = "setting_hapticFeedback"
    
    private let quickplayModeKey = "quickplaySetting_mode"
    private let quickplayDifficultyKey = "quickplaySetting_difficulty"
    private let quickplayTimeLimitKey = "quickplaySetting_timeLimit"
    
    private let currentStreakDailyKey = "currentStreak_daily"
    private let currentStreakStandardKey = "currentStreak_standard"
    private let currentStreakRushKey = "currentStreak_rush"
    
    private let maxStreakDailyKey = "maxStreak_daily"
    private let maxStreakStandardKey = "maxStreak_standard"
    private let maxStreakRushKey = "maxStreak_rush"
    
    private let maxScoreFrenzyKey = "maxScore_frenzy"
    
    // initializer
    private init() {
        // Register default values
        UserDefaults.standard.register(defaults: [
            colorBlindModeKey: false,
            showHintsKey: true,
            soundEffectsKey: true,
            hapticFeedbackKey: true,
            quickplayModeKey: GameMode.standardgame.id,
            quickplayDifficultyKey: GameDifficulty.normal.id,
            quickplayTimeLimitKey: 0,
            currentStreakDailyKey: 0,
            currentStreakStandardKey: 0,
            currentStreakRushKey: 0,
            maxStreakDailyKey: 0,
            maxStreakStandardKey: 0,
            maxStreakRushKey: 0,
            maxScoreFrenzyKey: 0
        ])
    }
    
    // MARK: - Settings
    var setting_colorBlindMode: Bool {
        get {
            return UserDefaults.standard.bool(forKey: colorBlindModeKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: colorBlindModeKey)
        }
    }
    
    var setting_showHints: Bool {
        get {
            return UserDefaults.standard.bool(forKey: showHintsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: showHintsKey)
        }
    }
    
    var setting_soundEffects: Bool {
        get {
            return UserDefaults.standard.bool(forKey: soundEffectsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: soundEffectsKey)
        }
    }
    
    var setting_hapticFeedback: Bool {
        get {
            return UserDefaults.standard.bool(forKey: hapticFeedbackKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hapticFeedbackKey)
        }
    }
    
    // MARK: - Quickplay Settings
    var quickplaySetting_mode: GameMode {
        get {
            let modeId = UserDefaults.standard.integer(forKey: quickplayModeKey)
            return GameMode.fromId(modeId) ?? .standardgame
        }
        set {
            switch newValue {
            case .rushgame: quickplaySetting_timeLimit = 60
            case .frenzygame: quickplaySetting_timeLimit = 90
            default: quickplaySetting_timeLimit = 0
            }
            UserDefaults.standard.set(newValue.id, forKey: quickplayModeKey)
        }
    }
    
    var quickplaySetting_difficulty: GameDifficulty {
        get {
            let difficultyId = UserDefaults.standard.integer(forKey: quickplayDifficultyKey)
            return GameDifficulty.fromId(difficultyId) ?? .normal
        }
        set {
            UserDefaults.standard.set(newValue.id, forKey: quickplayDifficultyKey)
        }
    }
    
    var quickplaySetting_timeLimit: Int {
        get {
            return UserDefaults.standard.integer(forKey: quickplayTimeLimitKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: quickplayTimeLimitKey)
        }
    }
    
    // MARK: - Game Data Values
    var currentStreak_daily: Int {
        get {
            return UserDefaults.standard.integer(forKey: currentStreakDailyKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: currentStreakDailyKey)
            if newValue > maxStreak_daily { maxStreak_daily = newValue }
        }
    }
    
    var currentStreak_standard: Int {
        get {
            return UserDefaults.standard.integer(forKey: currentStreakStandardKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: currentStreakStandardKey)
            if newValue > maxStreak_daily { maxStreak_standard = newValue }
        }
    }
    
    var currentStreak_rush: Int {
        get {
            return UserDefaults.standard.integer(forKey: currentStreakRushKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: currentStreakRushKey)
            if newValue > maxStreak_daily { maxStreak_rush = newValue }
        }
    }
    
    var maxStreak_daily: Int {
        get {
            return UserDefaults.standard.integer(forKey: maxStreakDailyKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: maxStreakDailyKey)
        }
    }
    
    var maxStreak_standard: Int {
        get {
            return UserDefaults.standard.integer(forKey: maxStreakStandardKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: maxStreakStandardKey)
        }
    }
    
    var maxStreak_rush: Int {
        get {
            return UserDefaults.standard.integer(forKey: maxStreakRushKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: maxStreakRushKey)
        }
    }
    
    var maxScore_frenzy: Int {
        get {
            return UserDefaults.standard.integer(forKey: maxScoreFrenzyKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: maxScoreFrenzyKey)
        }
    }
    
    // MARK: Functions
    // Update values based on game over results
    func update(_ gameOverResults : GameOverModel) {
        switch gameOverResults.gameMode {
        case .daily:
            currentStreak_daily = gameOverResults.gameResult == .win ? currentStreak_daily + 1 : 0
        case .standardgame:
            currentStreak_standard = gameOverResults.gameResult == .win ? currentStreak_standard + 1 : 0
        case .rushgame:
            currentStreak_rush = gameOverResults.gameResult == .win ? currentStreak_rush + 1 : 0
        case .frenzygame:
            if gameOverResults.numCorrectWords > maxScore_frenzy {
                maxScore_frenzy = gameOverResults.numCorrectWords
            }
        default:
            break
        }
    }
}
