/// ViewModel responsible for managing the specific rules and logic of Standard Mode.
///
/// This class extends `SingleBoardGameViewModel` to implement standard game mechanics
/// with win/lose conditions based on word submissions and board state.
class StandardModeViewModel : SingleBoardGameViewModel<GameBoardViewModel> {

    /// Handles logic for submitting a correct word in Standard Mode.
    ///
    /// Executes the base logic for correct word submission, updates the `GameOverDataModel`
    /// to reflect a win condition, and ends the game.
    override func correctWordSubmitted() {
        super.correctWordSubmitted()  // Call base class logic
        
        // Update game result to win and end the game
        self.gameOverDataModel.gameResult = .win
        self.gameOver()
    }
    
    /// Handles logic for submitting a wrong word in Standard Mode.
    ///
    /// Executes the base logic for wrong word submission, advances to the next line
    /// on the board, and ends the game with a loss condition when the board reaches
    /// its maximum capacity.
    override func wrongWordSubmitted() {
        super.wrongWordSubmitted()  // Call base class logic
        
        // Advance to next line and handle end-game logic
        super.gameBoardViewModel.goToNextLine {
            super.gameOverDataModel.gameResult = .lose
            super.gameOver()
        }
    }
}
