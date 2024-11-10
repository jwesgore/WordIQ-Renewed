import SwiftUI

class GameBoardLetterViewModel : ObservableObject {
    
    @Published var letter : ValidCharacters?
    @Published var opacity : CGFloat
    @Published var backgroundColor : LetterComparison
    @Published var borderColor : Color
    var borderThickness : CGFloat
    var cornerRadius : CGFloat
    var height : CGFloat
    var width : CGFloat
    
    init(letter: ValidCharacters? = nil,
         opacity: CGFloat = 1.0,
         backgroundColor: LetterComparison = .notSet,
         borderThickness: CGFloat = 2.0,
         cornerRadius : CGFloat = 8.0,
         height: CGFloat = 100,
         width: CGFloat = 100) {
        self.letter = letter
        self.opacity = opacity
        self.backgroundColor = backgroundColor
        self.borderColor = Color.GameBoard.letterBorderInactive
        self.borderThickness = borderThickness
        self.cornerRadius = cornerRadius
        self.height = height
        self.width = width
    }
    
    /// Sets the letter for the view model
    func setLetter(_ letter : ValidCharacters) {
        self.letter = letter
        self.borderColor = Color.GameBoard.letterBorderActive
        self.opacity = 1.0
    }
    
    /// Sets the hint for the view model
    func setHint(_ letter : ValidCharacters?) {
        self.letter = letter
        self.borderColor = Color.GameBoard.letterBorderInactive
        self.opacity = 0.5
    }
    
    /// Resets the view to the default parameters
    func reset() {
        self.letter = nil
        self.opacity = 1.0
        self.backgroundColor = .notSet
    }
}
