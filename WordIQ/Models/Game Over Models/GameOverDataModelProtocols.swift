import Foundation

/// Base protocol for game over data
protocol GameOverData : Codable {
    var date: Date { get set }
    var difficulty: GameDifficulty { get set }
    var gameMode: GameMode { get set }
    var gameResult: GameResult { get set }
    
    var numberOfInvalidGuesses: Int { get set }
    var numberOfValidGuesses: Int { get set }
    
    var startWord: String? { get set }
    
    var targetWords: OrderedDictionaryCodable<UUID, DatabaseWordModel> { get set }
    var targetWordsBackgrounds: OrderedDictionaryCodable<UUID, [LetterComparison]> { get set }
    var targetWordsCorrect: [UUID] { get set }
    
    var timeElapsed: Int { get set }
    var timeLimit: Int { get set }
    var timeRemaining: Int { get set }
}
