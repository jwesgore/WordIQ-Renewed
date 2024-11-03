
/// ViewModel to handle the specific rules of Frenzy Mode
class FrenzyModeViewModel : GameViewModel, ClockViewModelObserver {

    override init(gameOptions: GameModeOptionsModel) {
        super.init(gameOptions: gameOptions)
        self.Clock.addObserver(self)
    }
    
    /// Function to notify VM that the clock has reached zero
    func timerAtZero() {
        
    }
    
    // MARK: Word Submitted Functions
    override func correctWordSubmitted() {
        if let activeWord = ActiveWord, let gameWord = activeWord.getWord() {
            let comparison = [LetterComparison](repeating: .correct, count: 5)
            self.IsKeyboardActive = false
            activeWord.setBackgrounds(comparison)
            
            self.gameOverModel.correctlyGuessedWords?.append(gameWord)
            
            self.TargetWord = DatabaseHelper.shared.fetchRandomWord(withDifficulty: gameOptions.gameDifficulty)
            
            self.gameOverModel.targetWord = self.TargetWord
            self.gameOverModel.lastGuessedWord = nil
            self.gameOverModel.numCorrectWords += 1
            
            self.boardResetWithAnimation(delay: 1.0)
        }
    }
    
    override func invalidWordSubmitted() {
        if let activeWord = ActiveWord {
            activeWord.ShakeAnimation()
        }
        self.gameOverModel.numInvalidGuesses += 1
    }
    
    override func wrongWordSubmitted() {
        if let activeWord = ActiveWord, let gameWord = activeWord.getWord() {
            let comparison = TargetWord.comparison(gameWord)
            activeWord.setBackgrounds(comparison)
            
            self.BoardPosition += 1
            self.gameOverModel.numValidGuesses += 1
            self.gameOverModel.lastGuessedWord = gameWord
            
            if self.BoardPosition == 6 {
                self.IsKeyboardActive = false
            } else {
                ActiveWord = GameBoardWords[self.BoardPosition % 6]
            }
        }
    }

}
