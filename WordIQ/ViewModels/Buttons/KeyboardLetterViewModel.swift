import SwiftUI

/// View Model to support a single keyboard letter button
class KeyboardLetterViewModel : ObservableObject, KeyboardKeyProtocol {
    
    var action: () -> Void
    
    var letter : ValidCharacters
    var backgroundColor : Color
    var borderColor : Color
    var borderThickness : CGFloat
    var cornerRadius : CGFloat
    var fontColor : Color
    var height : CGFloat
    var width : CGFloat
    
    init(action: @escaping () -> Void = {},
         letter: ValidCharacters,
         backgroundColor: Color = .white,
         borderColor: Color = .black,
         borderThickness: CGFloat = 2.0,
         cornerRadius: CGFloat = 8.0,
         fontColor: Color = .black,
         height: CGFloat = 100,
         width: CGFloat = 100) {
        self.action = action
        self.letter = letter
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderThickness = borderThickness
        self.cornerRadius = cornerRadius
        self.fontColor = fontColor
        self.height = height
        self.width = width
    }
    
    /// Calls the store action in the button
    func PerformAction() {
        self.action()
    }
}

protocol KeyboardKeyProtocol {
    var action: () -> Void { get set }
    var backgroundColor : Color { get set }
    var borderColor : Color { get set }
    var borderThickness : CGFloat { get set }
    var cornerRadius : CGFloat { get set }
    var fontColor : Color { get set }
    var height : CGFloat { get set }
    var width : CGFloat { get set }
    
    func PerformAction()
}