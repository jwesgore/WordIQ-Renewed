import Foundation

/// Model to more easily pass around data for the end of a game
struct GameOverModel {
    
    var gameMode: GameMode
    var gameResult: GameResult
    var gameDifficulty: GameDifficulty
    
    var numCorrectWords: Int
    var numValidGuesses: Int
    var numInvalidGuesses: Int
    
    var date: Date
    var timeLimit: Int?
    var timeElapsed: Int
    var timeRemaining: Int?
    var xp: Int
    
    var targetWord: GameWordModel
    var lastGuessedWord: GameWordModel?
    
    // Frenzy mode specific
    var correctlyGuessedWords: [GameWordModel]?
    
    /// Initializer for start of game
    init(gameOptions: GameModeOptionsModel, targetWord: GameWordModel) {
        self.gameMode = gameOptions.gameMode
        self.gameResult = .na
        self.gameDifficulty = gameOptions.gameDifficulty
        
        self.numCorrectWords = 0
        self.numValidGuesses = 0
        self.numInvalidGuesses = 0
        
        self.date = Date.now
        
        self.timeElapsed = 0
        self.timeElapsed = 0
        self.xp = 0
        
        self.targetWord = targetWord
        
        if gameOptions.gameMode == .frenzygame {
            self.timeLimit = gameOptions.timeLimit
            self.correctlyGuessedWords = [GameWordModel]()
        } else if gameOptions.gameMode == .rushgame {
            self.timeLimit = gameOptions.timeLimit
        }
    }
}
