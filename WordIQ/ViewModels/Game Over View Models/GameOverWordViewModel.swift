import SwiftUI

/// ViewModel for displaying a word on the game over screen.
///
/// This model is responsible for converting either an array of letter view models
/// or a database word model into a format suitable for display on the game over screen.
class GameOverWordViewModel: GameWordBaseViewModel {

    // MARK: - Initializers

    /// Initializes the view model using an array of letter view models.
    ///
    /// - Parameters:
    ///   - letters: An array of `GameBoardLetterViewModel` objects representing the letters.
    ///   - boardSpacing: The spacing between letters on the board. Defaults to 2.0.
    init(_ letters: [GameBoardLetterViewModel], boardSpacing: CGFloat = 2.0) {
        // Initialize the base with the number of letters and provided spacing.
        super.init(boardWidth: letters.count, boardSpacing: boardSpacing)
        // Set the letters array from the provided view models.
        super.letters = letters
    }
    
    /// Initializes the view model using a database word model.
    ///
    /// - Parameters:
    ///   - word: A `DatabaseWordModel` representing the target word.
    ///   - boardSpacing: The spacing between letters on the board. Defaults to 2.0.
    ///   - id: An optional unique identifier for this game word. Defaults to a new UUID.
    init(_ word: DatabaseWordModel, boardSpacing: CGFloat = 2.0, id: UUID = UUID()) {
        // Create a game word model from the database model's word string.
        let gameWord = GameWordModel(word.word)
        
        // Initialize the base using the number of letters in the game word.
        super.init(boardWidth: gameWord.letters.count, boardSpacing: boardSpacing, id: id)
        
        // Populate the letters array with new letter view models for each letter in the game word.
        for letter in gameWord.letters {
            self.letters.append(GameBoardLetterViewModel(letter: letter))
        }
    }
}
