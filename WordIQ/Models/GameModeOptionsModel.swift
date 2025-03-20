import SwiftUI

/// Model used to package up game mode options
class GameModeOptionsModel : Codable {
    var gameMode: GameMode
    var gameDifficulty: GameDifficulty
    var timeLimit: Int
    var targetWord: DatabaseWordModel
        
    /// Initializer that takes in a target word
    init(gameMode: GameMode, gameDifficulty: GameDifficulty, timeLimit: Int, targetWord: DatabaseWordModel) {
        self.gameMode = gameMode
        self.gameDifficulty = gameDifficulty
        self.timeLimit = timeLimit
        self.targetWord = targetWord
    }
    
    /// Initializer that presets the target word
    convenience init(gameMode: GameMode = .standardMode, gameDifficulty: GameDifficulty = .normal, timeLimit: Int = 0) {
        let targetWord = WordDatabaseHelper.shared.fetchRandomFiveLetterWord(withDifficulty: gameDifficulty)
        self.init(gameMode: gameMode, gameDifficulty: gameDifficulty, timeLimit: timeLimit, targetWord: targetWord)
    }
    
    /// Resets the target word so the model can be persisted
    func resetTargetWord() {
        self.targetWord = WordDatabaseHelper.shared.fetchRandomFiveLetterWord(withDifficulty: gameDifficulty);
    }
    
    /// Resets all values back to default so the model can be persisted
    func resetToDefaults() {
        self.gameMode = .standardMode
        self.gameDifficulty = .normal
        self.timeLimit = 0
    }
}

