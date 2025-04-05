
/// ViewModel to handle the specific rules of Zen Mode
class ZenModeViewModel : SingleBoardGameViewModel {
    
    override func correctWordSubmitted() {
        // Call Base Logic
        super.correctWordSubmitted()
        
        if let activeWord = gameBoardViewModel.activeWord {
            super.gameOver()
        }
    }
    
    override func wrongWordSubmitted() {
        // Call Base Logic
        super.wrongWordSubmitted()
        
        // If the position has reached the end of the board, reset it
        super.gameBoardViewModel.goToNextLine {
            super.gameBoardViewModel.resetBoardWithAnimation(delay: 1.0, loadHints: true)
        }
    }
}
