import Foundation

/// Defines the game model structure for a frenzy game result
struct FrenzyGameModel : MultiWordGame, TimedGame, VariableDifficulty {
    var correctWords: [DatabaseWordModel]
    var date: Date
    var difficulty: GameDifficulty
    var numberOfInvalidGuesses: Int
    var numberOfValidGuesses: Int
    var startWord: String?
    var targetWords: [DatabaseWordModel]
    var timeElapsed: Int
    var timeLimit: Int
}

/// Defines the game model structure for a quad standard game result
struct QuadStandardGameModel : MultiWordGame, WinnableGame {
    var correctWords: [DatabaseWordModel]
    var date: Date
    var numberOfInvalidGuesses: Int
    var numberOfValidGuesses: Int
    var result: GameResult
    var startWord: String?
    var targetWords: [DatabaseWordModel]
    var timeElapsed: Int
}

/// Defines the structure for a twenty questions game results
struct TwentyQuestionsGameModel : MultiWordGame, WinnableGame {
    var correctWords: [DatabaseWordModel]
    var date: Date
    var numberOfInvalidGuesses: Int
    var numberOfValidGuesses: Int
    var result: GameResult
    var startWord: String?
    var targetWords: [DatabaseWordModel]
    var timeElapsed: Int
}
