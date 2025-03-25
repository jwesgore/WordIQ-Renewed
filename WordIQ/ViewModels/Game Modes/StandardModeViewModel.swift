
/// ViewModel to handle the specific rules of Standard Mode
class StandardModeViewModel : SingleWordGameViewModel {
    
    override func correctWordSubmitted() {
        // Call Base Logic
        super.correctWordSubmitted()
        
        // Apply Extra Logic
        if let activeWord = gameBoardViewModel.activeWord, let gameWord = activeWord.getWord() {
            self.gameOverDataModel.gameResult = .win
            self.gameOverDataModel.lastGuessedWord = gameWord
            self.gameOver()
        }
    }
    
    override func wrongWordSubmitted() {
        // Call Base Logic
        super.wrongWordSubmitted()
        
        // Apply Extra Logic
        super.gameBoardViewModel.goToNextLine() {
            super.isKeyboardUnlocked = false
            super.gameOverDataModel.gameResult = .lose
            super.gameOver()
        }
    }
}
