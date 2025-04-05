import Foundation

/// Protocol to define structure for base game options model
protocol GameOptionsBase : Codable {
    var gameMode : GameMode { get set }
    var gameDifficulty : GameDifficulty { get set }
    var timeLimit : Int { get set }
    
    func resetToDefaults()
}

/// Protocol to define structure for single word games
protocol SingleWordGameOptions : GameOptionsBase {
    var targetWord: DatabaseWordModel { get set }
    
    func resetTargetWord()
}

/// Protocol to define structure for single word games
protocol MultiWordGameOptions : GameOptionsBase {
    var targetWords: OrderedDictionaryCodable<UUID, DatabaseWordModel> { get set }
    
    func resetTargetWords(withResetKeys: Bool)
}
