import SwiftUI

/// View Model to support a single keyboard letter button
class KeyboardLetterViewModel : ObservableObject, KeyboardKeyProtocol {
    
    @Published var backgroundColor : LetterComparison
    @Published var borderColor : Color
    
    var action: () -> Void
    var borderThickness : CGFloat
    var cornerRadius : CGFloat
    var fontColor : Color
    var height : CGFloat
    var letter : ValidCharacters
    var width : CGFloat
    
    /// Base Initializer
    init(action: @escaping () -> Void = {},
         letter: ValidCharacters,
         backgroundColor: LetterComparison = .notSet,
         borderColor: Color = .Buttons.buttonBorder,
         borderThickness: CGFloat = 2.0,
         cornerRadius: CGFloat = 8.0,
         fontColor: Color = .Buttons.buttonFont,
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
    
    /// Resets the button back to default values
    func reset() {
        self.backgroundColor = .notSet
        self.borderColor = .Buttons.buttonBorder
        self.fontColor = .Buttons.buttonFont
    }
}

protocol KeyboardKeyProtocol {
    var action: () -> Void { get set }
    var borderColor : Color { get set }
    var borderThickness : CGFloat { get set }
    var cornerRadius : CGFloat { get set }
    var fontColor : Color { get set }
    var height : CGFloat { get set }
    var width : CGFloat { get set }
    
    func PerformAction()
}
