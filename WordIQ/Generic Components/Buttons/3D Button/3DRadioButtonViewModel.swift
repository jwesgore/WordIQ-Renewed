import SwiftUI

/// Extension of ThreeDButtonViewModel to enable radio functionality
class ThreeDRadioButtonViewModel : ThreeDButtonViewModel {
    
    @Published var isPressed : Bool
    
    var activeBackgroundColor : Color {
        return self.isPressed ? self.selectedBackgroundColor : self.backgroundColor
    }
    var groupManager : RadioButtonViewModelObserver
    var id : UUID
    var selectedBackgroundColor : Color

    init(height: CGFloat,
         width: CGFloat,
         actionDelay: Double,
         groupManager : RadioButtonViewModelObserver,
         isPressed: Bool,
         selectedBackgroundColor: Color) {
        
        self.id = UUID()
        
        self.isPressed = isPressed
        self.groupManager = groupManager
        self.selectedBackgroundColor = selectedBackgroundColor

        super.init(height: height,
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
    
    convenience init(height: CGFloat, width: CGFloat, groupManager : RadioButtonViewModelObserver, isPressed: Bool = false) {
        self.init(height: height,
                  width: width,
                  actionDelay: 0.0,
                  groupManager: groupManager,
                  isPressed: isPressed,
                  selectedBackgroundColor: Color.Buttons.buttonSelected)
    }
    
    /// Overrides the PerformAction to communicate to the radio group before performing action
    override func performAction() {
        self.groupManager.communicate(self.id)
        super.performAction()
    }
}

protocol RadioButtonViewModelObserver {
    func communicate(_ id: UUID)
}
