import SwiftUI

/// View model for displaying a word on the game over screen
class GameOverWordViewModel : GameWordBaseViewModel {
    
    /// Initializer with only a letters array
    init(_ letters: [GameBoardLetterViewModel], boardSpacing: CGFloat = 2.0) {
        super.init(boardWidth: letters.count, boardSpacing: boardSpacing)
        super.letters = letters
    }
    
    /// Initializer for a database word model
    init (_ word: DatabaseWordModel, boardSpacing: CGFloat = 2.0, id: UUID = UUID()) {
        let gameWord = GameWordModel(word.word)
        
        super.init(boardWidth: gameWord.letters.count, boardSpacing: boardSpacing, id: id)
        
        for letter in gameWord.letters {
            self.letters.append(GameBoardLetterViewModel(letter: letter))
        }
    }
}
