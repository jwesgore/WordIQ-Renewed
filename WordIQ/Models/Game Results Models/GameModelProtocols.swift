import Foundation

// MARK: - Base model definitions
/// Base definition for a game
protocol WordGame {
    var date: Date { get set }
    var numberOfInvalidGuesses: Int { get set }
    var numberOfValidGuesses: Int { get set }
    var startWord: String? { get set }
    var timeElapsed: Int { get set }
}

/// Base definition for a game with only one target word
protocol SingleWordGame : WordGame {
    var targetWord: DatabaseWordModel { get set }
}

/// Base definition for a game with multiple target words
protocol MultiWordGame : WordGame {
    var correctWords: [DatabaseWordModel] { get set }
    var targetWords: [DatabaseWordModel] { get set }
}

// MARK: - Possible game properties
/// Defines a game as being timed
protocol TimedGame {
    var timeLimit: Int { get set }
}

/// Defines a game as being winnable
protocol WinnableGame {
    var result: GameResult { get set }
}

/// Defines a game mode where the difficulty can be changed
protocol VariableDifficulty {
    var difficulty: GameDifficulty { get set }
}

/// Defines a game mode as having a daily version
protocol Daily : WinnableGame {
    var dailyId: Int { get set }
}
