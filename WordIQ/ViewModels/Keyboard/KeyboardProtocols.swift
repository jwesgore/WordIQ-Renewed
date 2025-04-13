import SwiftUI

/// Protocol to define common properties and actions for keyboard keys.
///
/// This protocol provides a blueprint for managing the appearance and behavior of
/// keyboard keys, whether they are letter keys or function keys.
protocol KeyboardKeyProtocol: ObservableObject {
    
    /// The action to perform when the key is pressed.
    var action: () -> Void { get set }
    
    /// The border color of the key.
    var borderColor: Color { get set }
    
    /// The thickness of the key's border.
    var borderThickness: CGFloat { get set }
    
    /// The corner radius of the key for rounded edges.
    var cornerRadius: CGFloat { get set }
    
    /// The font color of the key's text.
    var fontColor: Color { get set }
    
    /// The height of the key.
    var height: CGFloat { get set }
    
    /// The width of the key.
    var width: CGFloat { get set }
    
    /// Executes the action associated with the key.
    func PerformAction()
}
