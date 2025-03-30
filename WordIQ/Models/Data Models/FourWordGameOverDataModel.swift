import Foundation

/// Model to more easily pass around data for the end of a game
struct FourWordGameOverDataModel : Codable {
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
    
    var targetWords: OrderedDictionaryCodable<UUID, DatabaseWordModel>
    var targetWordsBackgrounds: OrderedDictionaryCodable<UUID, [LetterComparison]>
    var lastGuessedWord: GameWordModel?

    var correctlyGuessedWords: [GameWordModel]
}

extension FourWordGameOverDataModel {
    init (_ gameOptions: FourWordGameModeOptionsModel) {
        self.gameMode = gameOptions.gameMode
        self.gameResult = .na
        self.gameDifficulty = gameOptions.gameDifficulty
        
        self.numCorrectWords = 0
        self.numValidGuesses = 0
        self.numInvalidGuesses = 0
        
        self.date = Date.now
                
        self.targetWords = gameOptions.targetWords
        self.targetWordsBackgrounds = OrderedDictionaryCodable<UUID, [LetterComparison]>()
        self.timeElapsed = 0
        self.timeLimit = gameOptions.timeLimit
        self.xp = 0
        
        self.correctlyGuessedWords = []
        
        for (id, word) in gameOptions.targetWords {
            self.targetWordsBackgrounds[id] = [LetterComparison](repeating: .notSet, count: word.word.count)
        }
    }
}
