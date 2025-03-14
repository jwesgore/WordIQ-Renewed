
/// ViewModel to handle the specific rules of Standard Mode
class StandardModeViewModel : GameViewModel {
    
    override func correctWordSubmitted() {
        // Call Base Logic
        super.correctWordSubmitted()
        
        // Apply Extra Logic
        if let activeWord = activeWord, let gameWord = activeWord.getWord() {
            self.gameOverModel.gameResult = .win
            self.gameOverModel.lastGuessedWord = gameWord
            self.gameOver()
        }
    }
    
    override func wrongWordSubmitted() {
        // Call Base Logic
        super.wrongWordSubmitted()
        
        // Apply Extra Logic
        if self.boardPosition == 6 {
            self.isKeyboardActive = false
            self.gameOverModel.gameResult = .lose
            self.gameOver()
        } else {
            activeWord = gameBoardWords[self.boardPosition % 6]
            activeWord?.loadHints(targetWordHints)
        }
    }
}
