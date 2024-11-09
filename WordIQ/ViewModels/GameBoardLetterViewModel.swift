import SwiftUI

class GameBoardLetterViewModel : ObservableObject {
    
    @Published var letter : ValidCharacters?
    
    @Published var opacity : CGFloat
    @Published var backgroundColor : LetterComparison
    var borderColor : Color {
        return (letter != nil) ? Color.GameBoard.letterBorderActive : Color.GameBoard.letterBorderInactive
    }
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
        self.borderThickness = borderThickness
        self.cornerRadius = cornerRadius
        self.height = height
        self.width = width
    }
    
    /// Resets the view to the default parameters
    func reset() {
        self.letter = nil
        self.opacity = 1.0
        self.backgroundColor = .notSet
    }
}
