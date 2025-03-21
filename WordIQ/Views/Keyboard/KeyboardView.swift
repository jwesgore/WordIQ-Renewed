import SwiftUI

struct KeyboardView : View {
    
    @ObservedObject var viewModel : KeyboardViewModel
    
    let spacing : CGFloat = 5
    
    var body: some View {
        VStack (spacing: spacing) {
            HStack (spacing: spacing) {
                KeyboardLetterView(viewModel.keyboardLetterButtons[.Q]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.W]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.E]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.R]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.T]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.Y]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.U]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.I]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.O]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.P]!)
            }
            HStack (spacing: spacing) {
                KeyboardLetterView(viewModel.keyboardLetterButtons[.A]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.S]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.D]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.F]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.G]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.H]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.J]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.K]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.L]!)
            }
            HStack (spacing: spacing) {
                KeyboardFunctionView(viewModel.keyboardEnterButton)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.Z]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.X]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.C]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.V]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.B]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.N]!)
                KeyboardLetterView(viewModel.keyboardLetterButtons[.M]!)
                KeyboardFunctionView(viewModel.keyboardDeleteButton)
            }
        }
    }
}

extension KeyboardView {
    init (_ viewModel: KeyboardViewModel) {
        self.viewModel = viewModel
    }
}
