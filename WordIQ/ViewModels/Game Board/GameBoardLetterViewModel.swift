import SwiftUI

/// View model for single letter on game board
class GameBoardLetterViewModel : ObservableObject {
    
    let id: UUID = UUID()
    
    @Published var backgroundColor : LetterComparison
    @Published var borderColor : Color
    @Published var letter : ValidCharacters?
    @Published var opacity : CGFloat
    @Published var showBackgroundColor = false
    
    var borderThickness : CGFloat
    var cornerRadius : CGFloat

    /// Base initializer
    init(letter: ValidCharacters? = nil,
         opacity: CGFloat = 1.0,
         backgroundColor: LetterComparison = .notSet,
         borderThickness: CGFloat = 2.0,
         cornerRadius : CGFloat = 8.0) {
        self.letter = letter
        self.opacity = opacity
        self.backgroundColor = backgroundColor
        self.borderColor = Color.GameBoard.letterBorderInactive
        self.borderThickness = borderThickness
        self.cornerRadius = cornerRadius
    }
    
    // MARK: Visual functions
    /// Sets the letter for the view model
    func setLetter(_ letter : ValidCharacters) {
        self.letter = letter
        self.borderColor = Color.GameBoard.letterBorderActive
        self.opacity = 1.0
    }
    
    /// Sets the hint for the view model
    func setHint(_ letter : ValidCharacters?) {
        self.letter = letter
        self.borderColor = Color.GameBoard.letterBorderInactive
        self.opacity = 0.5
    }
    
    // MARK: Data functions
    /// Get Save State model
    func getSaveState() -> GameBoardLetterSaveStateModel {
        guard let letter = self.letter else {
            fatalError("Attempting to save a nil letter")
        }
        return GameBoardLetterSaveStateModel(letter: letter, letterComparison: backgroundColor)
    }
    
    /// Save State loader
    func loadSaveState (_ saveState : GameBoardLetterSaveStateModel) {
        self.setLetter(saveState.letter)
        self.backgroundColor = saveState.letterComparison
        self.showBackgroundColor = true
    }
    
    /// Resets the view to the default parameters
    func reset() {
        self.letter = nil
        self.opacity = 1.0
        self.backgroundColor = .notSet
        self.showBackgroundColor = false
        self.borderColor = Color.GameBoard.letterBorderInactive
    }
}
