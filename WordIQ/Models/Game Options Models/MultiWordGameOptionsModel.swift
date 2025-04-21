import SwiftUI

/// Model used to package up game mode options
class MultiWordGameOptionsModel : MultiWordGameOptions {
    
    var gameMode: GameMode
    var gameDifficulty: GameDifficulty
    var targetWords: OrderedDictionaryCodable<UUID, DatabaseWordModel>
    var timeLimit: Int
    
    init (gameMode: GameMode, gameDifficulty: GameDifficulty, timeLimit: Int, targetWords: [DatabaseWordModel]) {
        var targetWordsDict = OrderedDictionaryCodable<UUID, DatabaseWordModel>()
        
        for word in targetWords {
            targetWordsDict[word.id] = word
        }
        
        self.gameMode = gameMode
        self.gameDifficulty = gameDifficulty
        self.timeLimit = timeLimit
        self.targetWords = targetWordsDict
    }
    
    convenience init(gameMode: GameMode = .quadWordMode) {
        let targetWordCount = 4

        let targetWords = WordDatabaseClient.shared.fetchMultipleRandomFiveLetterWord(withDifficulty: .normal, count: targetWordCount)
        self.init(gameMode: gameMode, gameDifficulty: .normal, timeLimit: 0, targetWords: targetWords)
    }
    
    /// Gets the view model for the set game mode options
    func getFourWordGameViewModel() -> FourWordGameViewModel {
        gameMode = .quadWordMode
        return FourWordGameViewModel(gameOptions: self)
    }
    
    /// Gets a fresh game over data model base on current settings
    func getMultiBoardGameOverDataModelTemplate() -> GameOverDataModel {
        return GameOverDataModel(self)
    }
    
    /// Resets the target word so the model can be persisted
    func resetTargetWords(withResetKeys: Bool = false) {
        let targetWordCount = 4
        let newWords = WordDatabaseClient.shared.fetchMultipleRandomFiveLetterWord(withDifficulty: gameDifficulty, count: targetWordCount)
        
        if withResetKeys {
            targetWords.clear()
            for newWord in newWords {
                targetWords[newWord.id] = newWord
            }
        } else {
            for (id, newWord) in zip(targetWords.allKeys, newWords) {
                targetWords[id] = newWord
            }
        }
    }
    
    func resetToDefaults() {
        gameDifficulty = .normal
        timeLimit = 0
        resetTargetWords()
    }
}
