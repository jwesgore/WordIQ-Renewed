
/// ViewModel to handle the specific rules of Standard Mode
class StandardModeViewModel : GameViewModel {
    
    override func correctWordSubmitted() {
        // Call Base Logic
        super.correctWordSubmitted()
        
        // Apply Extra Logic
        if let activeWord = ActiveWord, let gameWord = activeWord.getWord() {
            self.gameOverModel.gameResult = .win
            self.gameOverModel.lastGuessedWord = gameWord
            self.gameover()
        }
    }
    
    override func wrongWordSubmitted() {
        // Call Base Logic
        super.wrongWordSubmitted()
        
        // Apply Extra Logic
        if self.BoardPosition == 6 {
            self.IsKeyboardActive = false
            self.gameOverModel.gameResult = .lose
            self.gameover()
        } else {
            ActiveWord = GameBoardWords[self.BoardPosition % 6]
            ActiveWord?.loadHints(TargetWordHints)
        }
    }
}
