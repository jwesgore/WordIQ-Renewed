import SwiftUI

/// Model used to package up game mode options
struct GameModeOptionsModel {
    var gameMode: GameMode
    var gameDifficulty: GameDifficulty
    var timeLimit: Int
    var targetWord: GameWordModel
    
    /// Initializer that presets the target word
    init(gameMode: GameMode, gameDifficulty: GameDifficulty, timeLimit: Int) {
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
}
