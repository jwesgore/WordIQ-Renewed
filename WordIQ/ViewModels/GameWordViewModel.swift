import SwiftUI

class GameBoardWordViewModel : ObservableObject {

    @Published var letters : [GameBoardLetterViewModel]
    @Published private(set) var Shake : Bool
    var position : Int
    
    init() {
        self.position = 0
        self.Shake = false
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
    
    // MARK: Visual functions
    /// Sets background colors on Active Word with the provided letter comparison
    func setBackgrounds(_ comparisons : [LetterComparison]) {
        for i in 0..<5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + (0.125 * Double(i)), execute: {
                withAnimation(.easeIn(duration: 0.2)) {
                    self.letters[i].backgroundColor = comparisons[i].color
                }
            })
        }
    }
    
    /// Performs the shake animation
    func ShakeAnimation() {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.Shake.toggle()
        }
    }
    
    /// Resets the word
    func reset() {
        self.position = 0
        for letter in letters { letter.reset() }
    }
    
    /// Resets the word using an animation
    func resetWithAnimation(animationLength: Double, speed: Double = 1.0) {
        self.position = 0
        for i in stride(from: 4, through: 0, by: -1) {
            DispatchQueue.main.asyncAfter(deadline: .now() + ((animationLength / speed) * Double(i))) {
                withAnimation(.linear(duration: animationLength)) {
                    self.letters[i].reset()
                }
            }
        }
    }
}
