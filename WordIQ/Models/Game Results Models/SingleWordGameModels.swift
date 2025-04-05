import Foundation

/// Defines the game model structure for a standard game result
struct StandardGameModel : SingleWordGame, WinnableGame, VariableDifficulty {
    var date: Date
    var difficulty: GameDifficulty
    var numberOfInvalidGuesses: Int
    var numberOfValidGuesses: Int
    var result: GameResult
    var targetWord: DatabaseWordModel
    var timeElapsed: Int
}

/// Defines the game model structure for a rush game result
struct RushGameModel : SingleWordGame, TimedGame, WinnableGame, VariableDifficulty {
    var date: Date
    var difficulty: GameDifficulty
    var numberOfInvalidGuesses: Int
    var numberOfValidGuesses: Int
    var result: GameResult
    var targetWord: DatabaseWordModel
    var timeElapsed: Int
    var timeLimit: Int
}

/// Defines the game model structure for a zen game result
struct ZenGameModel : SingleWordGame, VariableDifficulty {
    var date: Date
    var difficulty: GameDifficulty
    var numberOfInvalidGuesses: Int
    var numberOfValidGuesses: Int
    var result: GameResult
    var targetWord: DatabaseWordModel
    var timeElapsed: Int
}
