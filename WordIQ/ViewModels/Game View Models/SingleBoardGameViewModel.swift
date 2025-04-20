import SwiftUI

/// ViewModel for managing the playable game screen with a single game board.
///
/// This generic ViewModel lays the foundation for single‑board gameplay by handling the game state,
/// keyboard interactions, board functionality, and persistence through save states. It also supports
/// navigation between different game states.
class SingleBoardGameViewModel<TGameBoard: GameBoardViewModel>: SingleBoardGame {

    // MARK: - Computed Properties

    /// Returns the appropriate game navigation controller based on the type of TGameBoard.
    var gameNavigationController: GameNavigationController {
        if TGameBoard.self == TwentyQuestionsGameBoardViewModel.self {
            return AppNavigationController.shared.twentyQuestionsNavigationController
        } else {
            return AppNavigationController.shared.singleWordGameNavigationController
        }
    }
    
    /// Returns the target word for the current game.
    var targetWord: DatabaseWordModel { return gameOptionsModel.targetWord }
    
    
    // MARK: - State Properties

    /// Indicates whether the header buttons are active.
    var isHeaderButtonsUnlocked = true {
        didSet {
            gameHeaderViewModel.isHeaderButtonsUnlocked = isHeaderButtonsUnlocked
        }
    }
    
    /// Indicates whether the keyboard is unlocked for input.
    var isKeyboardUnlocked = true {
        didSet {
            keyboardViewModel.isKeyboardUnlocked = isKeyboardUnlocked
        }
    }
    
    
    // MARK: - Core View Models & Models

    /// ViewModel that manages the game clock.
    var clockViewModel: ClockViewModel
    
    /// ViewModel for managing the game board.
    var gameBoardViewModel: TGameBoard
    
    /// The game options and configuration model.
    var gameOptionsModel: SingleWordGameOptionsModel
    
    /// The model that stores game‑over data.
    var gameOverDataModel: GameOverDataModel
    
    
    // MARK: - Lazy Loaded View Models

    /// ViewModel for the game header.
    ///
    /// This lazy property is initialized after self is fully created, ensuring that dependencies such as
    /// the clockViewModel and gameNavigationController are available.
    lazy var gameHeaderViewModel: GameHeaderViewModel = {
        GameHeaderViewModel(clock: self.clockViewModel, controller: self.gameNavigationController)
    }()
    
    /// ViewModel for managing keyboard interactions.
    ///
    /// This lazy property defers its initialization until after self is fully initialized.
    lazy var keyboardViewModel: KeyboardViewModel = {
        KeyboardViewModel(keyboardAddLetter: self.keyboardAddLetter,
                          keyboardEnter: self.keyboardEnter,
                          keyboardDelete: self.keyboardDelete)
    }()
    
    
    // MARK: - Initializers

    /// Base initializer to start a new game.
    ///
    /// Initializes the clock, game board, game options, and game‑over data models based on the provided game options.
    /// Prints the target word for debugging purposes.
    ///
    /// - Parameter gameOptions: The configuration options for the game.
    init(gameOptions: SingleWordGameOptionsModel) {
        clockViewModel = ClockViewModel(timeLimit: gameOptions.timeLimit,
                                        isClockTimer: gameOptions.timeLimit > 0)
        gameBoardViewModel = TGameBoard(boardHeight: 6, boardWidth: 5, boardSpacing: 5.0)
        gameOptionsModel = gameOptions
        gameOverDataModel = gameOptions.getSingleWordGameOverDataModelTemplate()
        
        print(self.targetWord)
    }
    
    /// Save state initializer to restore a previous game.
    ///
    /// Initializes the view models and models using a previously saved game state.
    /// Restores the keyboard and board state from the provided save state.
    ///
    /// - Parameter gameSaveState: The saved state to restore.
    init(gameSaveState: GameSaveStateModel) {
        clockViewModel = ClockViewModel(gameSaveState.clockState)
        gameBoardViewModel = TGameBoard(boardHeight: 6, boardWidth: 5, boardSpacing: 5.0)
        gameOptionsModel = gameSaveState.gameOptionsModel
        gameOverDataModel = gameSaveState.gameOverModel
        
        print(self.targetWord)
        
        // Restore keyboard and board from the save state.
        keyboardViewModel.loadSaveState(gameSaveState: gameSaveState)
        gameBoardViewModel.loadSaveState(gameSaveState: gameSaveState)
    }
    
    
    // MARK: - Keyboard Functions

    /// Adds a letter to the active word on the game board.
    ///
    /// If the keyboard is unlocked, appends the letter to the active word and starts the clock if it isn't already active.
    ///
    /// - Parameter letter: The letter to add.
    func keyboardAddLetter(_ letter: ValidCharacters) {
        guard isKeyboardUnlocked else { return }
        
        gameBoardViewModel.addLetterToActiveWord(letter)
        
        if !clockViewModel.isClockActive {
            clockViewModel.startClock()
        }
    }
    
    /// Processes the word submission via the keyboard.
    ///
    /// Verifies that the submitted word exists in the word database. If invalid, increments
    /// the count of invalid guesses and triggers an animation. If valid, locks the keyboard and processes
    /// the word submission as correct or wrong.
    func keyboardEnter() {
        guard isKeyboardUnlocked else { return }
        
        // Verify if word is valid
        guard let wordSubmitted = gameBoardViewModel.activeWord?.getWord(),
              WordDatabaseHelper.shared.doesFiveLetterWordExist(wordSubmitted) else {
            gameOverDataModel.numberOfInvalidGuesses += 1
            invalidWordSubmitted()
            return
        }
        
        isKeyboardUnlocked = false
        gameOverDataModel.startWord = gameOverDataModel.startWord ?? wordSubmitted.word
        targetWord == wordSubmitted ? correctWordSubmitted() : wrongWordSubmitted()
        isKeyboardUnlocked = true
    }
    
    /// Deletes the last letter from the active word on the game board.
    func keyboardDelete() {
        guard isKeyboardUnlocked else { return }
        
        gameBoardViewModel.removeLetterFromActiveWord()
    }
    
    
    // MARK: - Board Functions

    /// Resets the game board to its default state.
    ///
    /// Temporarily disables keyboard interactions during the reset.
    func resetBoardHard() {
        isKeyboardUnlocked = false
        gameBoardViewModel.resetBoardHard()
        isKeyboardUnlocked = true
    }
    
    /// Resets the game board with an animation.
    ///
    /// Temporarily disables keyboard interactions during the reset, optionally loads hints,
    /// and executes a completion closure once finished.
    ///
    /// - Parameters:
    ///   - loadHints: Indicates whether hints should be reloaded after the reset. Defaults to `false`.
    ///   - animationLength: The duration of the animation in seconds. Defaults to `0.25`.
    ///   - speed: The speed factor for the animation. Defaults to `4.0`.
    ///   - delay: The delay before the animation begins, in seconds. Defaults to `0.0`.
    ///   - complete: A closure executed after the reset completes. Defaults to an empty closure.
    func resetBoardSoftWithAnimation(loadHints: Bool = false,
                                     animationLength: Double = 0.25,
                                     speed: Double = 4.0,
                                     delay: Double = 0.0,
                                     complete: @escaping () -> Void = {}) {
        isKeyboardUnlocked = false
        gameBoardViewModel.resetBoardWithAnimation(animationLength: animationLength,
                                                   speed: speed,
                                                   delay: delay,
                                                   loadHints: loadHints) {
            complete()
            self.isKeyboardUnlocked = true
        }
    }
    
    
    // MARK: - Word Submission Functions

    /// Processes a correct word submission.
    ///
    /// Updates the game board and keyboard backgrounds to indicate correct guesses and records the correct guess in the game-over data model.
    func correctWordSubmitted() {
        guard let activeWord = gameBoardViewModel.activeWord,
              let gameWord = activeWord.getWord() else {
            fatalError("Unable to get active word")
        }
        
        let comparisons = [LetterComparison](repeating: .correct, count: 5)
        gameBoardViewModel.setActiveWordBackground(comparisons)
        keyboardViewModel.keyboardSetBackgrounds(gameWord.comparisonRankingMap(comparisons))
        
        gameOverDataModel.addCorrectGuess(targetWord)
    }
    
    /// Processes an invalid word submission.
    ///
    /// Triggers a shake animation on the active word to indicate an invalid submission.
    func invalidWordSubmitted() {
        gameBoardViewModel.activeWord?.shake()
    }
    
    /// Processes a wrong (but valid) word submission.
    ///
    /// Compares the submitted word with the target word, updates the game board and keyboard backgrounds with the results,
    /// sets hints on the board, and records the incorrect guess in the game-over data model.
    func wrongWordSubmitted() {
        guard let activeWord = gameBoardViewModel.activeWord,
              let gameWord = activeWord.getWord() else {
            fatalError("Unable to get active word")
        }
        
        let comparisons = gameWord.comparison(targetWord)
        gameBoardViewModel.setActiveWordBackground(comparisons)
        keyboardViewModel.keyboardSetBackgrounds(gameWord.comparisonRankingMap(comparisons))
        
        gameBoardViewModel.setTargetWordHints(comparisons)
        gameOverDataModel.addIncorrectGuess(targetWord.id, comparisons: comparisons)
    }
    
    
    // MARK: - Navigation Functions
    
    /// Ends the current game.
    ///
    /// Locks keyboard and header input, stops the game clock, updates the elapsed time in the game-over data model,
    /// and navigates to the game over screen.
    ///
    /// - Parameter speed: The animation speed for ending the game, in seconds. Defaults to `1.5`.
    func gameOver(speed: Double = 1.5) {
        isKeyboardUnlocked = false
        isHeaderButtonsUnlocked = false
        
        clockViewModel.stopClock()
        gameOverDataModel.timeElapsed = clockViewModel.timeElapsed
        
        AppNavigationController.shared.goToSingleWordGameOver()
    }
    
    /// Restarts the game by resetting all components.
    ///
    /// Resets the keyboard, game board, and clock; reinitializes the game-over data model; resets the target word;
    /// and then unlocks the keyboard and header buttons.
    func playAgain() {
        keyboardViewModel.resetKeyboard()
        gameBoardViewModel.resetBoardHard()
        clockViewModel.resetClock()
        
        gameOptionsModel.resetTargetWord()
        gameOverDataModel = gameOptionsModel.getSingleWordGameOverDataModelTemplate()
        isKeyboardUnlocked = true
        isHeaderButtonsUnlocked = true
        
        print(self.targetWord)
    }
    
    
    // MARK: - Data Functions
    
    /// Creates a save state model representing the current game state.
    ///
    /// Captures the state of the clock, game board, game options, game‑over data,
    /// and keyboard background colors into a `GameSaveStateModel`.
    ///
    /// - Returns: A `GameSaveStateModel` instance encapsulating the current game state.
    func getGameSaveState() -> GameSaveStateModel {
        var keyboardSaveState: [ValidCharacters: LetterComparison] = [:]
        
        for (key, value) in self.keyboardViewModel.keyboardLetterButtons {
            keyboardSaveState[key] = value.backgroundColor
        }
        
        return GameSaveStateModel(
            clockState: self.clockViewModel.getClockSaveState(),
            gameBoard: self.gameBoardViewModel.getSaveState(),
            gameOptionsModel: self.gameOptionsModel,
            gameOverModel: self.gameOverDataModel,
            keyboardLetters: keyboardSaveState
        )
    }
}
