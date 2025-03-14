
/// ViewModel to handle the specific rules of Frenzy Mode
class FrenzyModeViewModel : GameViewModel, ClockViewModelObserver {

    override init(gameOptions: GameModeOptionsModel) {
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
        if let activeWord = activeWord, let gameWord = activeWord.getWord() {
            
            self.gameOverModel.correctlyGuessedWords?.append(gameWord)
            
            self.gameOverModel.targetWord = WordDatabaseHelper.shared.fetchRandomWord(withDifficulty: gameOptions.gameDifficulty)
            self.targetWord = self.gameOverModel.targetWord
            
            self.gameOverModel.lastGuessedWord = nil
            
            self.boardResetWithAnimation(delay: 0.5) {
                self.targetWordHints = [ValidCharacters?](repeating: nil, count: 5)
                self.keyboardReset()
            }
        }
    }
    
    override func wrongWordSubmitted() {
        // Call Base Logic
        super.wrongWordSubmitted()
        
        if self.boardPosition == 6 {
            self.gameOver()
        } else {
            activeWord = gameBoardWords[self.boardPosition % 6]
            activeWord?.loadHints(targetWordHints)
        }
    }

}
