import SwiftUI

/// View model for entire row on game board
class GameBoardWordViewModel : GameWordBaseViewModel {
    
    @Published private(set) var shakeWord: Bool = false
    
    var hints: [ValidCharacters?] = []
    var position: Int = 0
    
    /// Base Initializer
    init (boardWidth: Int, boardSpacing: CGFloat) {
        super.init(boardWidth: boardWidth, boardSpacing: boardSpacing)
        
        // Populate letters
        for _ in 0..<boardWidth {
            self.letters.append(GameBoardLetterViewModel())
            self.hints.append(nil)
        }
    }
    
    // MARK: Helper functions
    /// Adds a letter to the current word
    func addLetter(_ letter : ValidCharacters) {
        guard position < boardWidth else { return }
        self.letters[position].setLetter(letter)
        self.position += 1
    }
    
    /// Returns the full word representation of the letters
    func getWord() -> GameWordModel? {
        guard position == boardWidth else { return nil }
        var word = ""
        self.letters.forEach { if let letter = $0.letter { word.append(letter.stringValue) } }
        return GameWordModel(word)
    }
    
    /// Removes a letter from the current word
    func removeLetter() {
        guard position > 0 else { return }
        self.letters[position - 1].setHint(self.hints[position - 1])
        self.position -= 1
    }
    
    // MARK: Visual functions
    /// Loads in all hints from a collection of hints
    func loadHints(_ hints : [ValidCharacters?]) {
        self.hints = hints
        for (letterVM, hint) in zip(self.letters, hints) {
            letterVM.setHint(hint)
        }
    }
    
    /// Performs the shake animation
    func shake() {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.shakeWord.toggle()
        }
    }
    
    // MARK: Data functions
    /// Retrieve the save state
    func getSaveState() -> GameBoardWordSaveStateModel {
        let saveState = GameBoardWordSaveStateModel(letters: self.letters.map { $0.getSaveState() })
        return saveState
    }
    
    /// Load in save states
    func loadSaveState(_ saveState : GameBoardWordSaveStateModel) {
        guard saveState.letters.count == letters.count else { return }
        for i in 0..<boardWidth {
            letters[i].loadSaveState(saveState.letters[i])
        }
    }
    
    /// Resets the word
    func reset() {
        self.position = 0
        for letter in letters { letter.reset() }
    }
    
    /// Resets the word using an animation
    func resetWithAnimation(animationLength: Double, speed: Double = 1.5) {
        self.position = 0
        for i in stride(from: boardWidth - 1, through: 0, by: -1) {
            DispatchQueue.main.asyncAfter(deadline: .now() + ((animationLength / speed) * Double(i))) {
                withAnimation(.linear(duration: animationLength)) {
                    self.letters[i].reset()
                }
            }
        }
    }
}
