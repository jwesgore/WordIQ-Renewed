
/// ViewModel to handle the specific rules of Frenzy Mode
class FrenzyModeViewModel : SingleWordGameViewModel, ClockViewModelObserver {

    override init(gameOptions: SingleWordGameModeOptionsModel) {
        super.init(gameOptions: gameOptions)
        self.clock.addObserver(self)
    }

    /// Function to notify VM that the clock has reached zero
    func timerAtZero() {
        self.gameOver()
    }
    
    // MARK: Word Submitted Functions
    override func correctWordSubmitted() {
        // Call Base Logic
        super.correctWordSubmitted()
        
        // Update GameOverDataModel
        if let activeWord = gameBoardViewModel.activeWord, let gameWord = activeWord.getWord() {
            
            self.gameOverDataModel.correctlyGuessedWords?.append(gameWord)
            
            let newWord = WordDatabaseHelper.shared.fetchRandomFiveLetterWord(withDifficulty: gameOptions.gameDifficulty)
            self.gameOptions.targetWord = newWord
            self.gameOverDataModel.targetWord = newWord
            
            self.gameOverDataModel.lastGuessedWord = nil
            
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
