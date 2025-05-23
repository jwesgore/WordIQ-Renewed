import SwiftUI

/// View Model to support Top Down Button View
class TopDownButtonViewModel : ObservableObject {
    
    var height : CGFloat
    var width : CGFloat
    
    var actionDelay : Double
    var animationDuration : Double
    var backgroundColor : Color
    var borderColor : Color
    var borderThickness : CGFloat
    var cornerRadius : CGFloat
    var hasShadow: Bool
    var pressedOpacity : Double
    var pressedScale : Double
    var action: () -> Void
    
    init (height : CGFloat,
          width : CGFloat,
          actionDelay : Double,
          animationDuration : Double,
          backgroundColor : Color,
          borderColor : Color,
          borderThickness : CGFloat,
          cornerRadius : CGFloat,
          hasShadow: Bool,
          pressedOpacity : Double,
          pressedScale : Double,
          action: @escaping () -> Void) {
        self.height = height
        self.width = width
        self.actionDelay = actionDelay
        self.animationDuration = animationDuration
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderThickness = borderThickness
        self.cornerRadius = cornerRadius
        self.hasShadow = hasShadow
        self.pressedOpacity = pressedOpacity
        self.pressedScale = pressedScale
        self.action = action
    }
    
    convenience init(height : CGFloat, width : CGFloat, hasShadow: Bool = true, action: @escaping () -> Void) {
        self.init(height: height,
                  width: width,
                  actionDelay: 0.5,
                  animationDuration: 0.1,
                  backgroundColor: .Buttons.buttonBackground,
                  borderColor: .Buttons.buttonBorder,
                  borderThickness: 1.0,
                  cornerRadius: 20.0,
                  hasShadow: hasShadow,
                  pressedOpacity: 0.5,
                  pressedScale: 0.9,
                  action: action)
    }
    
    convenience init(height : CGFloat, width : CGFloat, hasShadow: Bool = true) {
        self.init(height: height, width: width, hasShadow: hasShadow, action: {})
    }
    
    /// Perform button action
    func performAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + actionDelay) {
            self.action()
        }
    }
    
}
