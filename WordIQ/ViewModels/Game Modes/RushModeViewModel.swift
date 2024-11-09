
/// ViewModel to handle the specific rules of Rush Mode
class RushModeViewModel : GameViewModel, ClockViewModelObserver {
    
    override init(gameOptions: GameModeOptionsModel) {
        super.init(gameOptions: gameOptions)
        self.Clock.addObserver(self)
    }
    
    /// Function to notify VM that the clock has reached zero
    func timerAtZero() {
        self.gameOverModel.gameResult = .lose
        self.gameover()
    }
    
    // MARK: Word Submitted Functions
    override func correctWordSubmitted() {
        if let activeWord = ActiveWord, let gameWord = activeWord.getWord() {
            let comparison = [LetterComparison](repeating: .correct, count: 5)
            self.IsKeyboardActive = false
            activeWord.setBackgrounds(comparison)
            self.keyboardSetBackgrounds(gameWord.comparisonRankingMap(comparison))
            
            self.gameOverModel.gameResult = .win
            self.gameOverModel.lastGuessedWord = gameWord
            self.gameOverModel.numCorrectWords += 1
            self.gameover()
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
            self.keyboardSetBackgrounds(gameWord.comparisonRankingMap(comparison))
            
            self.BoardPosition += 1
            self.gameOverModel.numValidGuesses += 1
            self.gameOverModel.lastGuessedWord = gameWord
            
            if self.BoardPosition % 6 == 0 {
                self.boardResetWithAnimation(delay: 1.0)
            }
            
            ActiveWord = GameBoardWords[self.BoardPosition % 6]
        }
    }

}
