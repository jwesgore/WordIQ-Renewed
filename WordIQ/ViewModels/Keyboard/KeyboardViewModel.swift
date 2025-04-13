import SwiftUI

/// ViewModel to manage the keyboard interactions.
///
/// This ViewModel handles the state and functionality of a virtual keyboard, including
/// letter buttons, delete and enter buttons, and their respective actions. It also supports
/// operations like resetting the keyboard and updating background colors based on game state.
class KeyboardViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// Multiplier for the width of functional keys like Enter and Backspace.
    let funcKeyWidthMultiplier = 0.13
    
    /// Multiplier for the height of all keyboard keys.
    let keyHeightMultiplier = 0.06
    
    /// Multiplier for the width of letter keys.
    let letterKeyWidthMultiplier = 0.085
    
    /// Boolean to determine whether the keyboard is unlocked for input.
    var isKeyboardUnlocked: Bool = false
    
    /// ViewModel for the delete (backspace) button.
    var keyboardDeleteButton: KeyboardFunctionViewModel
    
    /// ViewModel for the enter button.
    var keyboardEnterButton: KeyboardFunctionViewModel
    
    /// Dictionary mapping each valid character to its corresponding keyboard button ViewModel.
    @Published var keyboardLetterButtons = OrderedDictionary<ValidCharacters, KeyboardLetterViewModel>()
    
    // MARK: - Initializers
    
    /// Base initializer to set up the keyboard buttons and actions.
    ///
    /// - Parameters:
    ///   - keyboardAddLetter: Closure to handle letter additions to the game board.
    ///   - keyboardEnter: Closure to process word submissions.
    ///   - keyboardDelete: Closure to delete letters from the game board.
    init(keyboardAddLetter: @escaping (ValidCharacters) -> Void,
         keyboardEnter: @escaping () -> Void,
         keyboardDelete: @escaping () -> Void) {
        
        // Initialize the Enter button
        self.keyboardEnterButton = KeyboardFunctionViewModel(
            action: keyboardEnter,
            keyboardFunction: .enter,
            height: UIScreen.main.bounds.height * keyHeightMultiplier,
            width: UIScreen.main.bounds.width * funcKeyWidthMultiplier
        )
        
        // Initialize the Delete button
        self.keyboardDeleteButton = KeyboardFunctionViewModel(
            action: keyboardDelete,
            keyboardFunction: .backspace,
            height: UIScreen.main.bounds.height * keyHeightMultiplier,
            width: UIScreen.main.bounds.width * funcKeyWidthMultiplier
        )
        
        // Initialize letter buttons for each valid character
        for letter in ValidCharacters.allCases {
            self.keyboardLetterButtons[letter] = KeyboardLetterViewModel(
                action: { [weak self] in
                    guard self != nil else { return }
                    keyboardAddLetter(letter)
                },
                letter: letter,
                backgroundColor: .notSet,
                height: UIScreen.main.bounds.height * keyHeightMultiplier,
                width: UIScreen.main.bounds.width * letterKeyWidthMultiplier
            )
        }
    }
    
    /// Loads a saved keyboard state.
    ///
    /// This method updates the background colors of the keyboard buttons based on
    /// the saved state from `GameSaveStateModel`.
    /// - Parameter gameSaveState: The model containing the saved keyboard state.
    func loadSaveState(gameSaveState: GameSaveStateModel) {
        for letter in ValidCharacters.allCases {
            self.keyboardLetterButtons[letter]?.backgroundColor = gameSaveState.keyboardLetters[letter] ?? .notSet
        }
    }
    
    // MARK: - Keyboard Functions
    
    /// Updates the background colors of keyboard buttons based on comparison results.
    ///
    /// This method sets the background colors for each button using the comparison map,
    /// ensuring that the highest priority color is preserved.
    /// - Parameter comparisonMap: A dictionary mapping valid characters to their comparison results.
    func keyboardSetBackgrounds(_ comparisonMap: [ValidCharacters: LetterComparison]) {
        for comparison in comparisonMap {
            if let keyboardButton = keyboardLetterButtons[comparison.key] {
                keyboardButton.backgroundColor = max(keyboardButton.backgroundColor, comparison.value)
            }
        }
    }
    
    /// Resets the keyboard to its default state.
    ///
    /// This method clears all background colors and restores the buttons to their initial state.
    func resetKeyboard() {
        for keyboardButton in keyboardLetterButtons.allValues {
            keyboardButton.reset()
        }
    }
}
