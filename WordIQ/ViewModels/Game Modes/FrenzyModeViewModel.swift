
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
    override func correctWordSubmittedOverride() {
        if let activeWord = ActiveWord, let gameWord = activeWord.getWord() {
            self.gameOverModel.correctlyGuessedWords?.append(gameWord)
            
            self.TargetWord = DatabaseHelper.shared.fetchRandomWord(withDifficulty: gameOptions.gameDifficulty)
            
            self.gameOverModel.targetWord = self.TargetWord
            self.gameOverModel.lastGuessedWord = nil
            
            self.boardResetWithAnimation(delay: 1.0)
        }
    }
    
    override func invalidWordSubmittedOverride() {

    }
    
    override func wrongWordSubmittedOverride() {
        if self.BoardPosition == 6 {
            self.IsKeyboardActive = false
            self.gameover()
        } else {
            ActiveWord = GameBoardWords[self.BoardPosition % 6]
        }
    }

}
