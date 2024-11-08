import SwiftUI

class GameBoardLetterViewModel : ObservableObject {
    
    @Published var letter : ValidCharacters?
    
    @Published var opacity : CGFloat
    @Published var backgroundColor : Color
    @Published var borderColor : Color
    var borderThickness : CGFloat
    var cornerRadius : CGFloat
    var height : CGFloat
    var width : CGFloat
    
    init(letter: ValidCharacters? = nil,
         opacity: CGFloat = 1.0,
         backgroundColor: Color = .white,
         borderColor: Color = .black,
         borderThickness: CGFloat = 2.0,
         cornerRadius : CGFloat = 8.0,
         height: CGFloat = 100,
         width: CGFloat = 100) {
        self.letter = letter
        self.opacity = opacity
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderThickness = borderThickness
        self.cornerRadius = cornerRadius
        self.height = height
        self.width = width
    }
    
    /// Resets the view to the default parameters
    func reset() {
        self.letter = nil
        self.opacity = 1.0
        self.backgroundColor = .white
        self.borderColor = .black
    }
}
