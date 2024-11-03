/// Struct to hold functionality for basic game words
struct GameWordModel : Equatable {
    var word : String
    var letters : [ValidCharacters]
    
    init(_ word: String) {
        self.word = word
        self.letters = word.compactMap { ValidCharacters.from($0) }
    }
    
    /// Function to compare if two game words are equal
    static func == (lhs: GameWordModel, rhs: GameWordModel) -> Bool {
        return lhs.letters == rhs.letters
    }
    
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
                if let count = letterCount[self.letters[i]], count > 0 {
                    comparison[i] = .contains
                    letterCount[self.letters[i]] = count - 1
                }
            }
        }
        
        return comparison
    }
}
