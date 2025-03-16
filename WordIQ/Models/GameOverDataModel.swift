import Foundation

/// Model to more easily pass around data for the end of a game
struct GameOverDataModel : Codable {
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
    
    var targetWord: DatabaseWordModel
    var lastGuessedWord: GameWordModel?
    
    // Frenzy mode specific
    var correctlyGuessedWords: [GameWordModel]?
}


extension GameOverDataModel {
    /// Initializer for start of game
    init(_ gameOptions: GameModeOptionsModel) {
        self.gameMode = gameOptions.gameMode
        self.gameResult = .na
        self.gameDifficulty = gameOptions.gameDifficulty
        
        self.numCorrectWords = 0
        self.numValidGuesses = 0
        self.numInvalidGuesses = 0
        
        self.date = Date.now
        
        self.timeElapsed = 0
        self.xp = 0
        
        self.targetWord = gameOptions.targetWord
        
        if gameOptions.gameMode == .frenzyMode {
            self.timeLimit = gameOptions.timeLimit
            self.correctlyGuessedWords = [GameWordModel]()
        } else if gameOptions.gameMode == .rushMode {
            self.timeLimit = gameOptions.timeLimit
        }
    }
    
    /// Initializer for reading in from database
    init(_ gameResults: GameResultsModel) {
        self.gameMode = GameMode.fromId(Int(gameResults.gameMode))!
        self.gameResult = GameResult.fromId(Int(gameResults.gameResult))
        self.gameDifficulty = GameDifficulty.fromId(Int(gameResults.gameDifficulty))!
        self.numCorrectWords = Int(gameResults.numCorrectWords)
        self.numValidGuesses = Int(gameResults.numValidGuesses)
        self.numInvalidGuesses = Int(gameResults.numInvalidGuesses)
        self.date = gameResults.date!
        self.timeLimit = Int(gameResults.timeLimit)
        self.timeElapsed = Int(gameResults.timeElapsed)
        self.xp = Int(gameResults.xp)
        self.targetWord = DatabaseWordModel(daily: gameResults.targetWordDaily,
                                            difficulty: gameResults.gameDifficulty,
                                            word: gameResults.targetWord)
    }
}
