
/// ViewModel to handle the specific rules of Zen Mode
class ZenModeViewModel : GameViewModel {
    
    override func correctWordSubmittedOverride() {
        if let activeWord = ActiveWord, let gameWord = activeWord.getWord() {
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
