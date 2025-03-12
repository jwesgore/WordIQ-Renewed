
/// ViewModel to handle the specific rules of Zen Mode
class ZenModeViewModel : GameViewModel {
    
    override func correctWordSubmitted() {
        // Call Base Logic
        super.correctWordSubmitted()
        
        if let activeWord = ActiveWord, let gameWord = activeWord.getWord() {
            self.gameOverModel.lastGuessedWord = gameWord
            self.gameover()
        }
    }
    
    override func wrongWordSubmitted() {
        // Call Base Logic
        super.wrongWordSubmitted()
        
        // If the position has reached the end of the board, reset it
        if self.BoardPosition % 6 == 0 {
            self.boardResetWithAnimation(delay: 1.0) {
                self.ActiveWord?.loadHints(self.TargetWordHints)
            }
        }
        // Else set the active row down and load in the hints
        else {
            ActiveWord = GameBoardWords[self.BoardPosition % 6]
            ActiveWord?.loadHints(TargetWordHints)
        }
    }
}
