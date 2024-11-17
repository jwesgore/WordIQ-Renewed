import SwiftUI

/// Extension of ThreeDButtonViewModel to enable radio functionality
class ThreeDRadioButtonViewModel : ThreeDButtonViewModel {
    
    var id : UUID
    @Published var buttonIsPressed : Bool
    var groupManager : ThreeDRadioButtonViewModelObserver
    var selectedBackgroundColor : Color
    var activeBackgroundColor : Color {
        return self.buttonIsPressed ? self.selectedBackgroundColor : self.backgroundColor
    }
    
    init(buttonIsPressed: Bool = false,
         groupManager : ThreeDRadioButtonViewModelObserver,
         height: CGFloat,
         width: CGFloat,
         delay: Double = 0.0,
         selectedBackgroundColor: Color = Color.white) {
        self.id = UUID()
        self.buttonIsPressed = buttonIsPressed
        self.groupManager = groupManager
        self.selectedBackgroundColor = selectedBackgroundColor
        super.init(height: height, width: width, delay: delay)
    }
    
    /// Overrides the PerformAction to communicate to the radio group before performing action
    override func PerformAction() {
        self.groupManager.communicate(self.id)
        super.PerformAction()
    }
}

protocol ThreeDRadioButtonViewModelObserver {
    func communicate(_ id: UUID)
}
