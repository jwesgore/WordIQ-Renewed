/// ViewModel responsible for handling the specific game rules of Frenzy Mode.
///
/// This class extends `SingleBoardGameViewModel` with additional logic for managing
/// time-sensitive gameplay mechanics. It observes the clock to handle game-over
/// scenarios triggered by the timer reaching zero.
class FrenzyModeViewModel : SingleBoardGameViewModel<GameBoardViewModel>, ClockViewModelObserver {

    /// Initializes the FrenzyModeViewModel with game options and sets up necessary observers.
    /// - Parameter gameOptions: The configuration options for the game, including target word and gameplay settings.
    override init(gameOptions: SingleWordGameOptionsModel) {
        super.init(gameOptions: gameOptions)
        super.clockViewModel.addObserver(self)
    }
    
    /// Handles logic for submitting a correct word in Frenzy Mode.
    ///
    /// Updates the target word, appends the new word to `GameOverDataModel`,
    /// and resets the game board and keyboard with animations.
    override func correctWordSubmitted() {
        super.correctWordSubmitted()  // Call base class logic

        gameOptionsModel.resetTargetWord()
        gameOverDataModel.addNewWord(gameOptionsModel.targetWord)

        // Reset board and keyboard with animation
        self.gameBoardViewModel.resetBoardWithAnimation(delay: 0.5, hardReset: true) {
            self.keyboardViewModel.resetKeyboard()
        }
    }
    
    /// Handles logic for submitting a wrong word in Frenzy Mode.
    ///
    /// Advances to the next line on the board and ends the game
    /// if the board is maxed out.
    override func wrongWordSubmitted() {
        super.wrongWordSubmitted()  // Call base class logic

        super.gameBoardViewModel.goToNextLine {
            super.gameOver()  // End the game when the board reaches its limit
        }
    }
    
    /// Notifies the ViewModel when the timer reaches zero and ends the game.
    func timerAtZero() {
        self.gameOver()
    }
}
