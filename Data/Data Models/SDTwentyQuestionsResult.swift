import Foundation
import SwiftData

/// Swift Data model of a twenty questions game result
@Model
class SDTwentyQuestionsResult: SDGameResult, SDWinnable {
    
    var date: Date
    var gameMode: GameMode
    var numberOfCorrectWords: Int
    var numberOfInvalidGuesses: Int
    var numberOfValidGuesses: Int
    var result: GameResult
    var startWord: String?
    var timeElapsed: Int
    
    init(date: Date = .now,
         gameMode: GameMode = .twentyQuestions,
         numberOfInvalidGuesses: Int,
         numberOfValidGuesses: Int,
         result: GameResult,
         startWord: String? = nil,
         timeElapsed: Int) {
        self.date = date
        self.gameMode = gameMode
        self.numberOfCorrectWords = result == .win ? 1 : 0
        self.numberOfInvalidGuesses = numberOfInvalidGuesses
        self.numberOfValidGuesses = numberOfValidGuesses
        self.result = result
        self.startWord = startWord
        self.timeElapsed = timeElapsed
    }
    
    convenience init(_ gameOverData: GameOverDataModel) {
        self.init(numberOfInvalidGuesses: gameOverData.numberOfInvalidGuesses,
                  numberOfValidGuesses: gameOverData.numberOfValidGuesses,
                  result: gameOverData.gameResult,
                  startWord: gameOverData.startWord,
                  timeElapsed: gameOverData.timeElapsed)
    }
}
