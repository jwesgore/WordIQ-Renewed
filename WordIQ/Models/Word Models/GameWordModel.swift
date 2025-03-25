/// Struct to hold functionality for basic game words
struct GameWordModel : Equatable, Codable, Hashable {
    var word : String
    var letters : [ValidCharacters]
    
    /// Equatable Conformance
    static func == (lhs: GameWordModel, rhs: GameWordModel) -> Bool {
        return lhs.letters == rhs.letters
    }
    
    static func == (lhs: GameWordModel, rhs: DatabaseWordModel) -> Bool {
        return lhs == GameWordModel(rhs)
    }
    
    static func == (lhs: DatabaseWordModel, rhs: GameWordModel) -> Bool {
        return rhs == lhs
    }
    
    /// Hashable Conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(word)
    }
}

/// Extra initializers
extension GameWordModel {
    init(_ word: String) {
        self.word = word
        self.letters = word.compactMap { ValidCharacters.from($0) }
    }
    
    init(_ databaseWordModel: DatabaseWordModel) {
        self.word = databaseWordModel.word
        self.letters = databaseWordModel.word.compactMap { ValidCharacters.from($0) }
    }
}

/// Comparison Functions
extension GameWordModel {
    /// Function to retrieve a comparison between two words
    func comparison(_ incoming: GameWordModel) -> [LetterComparison] {
        
        var comparison = [LetterComparison](repeating: .wrong, count: 5)
        
        // Create a map of the number of times a letter shows up
        var letterCount = [ValidCharacters: Int]()
        for letter in self.letters {
            letterCount[letter, default: 0] += 1
        }
        
        // Flag all the correct letters
        for i in 0..<5 {
            if self.letters[i] == incoming.letters[i] {
                comparison[i] = .correct
                if let count = letterCount[self.letters[i]], count > 0 {
                    letterCount[self.letters[i]] = count - 1
                }
            }
        }
        
        // Flag all the letters which are not in the correct position
        for i in 0..<5 {
            if comparison[i] == .wrong && self.letters.contains(incoming.letters[i]) {
                if let count = letterCount[incoming.letters[i]], count > 0 {
                    comparison[i] = .contains
                    letterCount[incoming.letters[i]] = count - 1
                }
            }
        }

        return comparison
    }
    
    /// Function to retrieve a comparison between two words
    func comparison(_ targetWord: DatabaseWordModel) -> [LetterComparison] {
        let targetCast = GameWordModel(targetWord)
        return targetCast.comparison(self)
    }
    
    /// Creates a map where each letter only shows up once, and its highest rank is associated with its key (primarily for keyboard)
    func comparisonRankingMap(_ comparisons: [LetterComparison]) -> [ValidCharacters : LetterComparison] {
        var comparisonMap = [ValidCharacters : LetterComparison]()
        for (letter, comparison) in zip(self.letters, comparisons) {
            if let currentComparisonValue = comparisonMap[letter] {
                comparisonMap[letter] = max(currentComparisonValue, comparison)
            } else {
                comparisonMap[letter] = comparison
            }
        }
        return comparisonMap
    }
}
