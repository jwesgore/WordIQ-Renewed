import SwiftUI

struct KeyboardView : View {
    
    var keyboardLetters : [ValidCharacters : KeyboardLetterViewModel]
    var enterKey : KeyboardFunctionViewModel
    var deleteKey : KeyboardFunctionViewModel
    
    let spacing : CGFloat = 5
    
    var body: some View {
        VStack (spacing: spacing) {
            HStack (spacing: spacing) {
                KeyboardLetterView(keyboardLetters[.Q]!)
                KeyboardLetterView(keyboardLetters[.W]!)
                KeyboardLetterView(keyboardLetters[.E]!)
                KeyboardLetterView(keyboardLetters[.R]!)
                KeyboardLetterView(keyboardLetters[.T]!)
                KeyboardLetterView(keyboardLetters[.Y]!)
                KeyboardLetterView(keyboardLetters[.U]!)
                KeyboardLetterView(keyboardLetters[.I]!)
                KeyboardLetterView(keyboardLetters[.O]!)
                KeyboardLetterView(keyboardLetters[.P]!)
            }
            HStack (spacing: spacing) {
                KeyboardLetterView(keyboardLetters[.A]!)
                KeyboardLetterView(keyboardLetters[.S]!)
                KeyboardLetterView(keyboardLetters[.D]!)
                KeyboardLetterView(keyboardLetters[.F]!)
                KeyboardLetterView(keyboardLetters[.G]!)
                KeyboardLetterView(keyboardLetters[.H]!)
                KeyboardLetterView(keyboardLetters[.J]!)
                KeyboardLetterView(keyboardLetters[.K]!)
                KeyboardLetterView(keyboardLetters[.L]!)
            }
            HStack (spacing: spacing) {
                KeyboardFunctionView(enterKey)
                KeyboardLetterView(keyboardLetters[.Z]!)
                KeyboardLetterView(keyboardLetters[.X]!)
                KeyboardLetterView(keyboardLetters[.C]!)
                KeyboardLetterView(keyboardLetters[.V]!)
                KeyboardLetterView(keyboardLetters[.B]!)
                KeyboardLetterView(keyboardLetters[.N]!)
                KeyboardLetterView(keyboardLetters[.M]!)
                KeyboardFunctionView(deleteKey)
            }
        }
    }
}
