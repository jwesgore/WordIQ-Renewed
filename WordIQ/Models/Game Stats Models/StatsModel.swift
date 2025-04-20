
struct StatsModel: GameStatsModel, WinnableStat {
    // MARK: - Set Properties
    var bestStreak: Int = 0
    var currentStreak: Int = 0
    var guessDistribution = DefaultDictionary<Int, Int>(defaultValue: 0)
    var startWordFrequency = DefaultDictionary<String, Int>(defaultValue: 0)
    var totalCorrectWords: Int = 0
    var totalGamesPlayed: Int = 0
    var totalGuessesMade: Int = 0
    var totalInvalidGuesses: Int = 0
    
    var totalTimePlayed: Int = 0
    var totalValidGuesses: Int = 0
    var totalWins: Int = 0
    
    // MARK: - Computed Properties
    var averageGuessesPerGame: Int {
        guard totalGamesPlayed > 0 else { return 0 }
        return totalValidGuesses / totalGamesPlayed
    }
    
    var averageTimePerGame: Int {
        guard totalGamesPlayed > 0 else { return 0 }
        return totalTimePlayed / totalGamesPlayed
    }
    
    var averageTimePerGuess: Int {
        guard totalValidGuesses > 0 else { return 0 }
        return totalTimePlayed / totalValidGuesses
    }
    
    var averageTimePerWord: Int {
        guard totalCorrectWords > 0 else { return 0 }
        return totalTimePlayed / totalCorrectWords
    }
    
    var totalLoses: Int {
        return totalGamesPlayed - totalWins
    }
    
    var winRate: Double {
        guard totalGamesPlayed > 0 else { return 0.0 }
        return Double(totalWins) / Double(totalGamesPlayed)
    }
}
