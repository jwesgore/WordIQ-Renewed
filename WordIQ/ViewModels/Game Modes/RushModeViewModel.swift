
/// ViewModel to handle the specific rules of Rush Mode
class RushModeViewModel : SingleWordGameViewModel, ClockViewModelObserver {
    
    override init(gameOptions: SingleWordGameModeOptionsModel) {
        super.init(gameOptions: gameOptions)
        self.clock.addObserver(self)
    }
    
    /// Function to notify VM that the clock has reached zero
    func timerAtZero() {
        self.gameOverModel.gameResult = .lose
        self.gameOver()
    }
    
    // MARK: Word Submitted Functions
    override func correctWordSubmitted() {
        // Call Base Logic
        super.correctWordSubmitted()
        
        if let activeWord = gameBoardViewModel.activeWord, let gameWord = activeWord.getWord() {
            self.gameOverModel.gameResult = .win
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
