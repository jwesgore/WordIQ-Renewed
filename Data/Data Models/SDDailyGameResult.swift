import Foundation
import SwiftData

/// Swift Data model of a standard game result
@Model
class SDDailyGameResult: SDGameResult, SDDaily, SDWinnable {

    var dailyId: Int
    var date: Date
    var difficulty: GameDifficulty
    var gameMode: GameMode
    var numberOfCorrectWords: Int
    var numberOfInvalidGuesses: Int
    var numberOfValidGuesses: Int
    var result: GameResult
    var startWord: String?
    var timeElapsed: Int
    
    init(dailyId: Int,
         date: Date = .now,
         difficulty: GameDifficulty,
         gameMode: GameMode = .standardMode,
         numberOfInvalidGuesses: Int,
         numberOfValidGuesses: Int,
         result: GameResult,
         startWord: String? = nil,
         timeElapsed: Int) {
        self.dailyId = dailyId
        self.date = date
        self.difficulty = difficulty
        self.gameMode = gameMode
        self.numberOfCorrectWords = result == .win ? 1 : 0
        self.numberOfInvalidGuesses = numberOfInvalidGuesses
        self.numberOfValidGuesses = numberOfValidGuesses
        self.result = result
        self.startWord = startWord
        self.timeElapsed = timeElapsed
    }
    
    convenience init(_ gameModel: StandardGameModel) {
        self.init(dailyId: gameModel.targetWord.daily,
                  difficulty: gameModel.difficulty,
                  numberOfInvalidGuesses: gameModel.numberOfInvalidGuesses,
                  numberOfValidGuesses: gameModel.numberOfValidGuesses,
                  result: gameModel.result,
                  startWord: gameModel.startWord,
                  timeElapsed: gameModel.timeElapsed)
    }
    
    convenience init(_ gameOverData: GameOverDataModel) {
        self.init(dailyId: gameOverData.currentTargetWord?.daily ?? 0,
                  difficulty: gameOverData.difficulty,
                  numberOfInvalidGuesses: gameOverData.numberOfInvalidGuesses,
                  numberOfValidGuesses: gameOverData.numberOfValidGuesses,
                  result: gameOverData.gameResult,
                  startWord: gameOverData.startWord,
                  timeElapsed: gameOverData.timeElapsed)
    }
}
