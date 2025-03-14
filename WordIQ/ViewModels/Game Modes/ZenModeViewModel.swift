
/// ViewModel to handle the specific rules of Zen Mode
class ZenModeViewModel : GameViewModel {
    
    override func correctWordSubmitted() {
        // Call Base Logic
        super.correctWordSubmitted()
        
        if let activeWord = activeWord, let gameWord = activeWord.getWord() {
            self.gameOverModel.lastGuessedWord = gameWord
            self.gameOver()
        }
    }
    
    override func wrongWordSubmitted() {
        // Call Base Logic
        super.wrongWordSubmitted()
        
        // If the position has reached the end of the board, reset it
        if self.boardPosition % 6 == 0 {
            self.boardResetWithAnimation(delay: 1.0) {
                self.activeWord?.loadHints(self.targetWordHints)
            }
        }
        // Else set the active row down and load in the hints
        else {
            activeWord = gameBoardWords[self.boardPosition % 6]
            activeWord?.loadHints(targetWordHints)
        }
    }
}
