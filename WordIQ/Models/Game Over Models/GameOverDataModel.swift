import Foundation

/// Model to more easily pass around data for the end of a game
class GameOverDataModel : GameOverData {
    var date: Date
    var difficulty: GameDifficulty
    var gameMode: GameMode
    var gameResult: GameResult
    var numberOfInvalidGuesses: Int
    var numberOfValidGuesses: Int
    var targetWords: OrderedDictionaryCodable<UUID, DatabaseWordModel>
    var targetWordsBackgrounds: OrderedDictionaryCodable<UUID, [LetterComparison]>
    var targetWordsCorrect: [UUID]
    var timeElapsed: Int
    var timeLimit: Int
    var timeRemaining: Int
    
    var currentTargetWord: DatabaseWordModel? { targetWords.lastValue }
    
    // MARK: - Initializers
    /// Explicit initializer with defaults
    init(date: Date = Date.now,
         difficulty: GameDifficulty,
         gameMode: GameMode,
         gameResult: GameResult = .na,
         numberOfInvalidGuesses: Int = 0,
         numberOfValidGuesses: Int = 0,
         targetWords: OrderedDictionaryCodable<UUID, DatabaseWordModel> = OrderedDictionaryCodable<UUID, DatabaseWordModel>(),
         targetWordsBackgrounds: OrderedDictionaryCodable<UUID, [LetterComparison]> = OrderedDictionaryCodable<UUID, [LetterComparison]>(),
         targetWordsCorrect: [UUID] = [],
         timeElapsed: Int = 0,
         timeLimit: Int = 0,
         timeRemaining: Int = 0) {
        self.date = date
        self.difficulty = difficulty
        self.gameMode = gameMode
        self.gameResult = gameResult
        self.numberOfInvalidGuesses = numberOfInvalidGuesses
        self.numberOfValidGuesses = numberOfValidGuesses
        self.targetWords = targetWords
        self.targetWordsBackgrounds = targetWordsBackgrounds
        self.targetWordsCorrect = targetWordsCorrect
        self.timeElapsed = timeElapsed
        self.timeLimit = timeLimit
        self.timeRemaining = timeRemaining
    }
    
    /// SingleBoardGameOptionsModel initializer
    convenience init(_ gameOptions: SingleBoardGameOptionsModel) {
        self.init(difficulty: gameOptions.gameDifficulty, gameMode: gameOptions.gameMode, timeLimit: gameOptions.timeLimit)
        
        let id = gameOptions.targetWord.id
        
        targetWords[id] = gameOptions.targetWord
        targetWordsBackgrounds[id] = LetterComparison.getCollection(size: gameOptions.targetWord.word.count, value: .notSet)
    }
    
    /// MultiBoardGameOptionsModel initializer
    convenience init(_ gameOptions: MultiBoardGameOptionsModel) {
        self.init(difficulty: gameOptions.gameDifficulty, gameMode: gameOptions.gameMode, timeLimit: gameOptions.timeLimit)
        
        for (id, targetWord) in gameOptions.targetWords {
            targetWords[id] = targetWord
            targetWordsBackgrounds[id] = LetterComparison.getCollection(size: targetWord.word.count, value: .notSet)
        }
    }
    
    // MARK: - Functions
    /// Adds a correct word to the collection
    func addCorrectGuess(_ word: DatabaseWordModel, id: UUID? = nil) {
        let id = id ?? word.id
        
        targetWords[id] = word
        targetWordsBackgrounds[id] = LetterComparison.getCollection(size: word.word.count, value: .correct)
        targetWordsCorrect.append(id)
        
        numberOfValidGuesses += 1
    }
    
    /// Adds a correct word to the collection via the id of the word
    func addCorrectGuess(id: UUID) {
        if let word = targetWords[id] {
            self.addCorrectGuess(word)
        }
    }
    
    /// adds the updated backgrounds for an incorrect word
    func addIncorrectGuess(_ id: UUID, comparisons: [LetterComparison]) {
        targetWordsBackgrounds[id] = comparisons
        numberOfValidGuesses += 1
    }
    
    /// adds a new word to the target word list
    func addNewWord(_ word: DatabaseWordModel, id: UUID? = nil) {
        let id = id ?? word.id
        
        targetWords[id] = word
        targetWordsBackgrounds[id] = LetterComparison.getCollection(size: word.word.count, value: .notSet)
    }
    
    /// Gets a SingleWordGameOverViewModel based on current values
    func getGameOverViewModel() -> SingleWordGameOverViewModel {
        return SingleWordGameOverViewModel(self)
    }
}
