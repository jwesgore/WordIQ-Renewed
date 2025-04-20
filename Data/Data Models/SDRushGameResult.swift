import Foundation
import SwiftData

/// Swift Data model of a rush game result
@Model
class SDRushGameResult: SDGameResult, SDDifficultyChangable, SDWinnable, SDTimable {

    var date: Date
    var difficulty: GameDifficulty
    var gameMode: GameMode
    var numberOfCorrectWords: Int
    var numberOfInvalidGuesses: Int
    var numberOfValidGuesses: Int
    var result: GameResult
    var startWord: String?
    var timeElapsed: Int
    var timeLimit: Int

    init(date: Date = .now,
         difficulty: GameDifficulty,
         gameMode: GameMode = .standardMode,
         numberOfInvalidGuesses: Int,
         numberOfValidGuesses: Int,
         result: GameResult,
         startWord: String? = nil,
         timeElapsed: Int,
         timeLimit: Int) {
        self.date = date
        self.difficulty = difficulty
        self.gameMode = gameMode
        self.numberOfCorrectWords = result == .win ? 1 : 0
        self.numberOfInvalidGuesses = numberOfInvalidGuesses
        self.numberOfValidGuesses = numberOfValidGuesses
        self.result = result
        self.startWord = startWord
        self.timeElapsed = timeElapsed
        self.timeLimit = timeLimit
    }
    
    convenience init(_ gameModel: RushGameModel) {
        self.init(difficulty: gameModel.difficulty,
                  numberOfInvalidGuesses: gameModel.numberOfInvalidGuesses,
                  numberOfValidGuesses: gameModel.numberOfValidGuesses,
                  result: gameModel.result,
                  startWord: gameModel.startWord,
                  timeElapsed: gameModel.timeElapsed,
                  timeLimit: gameModel.timeLimit)
    }
    
    convenience init(_ gameOverData: GameOverDataModel) {
        self.init(difficulty: gameOverData.difficulty,
                  numberOfInvalidGuesses: gameOverData.numberOfInvalidGuesses,
                  numberOfValidGuesses: gameOverData.numberOfValidGuesses,
                  result: gameOverData.gameResult,
                  startWord: gameOverData.startWord,
                  timeElapsed: gameOverData.timeElapsed,
                  timeLimit: gameOverData.timeLimit)
    }
}
