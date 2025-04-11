import Foundation
import SwiftData

/// Swift Data model of a frenzy game result
@Model
class SDQuadStandardGameResult: SDGameResult, SDWinnable {
    
    var date: Date
    var gameMode: GameMode
    var numberOfCorrectWords: Int
    var numberOfInvalidGuesses: Int
    var numberOfValidGuesses: Int
    var result: GameResult
    var timeElapsed: Int

    init(date: Date = .now,
         gameMode: GameMode = .standardMode,
         numberOfCorrectWords: Int,
         numberOfInvalidGuesses: Int,
         numberOfValidGuesses: Int,
         result: GameResult,
         timeElapsed: Int) {
        self.date = date
        self.gameMode = gameMode
        self.numberOfCorrectWords = numberOfCorrectWords
        self.numberOfInvalidGuesses = numberOfInvalidGuesses
        self.numberOfValidGuesses = numberOfValidGuesses
        self.result = result
        self.timeElapsed = timeElapsed
    }
    
    convenience init(_ gameModel: QuadStandardGameModel) {
        self.init(numberOfCorrectWords: gameModel.correctWords.count,
                  numberOfInvalidGuesses: gameModel.numberOfInvalidGuesses,
                  numberOfValidGuesses: gameModel.numberOfValidGuesses,
                  result: gameModel.result,
                  timeElapsed: gameModel.timeElapsed)
    }
    
    convenience init(_ gameOverData: GameOverDataModel) {
        self.init(numberOfCorrectWords: gameOverData.targetWordsCorrect.count,
                  numberOfInvalidGuesses: gameOverData.numberOfInvalidGuesses,
                  numberOfValidGuesses: gameOverData.numberOfValidGuesses,
                  result: gameOverData.gameResult,
                  timeElapsed: gameOverData.timeElapsed)
    }
}
