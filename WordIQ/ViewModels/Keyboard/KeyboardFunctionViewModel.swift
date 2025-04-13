import SwiftUI

/// ViewModel to support keyboard function keys.
///
/// This ViewModel manages the state and functionality of special keyboard keys
/// (e.g., Enter and Backspace). It provides properties for customizing the appearance
/// and behavior of these keys and supports actions triggered by user interactions.
class KeyboardFunctionViewModel: KeyboardKeyProtocol {
    
    // MARK: - Properties
    
    /// Closure that defines the action performed when the key is pressed.
    var action: () -> Void
    
    /// Enum representing the type of keyboard function (e.g., Enter, Backspace).
    var keyboardFunction: KeyboardFunctions
    
    /// The background color of the key.
    var backgroundColor: Color
    
    /// The border color of the key.
    var borderColor: Color
    
    /// The thickness of the key's border.
    var borderThickness: CGFloat
    
    /// The corner radius of the key for rounded edges.
    var cornerRadius: CGFloat
    
    /// The font color of the key's text.
    var fontColor: Color
    
    /// The height of the key.
    var height: CGFloat
    
    /// The width of the key.
    var width: CGFloat
    
    // MARK: - Initializers
    
    /// Initializes a `KeyboardFunctionViewModel` instance with customizable properties.
    ///
    /// - Parameters:
    ///   - action: The closure to execute when the key is pressed. Defaults to an empty action.
    ///   - keyboardFunction: The type of keyboard function the key represents.
    ///   - backgroundColor: The background color of the key. Defaults to `.Buttons.buttonBackground`.
    ///   - borderColor: The color of the key's border. Defaults to `.Buttons.buttonBorder`.
    ///   - borderThickness: The thickness of the key's border. Defaults to `2.0`.
    ///   - cornerRadius: The corner radius for the key. Defaults to `8.0`.
    ///   - fontColor: The color of the key's font. Defaults to `.Buttons.buttonFont`.
    ///   - height: The height of the key. Defaults to `100`.
    ///   - width: The width of the key. Defaults to `100`.
    init(action: @escaping () -> Void = {},
         keyboardFunction: KeyboardFunctions,
         backgroundColor: Color = .Buttons.buttonBackground,
         borderColor: Color = .Buttons.buttonBorder,
         borderThickness: CGFloat = 2.0,
         cornerRadius: CGFloat = 8.0,
         fontColor: Color = .Buttons.buttonFont,
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
    
    // MARK: - Methods
    
    /// Executes the action associated with the key.
    ///
    /// This method triggers the stored action for the key, simulating a key press.
    func PerformAction() {
        self.action()
    }
}
