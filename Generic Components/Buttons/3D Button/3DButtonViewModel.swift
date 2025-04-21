import SwiftUI

/// ViewModel for the ThreeDButtonView
class ThreeDButtonViewModel : ObservableObject {
    
    // MARK: Visual Properties
    var height: CGFloat
    var width: CGFloat
    var depth: CGFloat
    var zIndex: CGFloat
    var borderThickness: CGFloat
    var cornerRadius: CGFloat
    var backgroundColor:Color
    var borderColor: Color
    var shadowColor: Color
    
    // MARK: Action Properties
    var action: () -> Void
    var animationDuration: Double
    var actionDelay: Double
    
    init(height: CGFloat,
         width: CGFloat,
         actionDelay: Double,
         animationDuration: Double,
         backgroundColor: Color,
         borderColor: Color,
         borderThickness: CGFloat,
         cornerRadius: CGFloat,
         depth: CGFloat,
         shadowColor: Color,
         zIndex: CGFloat,
         action: @escaping () -> Void = {}) {
        self.height = height
        self.width = width
        self.depth = depth
        self.zIndex = zIndex
        self.borderThickness = borderThickness
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.shadowColor = shadowColor
        
        self.action = action
        self.animationDuration = animationDuration
        self.actionDelay = actionDelay
    }
    
    convenience init (height: CGFloat, width: CGFloat) {
        self.init(height: height,
                  width: width,
                  actionDelay: 0.5,
                  animationDuration: 0.1,
                  backgroundColor: .Buttons.buttonBackground,
                  borderColor: .Buttons.buttonBorder,
                  borderThickness: 1.0,
                  cornerRadius: 25.0,
                  depth: -4.0,
                  shadowColor: .Buttons.buttonShadow,
                  zIndex: 0.0
              )
    }
    
    /// Perform button action
    func performAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + actionDelay) {
            self.action()
        }
    }
}
