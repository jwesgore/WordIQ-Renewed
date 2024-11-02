import SwiftUI

class GameBoardWordViewModel : ObservableObject {

    @Published var letters : [GameBoardLetterViewModel]
    var position : Int
    
    init() {
        self.position = 0
        self.letters = [GameBoardLetterViewModel]()
        
        // Populate letters
        for _ in 0..<5 {
            self.letters.append(GameBoardLetterViewModel())
        }
    }
    
    /// Adds a letter to the current word
    func addLetter(_ letter : ValidCharacters) {
        guard position < 5 else { return }
        self.letters[position].letter = letter
        self.position += 1
    }
    
    /// Removes a letter from the current word
    func removeLetter() {
        guard position > 0 else { return }
        self.letters[position - 1].letter = nil
        self.position -= 1
    }
    
    /// Returns the full word representation of the letters
    func getWord() -> GameWordModel? {
        guard position == 5 else { return nil }
        var word = ""
        self.letters.forEach { if let letter = $0.letter { word.append(letter.stringValue) } }
        return GameWordModel(word)
    }
}
