/// Base protocol for a stats model
protocol GameStatsModel {
    var averageTimePerGame: Int { get }
    var averageTimePerWord: Int { get }
    var averageTimePerGuess: Int { get }
    
    var totalGuessesMade: Int { get set }
    var totalValidGuesses: Int { get set }
    var totalInvalidGuesses: Int { get set }
    var totalGamesPlayed: Int { get set }
    var totalCorrectWords: Int { get set }
    var totalTimePlayed: Int { get set }
}

/// Protocol for a stats model which can be winnable
protocol WinnableStat {
    var bestStreak: Int { get set }
    var currentStreak: Int { get set }
    var totalLoses: Int { get }
    var totalWins: Int { get set }
    var winRate: Double { get }
}
