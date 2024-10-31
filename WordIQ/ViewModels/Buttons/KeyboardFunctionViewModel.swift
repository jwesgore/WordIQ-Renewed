import SwiftUI

/// ViewModel to support keyboard function keys
class KeyboardFunctionViewModel : ObservableObject, KeyboardKeyProtocol {
    
    var action: () -> Void
    var keyboardFunction: KeyboardFunctions
    
    var backgroundColor: Color
    var borderColor: Color
    var borderThickness: CGFloat
    var cornerRadius: CGFloat
    var fontColor: Color
    var height: CGFloat
    var width: CGFloat
    
    init(action: @escaping () -> Void = {},
         keyboardFunction: KeyboardFunctions,
         backgroundColor: Color = .white,
         borderColor: Color = .black,
         borderThickness: CGFloat = 2.0,
         cornerRadius: CGFloat = 8.0,
         fontColor: Color = .black,
         height: CGFloat = 100,
         width: CGFloat = 100) {
        self.action = action
        self.keyboardFunction = keyboardFunction
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
