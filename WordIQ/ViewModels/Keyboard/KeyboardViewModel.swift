import SwiftUI

class KeyboardViewModel : ObservableObject {
    
    let funcKeyWidthMultiplier = 0.13
    let keyHeightMultiplier = 0.06
    let letterKeyWidthMultiplier = 0.085
    
    var isKeyboardUnlocked: Bool = false
    
    var keyboardDeleteButton : KeyboardFunctionViewModel
    var keyboardEnterButton : KeyboardFunctionViewModel
    @Published var keyboardLetterButtons = [ValidCharacters : KeyboardLetterViewModel]()
    
    // MARK: Initializers
    /// Base initializer
    init(keyboardAddLetter: @escaping (ValidCharacters) -> Void,
         keyboardEnter: @escaping () -> Void,
         keyboardDelete: @escaping () -> Void) {
        
        self.keyboardEnterButton = KeyboardFunctionViewModel(action: keyboardEnter,
                                                             keyboardFunction: .enter,
                                                             height: UIScreen.main.bounds.height * keyHeightMultiplier,
                                                             width: UIScreen.main.bounds.width * funcKeyWidthMultiplier)
        
        self.keyboardDeleteButton = KeyboardFunctionViewModel(action: keyboardDelete,
                                                              keyboardFunction: .backspace,
                                                              height: UIScreen.main.bounds.height * keyHeightMultiplier,
                                                              width: UIScreen.main.bounds.width * funcKeyWidthMultiplier)
        
        for letter in ValidCharacters.allCases {
            self.keyboardLetterButtons[letter] = KeyboardLetterViewModel(
                action: { [weak self] in
                    guard self != nil else { return }
                    keyboardAddLetter(letter)
                },
                letter: letter,
                backgroundColor: .notSet,
                height: UIScreen.main.bounds.height * keyHeightMultiplier,
                width: UIScreen.main.bounds.width * letterKeyWidthMultiplier)
        }
    }
    
    /// Convenience initializer for save state
    func loadSaveState(gameSaveState: GameSaveStateModel) {
        for letter in ValidCharacters.allCases {
            self.keyboardLetterButtons[letter]?.backgroundColor = gameSaveState.keyboardLetters[letter] ?? .notSet
        }
    }
    
    // MARK: Keyboard functions
    /// Sets the background values on the keyboard keys
    func keyboardSetBackgrounds(_ comparisonMap: [ValidCharacters : LetterComparison]) {
        for comparison in comparisonMap {
            if let keyboardButton = keyboardLetterButtons[comparison.key] {
                keyboardButton.backgroundColor = max(keyboardButton.backgroundColor, comparison.value)
            }
        }
    }
    
    /// Function to reset the keyboard to its default state
    func resetKeyboard() {
        for keyboardButton in keyboardLetterButtons {
            keyboardButton.value.reset()
        }
    }
}
