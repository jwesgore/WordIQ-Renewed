/// ViewModel responsible for managing the specific rules and logic of Zen Mode.
///
/// This class extends `SingleBoardGameViewModel` and provides a relaxed game experience
/// without strict time constraints or win/lose conditions. It overrides word submission
/// logic to handle gameplay in Zen Mode.
class ZenModeViewModel : SingleBoardGameViewModel<GameBoardViewModel> {

    /// Handles logic for submitting a correct word in Zen Mode.
    ///
    /// Executes the base logic for correct word submission and ends the current game.
    /// In Zen Mode, every correct word leads to a graceful conclusion of the game.
    override func correctWordSubmitted() {
        super.correctWordSubmitted()  // Call base class logic
        super.gameOver()
    }
    
    /// Handles logic for submitting a wrong word in Zen Mode.
    ///
    /// Executes the base logic for wrong word submission, advances to the next line
    /// on the board, and resets the board with animations if the position reaches
    /// the end of the board.
    override func wrongWordSubmitted() {
        super.wrongWordSubmitted()  // Call base class logic
        
        super.gameBoardViewModel.goToNextLine {
            super.gameBoardViewModel.resetBoardWithAnimation(delay: 1.0, loadHints: true)
        }
    }
}
