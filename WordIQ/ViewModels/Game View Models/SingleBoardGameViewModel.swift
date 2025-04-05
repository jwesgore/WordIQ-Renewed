import SwiftUI

/// ViewModel to manage the playable game screen with a single board
class SingleBoardGameViewModel : SingleBoardGame {

    // MARK: - Properties
    @Published var showPauseMenu = false
    
    var clockViewModel : ClockViewModel
    var gameBoardViewModel: GameBoardViewModel
    var gameOptionsModel: SingleBoardGameOptionsModel
    var gameOverDataModel: GameOverDataModel
    lazy var gamePauseViewModel = GamePauseViewModel()
    var isKeyboardUnlocked = true {
        didSet {
            keyboardViewModel.isKeyboardUnlocked = isKeyboardUnlocked
        }
    }
    lazy var keyboardViewModel: KeyboardViewModel = {
        KeyboardViewModel(keyboardAddLetter: self.keyboardAddLetter,
                          keyboardEnter: self.keyboardEnter,
                          keyboardDelete: self.keyboardDelete)
    }()
    var targetWord : DatabaseWordModel { return gameOptionsModel.targetWord }
    
    // MARK: - Initializers
    /// Base initializer
    init(gameOptions: SingleBoardGameOptionsModel) {
        // Init Variables
        self.clockViewModel = ClockViewModel(timeLimit: gameOptions.timeLimit, isClockTimer: gameOptions.timeLimit > 0)
        self.gameBoardViewModel = GameBoardViewModel(boardHeight: 6, boardWidth: 5, boardSpacing: 5.0)
        self.gameOptionsModel = gameOptions
        self.gameOverDataModel = gameOptions.getSingleWordGameOverDataModelTemplate()
        
        gamePauseViewModel.ResumeGameButton.action = self.resumeGame
        gamePauseViewModel.EndGameButton.action = self.exitGame
        
        print(self.targetWord)
    }
    
    /// Save state initializer
    init(gameSaveState: GameSaveStateModel) {
        // Init Variables
        clockViewModel = ClockViewModel(gameSaveState.clockState)
        gameBoardViewModel = GameBoardViewModel(boardHeight: 6, boardWidth: 5, boardSpacing: 5.0)
        gameOptionsModel = gameSaveState.gameOptionsModel
        gameOverDataModel = gameSaveState.gameOverModel
        
        gamePauseViewModel.ResumeGameButton.action = self.resumeGame
        gamePauseViewModel.EndGameButton.action = self.exitGame
        
        print(self.targetWord)
        
        // Populate Collections
        keyboardViewModel.loadSaveState(gameSaveState: gameSaveState)
        gameBoardViewModel.loadSaveState(gameSaveState: gameSaveState)
    }
    
    // MARK: - Keyboard functions
    /// Function to communicate to the active game word to add a letter
    func keyboardAddLetter(_ letter : ValidCharacters) {
        // Check that keyboard is active
        guard isKeyboardUnlocked else { return }
        
        // Add letter to game board
        gameBoardViewModel.addLetterToActiveWord(letter)
        
        // If clock is not active, start it up
        if !clockViewModel.isClockActive { clockViewModel.startClock() }
    }
    
    /// Function to communicate to subclass if the correct word or wrong word was submitted
    func keyboardEnter() {
        // Check that keyboard is active
        guard self.isKeyboardUnlocked else { return }
        
        // Check that the word submitted is a valid word
        guard let wordSubmitted = gameBoardViewModel.activeWord?.getWord(),
                WordDatabaseHelper.shared.doesFiveLetterWordExist(wordSubmitted) else {
            gameOverDataModel.numberOfInvalidGuesses += 1
            invalidWordSubmitted()
            return
        }
        
        // Lock the keyboard and determine if word is correct
        isKeyboardUnlocked = false
        targetWord == wordSubmitted ? correctWordSubmitted() : wrongWordSubmitted()
        isKeyboardUnlocked = true
    }
    
    /// Function to communicate to the active game word to delete a letter
    func keyboardDelete() {
        guard isKeyboardUnlocked else { return }
        
        gameBoardViewModel.removeLetterFromActiveWord()
    }

    // MARK: - Board functions
    /// Function to reset the board to its default state
    func resetBoardHard() {
        self.isKeyboardUnlocked = false
        self.gameBoardViewModel.resetBoardHard()
        self.isKeyboardUnlocked = true
    }
    
    /// Function to reset the board to its default state with an animation
    func resetBoardSoftWithAnimation(loadHints:Bool = false,
                                     animationLength: Double = 0.25,
                                     speed: Double = 4.0,
                                     delay: Double = 0.0,
                                     complete: @escaping () -> Void = {}) {
            // disable the keyboard
            self.isKeyboardUnlocked = false
            self.gameBoardViewModel.resetBoardWithAnimation(animationLength: animationLength,
                                                            speed: speed,
                                                            delay: delay,
                                                            loadHints: loadHints) {
                complete()
                self.isKeyboardUnlocked = true
            }
        }
    
    // MARK: - Enter Key pressed functions
    /// Handles what to do if the correct word is submitted
    func correctWordSubmitted() {
        guard let activeWord = gameBoardViewModel.activeWord,
              let gameWord = activeWord.getWord() else {
            fatalError("Unable to get active word")
        }
        
        // Set the backgrounds
        let comparisons = [LetterComparison](repeating: .correct, count: 5)
        gameBoardViewModel.setActiveWordBackground(comparisons)
        keyboardViewModel.keyboardSetBackgrounds(gameWord.comparisonRankingMap(comparisons))

        gameOverDataModel.addCorrectGuess(targetWord)
    }
    
    /// Handles what to do if an invalid word is submitted
    func invalidWordSubmitted() {
        gameBoardViewModel.activeWord?.shake()
    }
    
    /// Handles what to do if the wrong word is submitted
    func wrongWordSubmitted() {
        guard let activeWord = gameBoardViewModel.activeWord,
            let gameWord = activeWord.getWord() else {
            fatalError("Unable to get active word")
        }

        // Builds comparisons and updates backgrounds on board and keyboard
        let comparisons = gameWord.comparison(targetWord)
    
        gameBoardViewModel.setActiveWordBackground(comparisons)
        keyboardViewModel.keyboardSetBackgrounds(gameWord.comparisonRankingMap(comparisons))
        
        // Updates hints and game over model
        gameBoardViewModel.setTargetWordHints(comparisons)
        gameOverDataModel.addIncorrectGuess(targetWord.id, comparisons: comparisons)
    }
    
    // MARK: - Navigation functions
    /// Function to go back to game mode selection
    func exitGame() {
        clockViewModel.stopClock()
        AppNavigationController.shared.exitFromSingleWordGame()
    }
    
    /// Function to end the game
    func gameOver(speed : Double = 1.5) {
        isKeyboardUnlocked = false
        showPauseMenu = false
        
        clockViewModel.stopClock()
        gameOverDataModel.timeElapsed = clockViewModel.timeElapsed
        
        AppNavigationController.shared.goToSingleWordGameOver()
    }
    
    /// Function to pause the game
    func pauseGame() {
        showPauseMenu = true
        clockViewModel.stopClock()
    }
    
    /// Function to play a new game again
    func playAgain() {
        // Reset all components
        keyboardViewModel.resetKeyboard()
        gameBoardViewModel.resetBoardHard()
        clockViewModel.resetClock()
        
        gameOptionsModel.resetTargetWord()
        gameOverDataModel = gameOptionsModel.getSingleWordGameOverDataModelTemplate()
        isKeyboardUnlocked = true
        
        print(self.targetWord)
    }
    
    /// Function to resume the game when paused
    func resumeGame() {
        showPauseMenu = false
        clockViewModel.startClock()
    }

    // MARK: Data Functions
    /// Create Save State Model
    func getGameSaveState() -> GameSaveStateModel {

        // Get Keyboard save state
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
