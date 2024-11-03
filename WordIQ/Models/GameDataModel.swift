import Foundation

///  Model to preserve game data after a game has been played
struct GameDataModel {
    
    // Game Settings
    var gameMode: GameMode
    var gameResult: GameResult
    var gameDifficulty: GameDifficulty
    
    var numCorrectWords: Int
    var numValidGuesses: Int
    var numInvalidGuesses: Int
    
    var date: Date
    var timeLimit: Int
    var timeElapsed: Int
    var timeRemaining: Int
    var xp: Int
    
    var correctWord: String
    var lastGuessedWord: String
}
