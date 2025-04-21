import SwiftUI

class TopDownButton_Toggle_ViewModel: ObservableObject {
    
    var groupManager: TopDownRadioButtonGroupViewModel
    var viewModel1: TopDownRadioButtonViewModel
    var viewModel2: TopDownRadioButtonViewModel
    
    var buttonShadow: Bool
    
    let buttonDimensions = CGSize(width: 40, height: 40)
    
    @Published private(set) var firstButtonSelected: Bool
    
    init(firstButtonSelected: Bool = true, buttonShadow: Bool = false) {
        self.firstButtonSelected = firstButtonSelected
        self.buttonShadow = buttonShadow
        
        groupManager = TopDownRadioButtonGroupViewModel()
        
        viewModel1 = TopDownRadioButtonViewModel(height: buttonDimensions.height, width: buttonDimensions.width, groupManager: groupManager, hasShadow: buttonShadow, isPressed: firstButtonSelected)
        viewModel2 = TopDownRadioButtonViewModel(height: buttonDimensions.height, width: buttonDimensions.width, groupManager: groupManager, hasShadow: buttonShadow,isPressed: !firstButtonSelected)
        
        viewModel1.action = {
            self.firstButtonSelected = true
        }
        
        viewModel2.action = {
            self.firstButtonSelected = false
        }
        
        groupManager.add(viewModel1, viewModel2)
    }
}
