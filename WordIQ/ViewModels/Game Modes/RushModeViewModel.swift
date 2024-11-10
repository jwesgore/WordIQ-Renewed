
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
        if self.BoardPosition % 6 == 0 {
            self.boardResetWithAnimation(delay: 1.0)
        }
        
        ActiveWord = GameBoardWords[self.BoardPosition % 6]
    }

}
