import SwiftUI

// MARK: Game View Models
/// Protocol to define structure for base game requirements
protocol GameBaseProtocol : ObservableObject {
    var clock: ClockViewModel { get set }
    var isKeyboardUnlocked: Bool { get set }
    var showPauseMenu: Bool { get set }
    
    func exitGame()
    func pauseGame()
}

/// Protocol to define structure for single word game requirements
protocol SingleWordGameBaseProtocol : GameBaseProtocol {
    var targetWord: DatabaseWordModel { get set }
    var gameOptions: SingleWordGameModeOptionsModel { get set }
    
}

/// Protocol to define structure for four word game requirements
protocol FourWordGameBaseProtocol : GameBaseProtocol {
    var targetWords: [UUID: DatabaseWordModel] { get set }
    var gameOptions: FourWordGameModeOptionsModel { get set }
}

// MARK: Game Options Models
/// Protocol to define structure for base game options model
protocol GameOptionsBaseProtocol : Codable {
    var gameMode : GameMode { get set }
    var gameDifficulty : GameDifficulty { get set }
    var timeLimit : Int { get set }
    
    func resetToDefaults()
}

/// Protocol to define structure for single word games
protocol SingleWordGameOptionsProtocol : GameOptionsBaseProtocol {
    var targetWord: DatabaseWordModel { get set }
    
    func resetTargetWord()
}

/// Protocol to define structure for single word games
protocol FourWordGameOptionsProtocol : GameOptionsBaseProtocol {
    var targetWords: [DatabaseWordModel] { get set }
    
    func resetTargetWords()
}
