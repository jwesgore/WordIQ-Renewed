import SwiftUI

/// Model used to package up game mode options
class FourWordGameModeOptionsModel : FourWordGameOptionsProtocol {
    
    var gameMode: GameMode
    var gameDifficulty: GameDifficulty
    var targetWords: [DatabaseWordModel]
    var timeLimit: Int
    
    init (gameDifficulty: GameDifficulty, timeLimit: Int, targetWords: [DatabaseWordModel]) {
        self.gameMode = .quadWordMode
        self.gameDifficulty = gameDifficulty
        self.timeLimit = timeLimit
        self.targetWords = targetWords
    }
    
    convenience init() {
        let targetWords = WordDatabaseHelper.shared.fetchMultipleRandomFiveLetterWord(withDifficulty: .normal, count: 4)
        self.init(gameDifficulty: .normal, timeLimit: 0, targetWords: targetWords)
    }
    
    /// Resets the target word so the model can be persisted
    func resetTargetWords() {
        self.targetWords = WordDatabaseHelper.shared.fetchMultipleRandomFiveLetterWord(withDifficulty: gameDifficulty, count: 4)
    }
    
    func resetToDefaults() {
        gameDifficulty = .normal
        timeLimit = 0
        resetTargetWords()
    }
    
}
