import SwiftUI

/// Extension of TopDownButtonViewModel to enable radio functionality
class TopDownRadioButtonViewModel : TopDownButtonViewModel {
    
    @Published var isPressed: Bool
    
    var activeBackgroundColor : Color {
        // Reversing this because im it's currently 10:30 and it looks better reverse with the new button design
        return self.isPressed ? self.backgroundColor : self.selectedBackgroundColor
    }
    var groupManager : RadioButtonViewModelObserver
    var id : UUID
    var selectedBackgroundColor : Color
    
    init(height: CGFloat,
         width: CGFloat,
         actionDelay: Double,
         groupManager : RadioButtonViewModelObserver,
         hasShadow: Bool,
         isPressed: Bool,
         selectedBackgroundColor: Color,
         action: @escaping () -> Void) {
        
        self.id = UUID()
        
        self.isPressed = isPressed
        self.groupManager = groupManager
        self.selectedBackgroundColor = selectedBackgroundColor
        
        super.init(height: height,
                   width: width,
                   actionDelay: actionDelay,
                   animationDuration: 0.1,
                   backgroundColor: .Buttons.buttonBackground,
                   borderColor: .Buttons.buttonBorder,
                   borderThickness: 1.0,
                   cornerRadius: 16.0,
                   hasShadow: hasShadow,
                   pressedOpacity: 0.5,
                   pressedScale: 0.9,
                   action: action)
    }
    
    convenience init(height: CGFloat,
                     width: CGFloat,
                     groupManager : RadioButtonViewModelObserver,
                     hasShadow: Bool = true,
                     isPressed: Bool = false,
                     action: @escaping () -> Void = {}) {
        self.init(height: height,
                  width: width,
                  actionDelay: 0.0,
                  groupManager: groupManager,
                  hasShadow: hasShadow,
                  isPressed: isPressed,
                  selectedBackgroundColor: Color.Buttons.buttonSelected,
                  action: action)
    }
    
    /// Overrides the PerformAction to communicate to the radio group before performing action
    override func performAction() {
        self.groupManager.communicate(self.id)
        super.performAction()
    }
}
