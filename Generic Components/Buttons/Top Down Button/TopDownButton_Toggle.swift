import SwiftUI

struct TopDownButton_Toggle : View {
    
    @StateObject var viewModel: TopDownButton_Toggle_ViewModel
    @Binding var toggle: Bool
    
    var button1Label: String
    var button2Label: String
    
    var body : some View {
        
        HStack (spacing: 8.0) {
            TopDownButton_Radio(viewModel.viewModel1) {
                Text(button1Label)
                    .robotoSlabFont(.headline, .regular)
            }
            
            TopDownButton_Radio(viewModel.viewModel2) {
                Text(button2Label)
                    .robotoSlabFont(.headline, .regular)
            }
        }
        .padding(4.0)
        .onChange(of: viewModel.firstButtonSelected) { oldValue, newValue in
            toggle = newValue
        }
    }
}


extension TopDownButton_Toggle {
    init(firstButtonSelected: Binding<Bool>, button1Label: String = "On", button2Label: String = "Off") {
        self._viewModel = StateObject(wrappedValue: TopDownButton_Toggle_ViewModel(firstButtonSelected: firstButtonSelected.wrappedValue))
        self.button1Label = button1Label
        self.button2Label = button2Label
        self._toggle = firstButtonSelected
    }
}


#Preview {
    TopDownButton_Toggle(firstButtonSelected: .constant(true))
}
