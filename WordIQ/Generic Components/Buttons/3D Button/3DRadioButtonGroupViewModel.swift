import SwiftUI

class ThreeDRadioButtonGroupViewModel : ThreeDRadioButtonViewModelObserver {
    
    private var Buttons : [UUID : ThreeDRadioButtonViewModel]
    private var ActiveButton : UUID?
    
    init() {
        self.Buttons = [UUID : ThreeDRadioButtonViewModel]()
    }
    
    /// Adds a button onto the group
    func add(_ buttons : ThreeDRadioButtonViewModel...) {
        for button in buttons {
            self.Buttons[button.id] = button
            if button.isPressed { self.communicate(button.id) }
        }
    }
    
    /// Returns the view model of the active button
    func getActive() -> ThreeDRadioButtonViewModel? {
        guard let activeButton = ActiveButton else { return nil }
        return Buttons[activeButton]
    }
    
    /// Sets the active button and deselects the previous button
    func communicate(_ id: UUID) {
        if let currentButtonID = ActiveButton, let currentButton = Buttons[currentButtonID] {
            currentButton.isPressed = false
        }
        self.ActiveButton = id
        if let currentButtonID = ActiveButton, let currentButton = Buttons[currentButtonID] {
            currentButton.isPressed = true
        }
    }
}
