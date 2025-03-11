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
    init(gameOptions: GameModeOptionsModel) {
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
        
        if gameOptions.gameMode == .frenzygame {
            self.timeLimit = gameOptions.timeLimit
            self.correctlyGuessedWords = [GameWordModel]()
        } else if gameOptions.gameMode == .rushgame {
            self.timeLimit = gameOptions.timeLimit
        }
    }
    
    /// Explicit initializer
    init(
        gameMode: GameMode,
        gameResult: GameResult = .na,
        gameDifficulty: GameDifficulty,
        numCorrectWords: Int = 0,
        numValidGuesses: Int = 0,
        numInvalidGuesses: Int = 0,
        date: Date = Date(),
        timeLimit: Int? = nil,
        timeElapsed: Int = 0,
        timeRemaining: Int? = nil,
        xp: Int = 0,
        targetWord: GameWordModel,
        lastGuessedWord: GameWordModel? = nil,
        correctlyGuessedWords: [GameWordModel]? = nil
    ) {
        self.gameMode = gameMode
        self.gameResult = gameResult
        self.gameDifficulty = gameDifficulty
        self.numCorrectWords = numCorrectWords
        self.numValidGuesses = numValidGuesses
        self.numInvalidGuesses = numInvalidGuesses
        self.date = date
        self.timeLimit = timeLimit
        self.timeElapsed = timeElapsed
        self.timeRemaining = timeRemaining
        self.xp = xp
        self.targetWord = targetWord
        self.lastGuessedWord = lastGuessedWord
        self.correctlyGuessedWords = correctlyGuessedWords
    }

}
