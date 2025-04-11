import Foundation
import SwiftData

/// Swift Data model of a frenzy game result
@Model
class SDFrenzyGameResult: SDGameResult, SDDifficultyChangable, SDTimable {

    var date: Date
    var difficulty: GameDifficulty
    var gameMode: GameMode
    var numberOfCorrectWords: Int
    var numberOfInvalidGuesses: Int
    var numberOfValidGuesses: Int
    var timeElapsed: Int
    var timeLimit: Int

    init(date: Date = .now,
         difficulty: GameDifficulty,
         gameMode: GameMode = .standardMode,
         numberOfCorrectWords: Int,
         numberOfInvalidGuesses: Int,
         numberOfValidGuesses: Int,
         timeElapsed: Int,
         timeLimit: Int) {
        self.date = date
        self.difficulty = difficulty
        self.gameMode = gameMode
        self.numberOfCorrectWords = numberOfCorrectWords
        self.numberOfInvalidGuesses = numberOfInvalidGuesses
        self.numberOfValidGuesses = numberOfValidGuesses
        self.timeElapsed = timeElapsed
        self.timeLimit = timeLimit
    }
    
    convenience init(_ gameModel: FrenzyGameModel) {
        self.init(difficulty: gameModel.difficulty,
                  numberOfCorrectWords: gameModel.correctWords.count,
                  numberOfInvalidGuesses: gameModel.numberOfInvalidGuesses,
                  numberOfValidGuesses: gameModel.numberOfValidGuesses,
                  timeElapsed: gameModel.timeElapsed,
                  timeLimit: gameModel.timeLimit)
    }
    
    convenience init(_ gameOverData: GameOverDataModel) {
        self.init(difficulty: gameOverData.difficulty,
                  numberOfCorrectWords: gameOverData.targetWordsCorrect.count,
                  numberOfInvalidGuesses: gameOverData.numberOfInvalidGuesses,
                  numberOfValidGuesses: gameOverData.numberOfValidGuesses,
                  timeElapsed: gameOverData.timeElapsed,
                  timeLimit: gameOverData.timeLimit)
    }
}
