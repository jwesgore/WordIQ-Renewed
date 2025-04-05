
/// ViewModel to handle the specific rules of Frenzy Mode
class FrenzyModeViewModel : SingleBoardGameViewModel, ClockViewModelObserver {

    override init(gameOptions: SingleBoardGameOptionsModel) {
        super.init(gameOptions: gameOptions)
        super.clockViewModel.addObserver(self)
    }

    /// Function to notify VM that the clock has reached zero
    func timerAtZero() {
        self.gameOver()
    }
    
    // MARK: - Word Submitted Functions
    override func correctWordSubmitted() {
        // Call Base Logic
        super.correctWordSubmitted()
        
        // Update GameOverDataModel
        if let activeWord = gameBoardViewModel.activeWord, let gameWord = activeWord.getWord() {
            
            gameOptionsModel.resetTargetWord()
            gameOverDataModel.addNewWord(gameOptionsModel.targetWord)
            
            self.gameBoardViewModel.resetBoardWithAnimation(delay: 0.5, hardReset: true) {
                self.keyboardViewModel.resetKeyboard()
                self.isKeyboardUnlocked = true
            }
        }
    }
    
    override func wrongWordSubmitted() {
        // Call Base Logic
        super.wrongWordSubmitted()
        
        super.gameBoardViewModel.goToNextLine {
            super.gameOver()
        }
    }
}
