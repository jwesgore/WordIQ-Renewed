import SwiftUI

/// ViewModel to manage the playable game screen with a single game board.
///
/// This generic ViewModel provides the foundation for single-board gameplay, managing the game state,
/// keyboard interactions, and board functionalities. It supports persistence through save states
/// and navigation between game states.
class SingleBoardGameViewModel<TGameBoard: GameBoardViewModel> : SingleBoardGame {

    // MARK: - Properties
    
    /// Boolean to indicate whether the pause menu is displayed.
    @Published var showPauseMenu = false
    
    /// ViewModel to manage the game clock.
    var clockViewModel : ClockViewModel
    
    /// ViewModel for the game board.
    var gameBoardViewModel: TGameBoard
    
    /// Model containing the game options and configuration.
    var gameOptionsModel: SingleWordGameOptionsModel
    
    /// Model to store game-over data.
    var gameOverDataModel: GameOverDataModel
    
    /// ViewModel for the pause menu.
    lazy var gamePauseViewModel = GamePauseViewModel()
    
    /// Boolean to determine whether the keyboard is unlocked for input.
    var isKeyboardUnlocked = true {
        didSet {
            keyboardViewModel.isKeyboardUnlocked = isKeyboardUnlocked
        }
    }
    
    /// ViewModel for managing the keyboard interactions.
    lazy var keyboardViewModel: KeyboardViewModel = {
        KeyboardViewModel(keyboardAddLetter: self.keyboardAddLetter,
                          keyboardEnter: self.keyboardEnter,
                          keyboardDelete: self.keyboardDelete)
    }()
    
    /// The target word for the current game.
    var targetWord : DatabaseWordModel { return gameOptionsModel.targetWord }
    
    // MARK: - Initializers
    
    /// Base initializer to start a new game.
    /// - Parameter gameOptions: The configuration options for the game.
    init(gameOptions: SingleWordGameOptionsModel) {
        self.clockViewModel = ClockViewModel(timeLimit: gameOptions.timeLimit, isClockTimer: gameOptions.timeLimit > 0)
        self.gameBoardViewModel = TGameBoard(boardHeight: 6, boardWidth: 5, boardSpacing: 5.0)
        self.gameOptionsModel = gameOptions
        self.gameOverDataModel = gameOptions.getSingleWordGameOverDataModelTemplate()
        
        gamePauseViewModel.ResumeGameButton.action = self.resumeGame
        gamePauseViewModel.EndGameButton.action = self.exitGame
        
        print(self.targetWord)
    }
    
    /// Save state initializer to restore a previous game state.
    /// - Parameter gameSaveState: The saved state of the game.
    init(gameSaveState: GameSaveStateModel) {
        clockViewModel = ClockViewModel(gameSaveState.clockState)
        gameBoardViewModel = TGameBoard(boardHeight: 6, boardWidth: 5, boardSpacing: 5.0)
        gameOptionsModel = gameSaveState.gameOptionsModel
        gameOverDataModel = gameSaveState.gameOverModel
        
        gamePauseViewModel.ResumeGameButton.action = self.resumeGame
        gamePauseViewModel.EndGameButton.action = self.exitGame
        
        print(self.targetWord)
        
        // Restore keyboard and board from save state
        keyboardViewModel.loadSaveState(gameSaveState: gameSaveState)
        gameBoardViewModel.loadSaveState(gameSaveState: gameSaveState)
    }
    
    // MARK: - Keyboard Functions
    
    /// Adds a letter to the active word on the game board.
    /// - Parameter letter: The letter to add.
    func keyboardAddLetter(_ letter : ValidCharacters) {
        guard isKeyboardUnlocked else { return }
        
        gameBoardViewModel.addLetterToActiveWord(letter)
        
        if !clockViewModel.isClockActive {
            clockViewModel.startClock()
        }
    }
    
    /// Processes word submission from the keyboard.
    func keyboardEnter() {
        guard self.isKeyboardUnlocked else { return }
        
        guard let wordSubmitted = gameBoardViewModel.activeWord?.getWord(),
              WordDatabaseHelper.shared.doesFiveLetterWordExist(wordSubmitted) else {
            gameOverDataModel.numberOfInvalidGuesses += 1
            invalidWordSubmitted()
            return
        }
        
        isKeyboardUnlocked = false
        targetWord == wordSubmitted ? correctWordSubmitted() : wrongWordSubmitted()
        isKeyboardUnlocked = true
    }
    
    /// Deletes a letter from the active word on the game board.
    func keyboardDelete() {
        guard isKeyboardUnlocked else { return }
        
        gameBoardViewModel.removeLetterFromActiveWord()
    }
    
    // MARK: - Board Functions
    
    /// Resets the board to its default state.
    func resetBoardHard() {
        self.isKeyboardUnlocked = false
        self.gameBoardViewModel.resetBoardHard()
        self.isKeyboardUnlocked = true
    }
    
    /// Resets the board with animations.
    func resetBoardSoftWithAnimation(loadHints: Bool = false,
                                     animationLength: Double = 0.25,
                                     speed: Double = 4.0,
                                     delay: Double = 0.0,
                                     complete: @escaping () -> Void = {}) {
        self.isKeyboardUnlocked = false
        self.gameBoardViewModel.resetBoardWithAnimation(animationLength: animationLength,
                                                        speed: speed,
                                                        delay: delay,
                                                        loadHints: loadHints) {
            complete()
            self.isKeyboardUnlocked = true
        }
    }
    
    // MARK: - Enter Key Functions
    
    /// Handles the logic when a correct word is submitted.
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
    
    /// Handles the logic when an invalid word is submitted.
    func invalidWordSubmitted() {
        gameBoardViewModel.activeWord?.shake()
    }
    
    /// Handles the logic when a wrong word is submitted.
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
    
    /// Exits the game and navigates to game mode selection.
    func exitGame() {
        clockViewModel.stopClock()
        AppNavigationController.shared.exitFromSingleWordGame()
    }
    
    /// Ends the current game.
    /// - Parameter speed: The animation speed for ending the game.
    func gameOver(speed : Double = 1.5) {
        isKeyboardUnlocked = false
        showPauseMenu = false
        
        clockViewModel.stopClock()
        gameOverDataModel.timeElapsed = clockViewModel.timeElapsed
        
        AppNavigationController.shared.goToSingleWordGameOver()
    }
    
    /// Pauses the game.
    func pauseGame() {
        showPauseMenu = true
        clockViewModel.stopClock()
    }
    
    /// Restarts the game by resetting all components.
    func playAgain() {
        keyboardViewModel.resetKeyboard()
        gameBoardViewModel.resetBoardHard()
        clockViewModel.resetClock()
        
        gameOptionsModel.resetTargetWord()
        gameOverDataModel = gameOptionsModel.getSingleWordGameOverDataModelTemplate()
        isKeyboardUnlocked = true
        
        print(self.targetWord)
    }
    
    /// Resumes the game when paused.
    func resumeGame() {
        showPauseMenu = false
        clockViewModel.startClock()
    }

    // MARK: - Data Functions
    
    /// Creates a save state model based on the current game state.
    /// - Returns: A `GameSaveStateModel` instance representing the save state.
    func getGameSaveState() -> GameSaveStateModel {
        var keyboardSaveState: [ValidCharacters : LetterComparison] = [:]
        
        for (key, value) in self.keyboardViewModel.keyboardLetterButtons {
            keyboardSaveState[key] = value.backgroundColor
        }
        
        return GameSaveStateModel (
            clockState: self.clockViewModel.getClockSaveState(),
            gameBoard: self.gameBoardViewModel.getSaveState(),
            gameOptionsModel: self.gameOptionsModel,
            gameOverModel: self.gameOverDataModel,
            keyboardLetters: keyboardSaveState
        )
    }
}
