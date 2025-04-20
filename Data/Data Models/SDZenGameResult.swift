import Foundation
import SwiftData

/// Swift Data model of a zen game result
@Model
class SDZenGameResult: SDGameResult, SDDifficultyChangable {

    var date: Date
    var difficulty: GameDifficulty
    var gameMode: GameMode
    var numberOfCorrectWords: Int = 1
    var numberOfInvalidGuesses: Int
    var numberOfValidGuesses: Int
    var startWord: String?
    var timeElapsed: Int

    init(date: Date = .now,
         difficulty: GameDifficulty,
         gameMode: GameMode = .standardMode,
         numberOfInvalidGuesses: Int,
         numberOfValidGuesses: Int,
         startWord: String? = nil,
         timeElapsed: Int) {
        self.date = date
        self.difficulty = difficulty
        self.gameMode = gameMode
        self.numberOfInvalidGuesses = numberOfInvalidGuesses
        self.numberOfValidGuesses = numberOfValidGuesses
        self.startWord = startWord
        self.timeElapsed = timeElapsed
    }
    
    convenience init(_ gameModel: ZenGameModel) {
        self.init(difficulty: gameModel.difficulty,
                  numberOfInvalidGuesses: gameModel.numberOfInvalidGuesses,
                  numberOfValidGuesses: gameModel.numberOfValidGuesses,
                  startWord: gameModel.startWord,
                  timeElapsed: gameModel.timeElapsed)
    }
    
    convenience init(_ gameOverData: GameOverDataModel) {
        self.init(difficulty: gameOverData.difficulty,
                  numberOfInvalidGuesses: gameOverData.numberOfInvalidGuesses,
                  numberOfValidGuesses: gameOverData.numberOfValidGuesses,
                  startWord: gameOverData.startWord,
                  timeElapsed: gameOverData.timeElapsed)
    }
}

