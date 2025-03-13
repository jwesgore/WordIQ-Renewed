
/// ViewModel to handle the specific rules of Frenzy Mode
class FrenzyModeViewModel : GameViewModel, ClockViewModelObserver {

    override init(gameOptions: GameModeOptionsModel) {
        super.init(gameOptions: gameOptions)
        self.Clock.addObserver(self)
    }

    /// Function to notify VM that the clock has reached zero
    func timerAtZero() {
        self.gameover()
    }
    
    // MARK: Word Submitted Functions
    override func correctWordSubmitted() {
        // Call Base Logic
        super.correctWordSubmitted()
        
        // Update GameOverDataModel
        if let activeWord = ActiveWord, let gameWord = activeWord.getWord() {
            
            self.gameOverModel.correctlyGuessedWords?.append(gameWord)
            
            self.gameOverModel.targetWord = WordDatabaseHelper.shared.fetchRandomWord(withDifficulty: gameOptions.gameDifficulty)
            self.TargetWord = self.gameOverModel.targetWord
            
            self.gameOverModel.lastGuessedWord = nil
            
            self.boardResetWithAnimation(delay: 0.5) {
                self.TargetWordHints = [ValidCharacters?](repeating: nil, count: 5)
                self.keyboardReset()
            }
        }
    }
    
    override func wrongWordSubmitted() {
        // Call Base Logic
        super.wrongWordSubmitted()
        
        if self.BoardPosition == 6 {
            self.gameover()
        } else {
            ActiveWord = GameBoardWords[self.BoardPosition % 6]
            ActiveWord?.loadHints(TargetWordHints)
        }
    }

}
