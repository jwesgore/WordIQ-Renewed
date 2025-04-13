/// ViewModel responsible for managing the specific rules and logic of Rush Mode.
///
/// This class extends `SingleBoardGameViewModel` to implement game mechanics specific to Rush Mode,
/// where players race against the clock to submit correct words. It observes the clock to handle
/// game-over conditions when the timer reaches zero.
class RushModeViewModel : SingleBoardGameViewModel<GameBoardViewModel>, ClockViewModelObserver {

    /// Initializes the RushModeViewModel with the given game options and sets up clock observation.
    /// - Parameter gameOptions: The configuration options for the game, including target word and gameplay settings.
    override init(gameOptions: SingleWordGameOptionsModel) {
        super.init(gameOptions: gameOptions)
        self.clockViewModel.addObserver(self)
    }
    
    /// Called when the timer reaches zero to handle the game-over scenario.
    ///
    /// Updates the `GameOverDataModel` to reflect the loss condition and ends the game.
    func timerAtZero() {
        self.gameOverDataModel.gameResult = .lose
        self.gameOver()
    }
    
    /// Handles logic for submitting a correct word in Rush Mode.
    ///
    /// Updates the `GameOverDataModel` to reflect a win condition and ends the game immediately.
    override func correctWordSubmitted() {
        super.correctWordSubmitted()  // Call base class logic
        self.gameOverDataModel.gameResult = .win
        self.gameOver()
    }
    
    /// Handles logic for submitting a wrong word in Rush Mode.
    ///
    /// Advances to the next line on the board, and if the position reaches the end of the board,
    /// resets it with animations and optional hints.
    override func wrongWordSubmitted() {
        super.wrongWordSubmitted()  // Call base class logic
        
        super.gameBoardViewModel.goToNextLine {
            self.gameBoardViewModel.resetBoardWithAnimation(delay: 1.0, loadHints: true)
        }
    }
}
