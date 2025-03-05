import SwiftUI

/// Model used to package up game mode options
class GameModeOptionsModel {
    var gameMode: GameMode
    var gameDifficulty: GameDifficulty
    var timeLimit: Int
    var targetWord: GameWordModel
    
    /// Initializer that presets the target word
    init(gameMode: GameMode = .standardgame, gameDifficulty: GameDifficulty = .normal, timeLimit: Int = 0) {
        self.gameMode = gameMode
        self.gameDifficulty = gameDifficulty
        self.timeLimit = timeLimit
        self.targetWord = WordDatabaseHelper.shared.fetchRandomWord(withDifficulty: gameDifficulty)
    }
    
    /// Initializer that takes in a target word
    init(gameMode: GameMode, gameDifficulty: GameDifficulty, timeLimit: Int, targetWord: GameWordModel) {
        self.gameMode = gameMode
        self.gameDifficulty = gameDifficulty
        self.timeLimit = timeLimit
        self.targetWord = targetWord
    }
    
    /// Resets the target word so the model can be persisted
    func resetTargetWord() {
        self.targetWord = WordDatabaseHelper.shared.fetchRandomWord(withDifficulty: gameDifficulty);
    }
    
    /// Resets all values back to default so the model can be persisted
    func resetToDefaults() {
        self.gameMode = .standardgame
        self.gameDifficulty = .normal
        self.timeLimit = 0
    }
}
