import Foundation

/// Model used for passing around data while game is in progress
class GameSaveStateModel : Codable {
    
    var gameMode: Int
    var gameResult: Int
    var gameDifficulty: Int
    
    var numCorrectWords: Int
    var numValidGuesses: Int
    var numInvalidGuesses: Int
    
    var date: Date
    var timeLimit: Int?
    var timeElapsed: Int
    var timeRemaining: Int?
    var xp: Int
    
    var targetWord: String
    var lastGuessedWord: String?
    
    // Frenzy mode specific
    var correctlyGuessedWords: [String]?
    
    init(gameOverModel : GameOverDataModel) {
        self.gameMode = gameOverModel.gameMode.id
        self.gameResult = gameOverModel.gameResult.id
        self.gameDifficulty = gameOverModel.gameDifficulty.id
        
        self.numCorrectWords = gameOverModel.numCorrectWords
        self.numValidGuesses = gameOverModel.numValidGuesses
        self.numInvalidGuesses = gameOverModel.numInvalidGuesses
        
        self.date = gameOverModel.date
        self.timeLimit = gameOverModel.timeLimit
        self.timeElapsed = gameOverModel.timeElapsed
        self.timeRemaining = gameOverModel.timeRemaining
        self.xp = gameOverModel.xp
        
        self.targetWord = gameOverModel.targetWord.word
        self.lastGuessedWord = gameOverModel.targetWord.word
        
        if let correctlyGuessedWords = gameOverModel.correctlyGuessedWords {
            self.correctlyGuessedWords = correctlyGuessedWords.map { $0.word }
        } else {
            self.correctlyGuessedWords = nil
        }
    }
    
    func getGameOverModel() -> GameOverDataModel  {
        return GameOverDataModel(
            gameMode: GameMode.fromId(gameMode)!,
            gameResult: GameResult.fromId(gameResult),
            gameDifficulty: GameDifficulty.fromId(gameDifficulty)!,
            numCorrectWords: numCorrectWords,
            numValidGuesses: numValidGuesses,
            numInvalidGuesses: numInvalidGuesses,
            date: date,
            timeLimit: timeLimit,
            timeElapsed: timeElapsed,
            timeRemaining: timeRemaining,
            xp: xp,
            targetWord: GameWordModel(targetWord),
            lastGuessedWord: GameWordModel(lastGuessedWord!),
            correctlyGuessedWords: correctlyGuessedWords?.map { GameWordModel($0) }
        )
    }
}
