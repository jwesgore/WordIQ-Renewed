
/// ViewModel to handle the specific rules of Standard Mode
class StandardModeViewModel : GameViewModel {
    
    override func correctWordSubmitted() {
        if let activeWord = ActiveWord, let gameWord = activeWord.getWord() {
            let comparison = [LetterComparison](repeating: .correct, count: 5)
            self.IsKeyboardActive = false
            activeWord.setBackgrounds(comparison)
            self.gameOverModel.gameResult = .win
            self.gameOverModel.lastGuessedWord = gameWord
            self.gameOverModel.numCorrectWords += 1
            self.gameover()
        }
    }
    
    override func invalidWordSubmitted() {
        if let activeWord = ActiveWord {
            activeWord.ShakeAnimation()
        }
        self.gameOverModel.numInvalidGuesses += 1
    }
    
    override func wrongWordSubmitted() {
        if let activeWord = ActiveWord, let gameWord = activeWord.getWord() {
            let comparison = TargetWord.comparison(gameWord)
            activeWord.setBackgrounds(comparison)
            
            self.BoardPosition += 1
            self.gameOverModel.numValidGuesses += 1
            self.gameOverModel.lastGuessedWord = gameWord
            
            if self.BoardPosition == 6 {
                self.IsKeyboardActive = false
                self.gameOverModel.gameResult = .lose
                self.gameover()
            } else {
                ActiveWord = GameBoardWords[self.BoardPosition % 6]
            }
        }
    }
    
}
