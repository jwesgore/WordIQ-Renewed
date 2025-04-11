import Foundation

protocol SDGameResult {
    var date: Date { get set }
    var gameMode: GameMode { get set }
    var numberOfCorrectWords: Int { get set }
    var numberOfInvalidGuesses: Int { get set }
    var numberOfValidGuesses: Int { get set }
    var timeElapsed: Int { get set }
}

protocol SDDaily {
    var dailyId: Int { get set }
}

protocol SDDifficultyChangable {
    var difficulty: GameDifficulty { get set }
}

protocol SDWinnable {
    var result: GameResult { get set }
}

protocol SDTimable {
    var timeLimit: Int { get set }
}
