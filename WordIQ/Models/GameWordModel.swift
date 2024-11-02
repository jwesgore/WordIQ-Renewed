/// Struct to hold functionality for basic game words
struct GameWordModel : Comparable {
    var word : String
    var letters : [ValidCharacters]
    
    init(_ word: String) {
        self.word = word
        self.letters = word.compactMap { ValidCharacters.from($0) }
    }
    
    /// Function to compare if two game words are equal
    static func < (lhs: GameWordModel, rhs: GameWordModel) -> Bool {
        return lhs.word == rhs.word
    }
}
