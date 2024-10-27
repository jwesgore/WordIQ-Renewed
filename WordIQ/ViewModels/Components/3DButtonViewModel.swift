import SwiftUI

/// ViewModel for the ThreeDButtonView
class ThreeDButtonViewModel : ObservableObject {
    
    // MARK: Visual Properties
    var height: CGFloat
    var width: CGFloat
    var depth: CGFloat
    var zindex: CGFloat
    var borderThickness: CGFloat
    var cornerRadius: CGFloat
    var backgroundColor:Color
    var borderColor: Color
    var shadowColor: Color
    
    // MARK: Action Properties
    var action: () -> Void
    var speed: Double
    var delay: Double
    
    init(height: CGFloat,
         width: CGFloat,
         depth: CGFloat = -4.0,
         zindex: CGFloat = 0.0,
         borderThickness: CGFloat = 1.0,
         cornerRadius: CGFloat = 25.0,
         backgroundColor: Color = Color.white,
         borderColor: Color = Color.black,
         shadowColor: Color = Color.black,
         
         action: @escaping () -> Void = {},
         speed: Double = 0.1,
         delay: Double = 0.5) {
        self.height = height
        self.width = width
        self.depth = depth
        self.zindex = zindex
        self.borderThickness = borderThickness
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.shadowColor = shadowColor
        
        self.action = action
        self.speed = speed
        self.delay = delay
    }
    
    /// Perform button action
    func PerformAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.action()
        }
    }
}
