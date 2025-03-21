
/// ViewModel to handle the specific rules of Zen Mode
class ZenModeViewModel : SingleWordGameViewModel {
    
    override func correctWordSubmitted() {
        // Call Base Logic
        super.correctWordSubmitted()
        
        if let activeWord = gameBoardViewModel.activeWord, let gameWord = activeWord.getWord() {
            self.gameOverModel.lastGuessedWord = gameWord
            self.gameOver()
        }
    }
    
    override func wrongWordSubmitted() {
        // Call Base Logic
        super.wrongWordSubmitted()
        
        // If the position has reached the end of the board, reset it
        super.gameBoardViewModel.goToNextLine {
            self.gameBoardViewModel.resetBoardWithAnimation(delay: 1.0, loadHints: true)
        }
    }
}
