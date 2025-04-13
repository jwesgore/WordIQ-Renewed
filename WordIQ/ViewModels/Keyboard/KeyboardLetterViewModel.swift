import SwiftUI

/// ViewModel to support a single keyboard letter button.
///
/// This ViewModel manages the state and behavior of a single letter key on the keyboard,
/// including its appearance, dimensions, and the action it performs when pressed.
class KeyboardLetterViewModel: KeyboardKeyProtocol {
    
    // MARK: - Published Properties
    
    /// The background color of the letter key, which reflects its state in the game.
    @Published var backgroundColor: LetterComparison
    
    /// The border color of the letter key.
    @Published var borderColor: Color
    
    // MARK: - Properties
    
    /// Closure that defines the action performed when the key is pressed.
    var action: () -> Void
    
    /// The thickness of the key's border.
    var borderThickness: CGFloat
    
    /// The corner radius of the key for rounded edges.
    var cornerRadius: CGFloat
    
    /// The font color of the key's text.
    var fontColor: Color
    
    /// The height of the key.
    var height: CGFloat
    
    /// The letter associated with the key.
    var letter: ValidCharacters
    
    /// The width of the key.
    var width: CGFloat
    
    // MARK: - Initializer
    
    /// Initializes a `KeyboardLetterViewModel` instance with customizable properties.
    ///
    /// - Parameters:
    ///   - action: The closure to execute when the key is pressed. Defaults to an empty action.
    ///   - letter: The letter character associated with the key.
    ///   - backgroundColor: The background color of the key. Defaults to `.notSet`.
    ///   - borderColor: The border color of the key. Defaults to `.Buttons.buttonBorder`.
    ///   - borderThickness: The thickness of the key's border. Defaults to `2.0`.
    ///   - cornerRadius: The corner radius for the key. Defaults to `8.0`.
    ///   - fontColor: The font color of the key's text. Defaults to `.Buttons.buttonFont`.
    ///   - height: The height of the key. Defaults to `100`.
    ///   - width: The width of the key. Defaults to `100`.
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
    
    // MARK: - Methods
    
    /// Executes the action associated with the key.
    ///
    /// This method triggers the stored action for the key, simulating a key press.
    func PerformAction() {
        self.action()
    }
    
    /// Resets the button back to its default state.
    ///
    /// This method clears any custom colors or states applied to the button, reverting it to its initial appearance.
    func reset() {
        self.backgroundColor = .notSet
        self.borderColor = .Buttons.buttonBorder
        self.fontColor = .Buttons.buttonFont
    }
}
