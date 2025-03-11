
/// ViewModel to handle the specific rules of Rush Mode
class RushModeViewModel : GameViewModel, ClockViewModelObserver {
    
    override init(gameOptions: GameModeOptionsModel) {
        super.init(gameOptions: gameOptions)
        self.Clock.addObserver(self)
    }
    
    override func gameStartedOverride() {
        
    }
    
    /// Function to notify VM that the clock has reached zero
    func timerAtZero() {
        self.gameOverModel.gameResult = .lose
        self.gameover()
    }
    
    // MARK: Word Submitted Functions
    override func correctWordSubmittedOverride() {
        if let activeWord = ActiveWord, let gameWord = activeWord.getWord() {
            self.gameOverModel.gameResult = .win
            self.gameOverModel.lastGuessedWord = gameWord
            self.gameover()
        }
    }
    
    override func invalidWordSubmittedOverride() {

    }
    
    override func wrongWordSubmittedOverride() {
        // If the position has reached the end of the board, reset it
        if self.BoardPosition % 6 == 0 {
            self.boardResetWithAnimation(delay: 1.0) {
                self.ActiveWord = self.GameBoardWords[self.BoardPosition % 6]
                self.ActiveWord?.loadHints(self.TargetWordHints)
            }
        }
        // Else set the active row down and load in the hints
        else {
            ActiveWord = GameBoardWords[self.BoardPosition % 6]
            ActiveWord?.loadHints(TargetWordHints)
        }
    }

}
