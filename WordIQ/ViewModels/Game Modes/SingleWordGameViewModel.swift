import SwiftUI

/// ViewModel to manage the playable game screen with a single board
class SingleWordGameViewModel : SingleWordGameBaseProtocol {
    
    let appNavigationController : AppNavigationController
    var gameNavigationController : SingleWordGameNavigationController
    
    // MARK: Properties
    @Published var showPauseMenu = false
    
    var clock : ClockViewModel
    var gameBoardViewModel: GameBoardViewModel
    var gameOptions: SingleWordGameModeOptionsModel
    var gameOverModel: SingleWordGameOverDataModel
    var gameOverViewModel: SingleWordGameOverViewModel {
        let gameOverVM = SingleWordGameOverViewModel(gameOverModel)
        gameOverVM.playAgainButton.action = self.playAgain
        gameOverVM.backButton.action = self.exitGame
        return gameOverVM
    }
    var gamePauseViewModel: GamePauseViewModel {
        let gamePauseVM = GamePauseViewModel()
        gamePauseVM.ResumeGameButton.action = self.resumeGame
        gamePauseVM.EndGameButton.action = self.exitGame
        return gamePauseVM
    }
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
    var targetWord : DatabaseWordModel
    var exitGameAction: () -> Void = {}
    
    // MARK: Initializers
    /// Base initializer
    init(gameOptions: SingleWordGameModeOptionsModel) {
        // Step 1: Init Controllers
        self.appNavigationController = AppNavigationController.shared
        self.gameNavigationController = SingleWordGameNavigationController.shared
        
        // Step 2: Init Variables
        self.clock = ClockViewModel(timeLimit: gameOptions.timeLimit, isClockTimer: gameOptions.timeLimit > 0)
        self.gameBoardViewModel = GameBoardViewModel(boardHeight: 6, boardWidth: 5, boardSpacing: 5.0)
        self.gameOptions = gameOptions
        self.gameOverModel = SingleWordGameOverDataModel(gameOptions)
        self.targetWord = gameOptions.targetWord
        
        print(self.targetWord)
    }
    
    /// Save state initializer
    init(gameSaveState: GameSaveStateModel) {
        // Step 1: Init Controllers
        self.appNavigationController = AppNavigationController.shared
        self.gameNavigationController = SingleWordGameNavigationController.shared
        
        // Step 2: Init Variables
        self.clock = ClockViewModel(gameSaveState.clockState)
        self.gameBoardViewModel = GameBoardViewModel(boardHeight: 6, boardWidth: 5, boardSpacing: 5.0)
        self.gameOptions = gameSaveState.gameOptionsModel
        self.gameOverModel = gameSaveState.gameOverModel
        self.targetWord = gameSaveState.gameOptionsModel.targetWord
        
        print(self.targetWord)
        
        // Step 2: Populate Collections
        self.keyboardViewModel.loadSaveState(gameSaveState: gameSaveState)
        self.gameBoardViewModel.loadSaveState(gameSaveState: gameSaveState)
    }
    
    // MARK: Keyboard functions
    /// Function to communicate to the active game word to add a letter
    func keyboardAddLetter(_ letter : ValidCharacters) {
        guard isKeyboardUnlocked else { return }
        
        gameBoardViewModel.addLetterToActiveWord(letter)
        
        if !clock.isClockActive { clock.startClock() }
    }
    
    /// Function to communicate to subclass if the correct word or wrong word was submitted
    func keyboardEnter() {
        guard self.isKeyboardUnlocked else { return }
        
        guard let wordSubmitted = gameBoardViewModel.activeWord?.getWord(),
                WordDatabaseHelper.shared.doesFiveLetterWordExist(wordSubmitted) else {
            invalidWordSubmitted()
            return
        }
        
        isKeyboardUnlocked = false
        
        gameOverModel.numValidGuesses += 1
        targetWord == wordSubmitted ? correctWordSubmitted() : wrongWordSubmitted()
    }
    
    /// Function to communicate to the active game word to delete a letter
    func keyboardDelete() {
        guard isKeyboardUnlocked else { return }
        
        gameBoardViewModel.removeLetterFromActiveWord()
    }

    // MARK: Board functions
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
    
    // MARK: Enter Key pressed functions
    /// Handles what to do if the correct word is submitted
    func correctWordSubmitted() {
        guard let activeWord = gameBoardViewModel.activeWord,
              let gameWord = activeWord.getWord() else {
            fatalError("Unable to get active word")
        }

        let comparisons = [LetterComparison](repeating: .correct, count: 5)
        
        gameBoardViewModel.setActiveWordBackground(comparisons)
        
        keyboardViewModel.keyboardSetBackgrounds(gameWord.comparisonRankingMap(comparisons))

        gameOverModel.numCorrectWords += 1
    }
    
    /// Handles what to do if an invalid word is submitted
    func invalidWordSubmitted() {
        gameBoardViewModel.activeWord?.shake()
        gameOverModel.numInvalidGuesses += 1
    }
    
    /// Handles what to do if the wrong word is submitted
    func wrongWordSubmitted() {
        guard let activeWord = gameBoardViewModel.activeWord,
                let gameWord = activeWord.getWord() else {
            fatalError("Unable to get active word")
        }
        

        // Builds comparisons and updates backgrounds on board and keyboard
        let comparisons = gameWord.comparison(targetWord)
    
        activeWord.setBackgrounds(comparisons)
        keyboardViewModel.keyboardSetBackgrounds(gameWord.comparisonRankingMap(comparisons))
        
        // Updates hints
        gameBoardViewModel.setTargetWordHints(comparisons)
        
        // Updates gameOverModel
        gameOverModel.lastGuessedWord = gameWord
        
        isKeyboardUnlocked = true
    }
    
    // MARK: Navigation functions
    /// Function to go back to game mode selection
    func exitGame() {
        self.exitGameAction()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.gameNavigationController.dispose()
        }
    }
    
    /// Function to end the game
    func gameOver(speed : Double = 1.5) {
        self.isKeyboardUnlocked = false
        self.showPauseMenu = false
        
        self.clock.stopClock()
        self.gameOverModel.timeElapsed = self.clock.timeElapsed
        
        self.gameNavigationController.goToViewWithAnimation(.gameOver)
    }
    
    /// Function to pause the game
    func pauseGame() {
        self.showPauseMenu = true
        self.clock.stopClock()
    }
    
    /// Function to play a new game again
    func playAgain() {
        self.gameNavigationController.goToViewWithAnimation(.singleWordGame)
        self.keyboardViewModel.resetKeyboard()
        self.gameBoardViewModel.resetBoardHard()
        self.clock.resetClock()
        
        self.gameOptions.resetTargetWord()
        self.gameOverModel = SingleWordGameOverDataModel(self.gameOptions)
        
        self.targetWord = self.gameOverModel.targetWord
        self.isKeyboardUnlocked = true
        print(self.targetWord)
    }
    
    /// Function to resume the game when paused
    func resumeGame() {
        self.showPauseMenu = false
        self.clock.startClock()
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
            clockState: self.clock.getClockSaveState(),
            gameBoard: self.gameBoardViewModel.getSaveState(),
            gameOptionsModel: self.gameOptions,
            gameOverModel: self.gameOverModel,
            keyboardLetters: keyboardSaveState
        )
    }
}
