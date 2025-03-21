import SwiftUI

/// ViewModel to manage the playable game screen with a single board
class SingleWordGameViewModel : BaseViewNavigation {
    
    // MARK: Properties
    @Published var showPauseMenu = false
    
    var clock : ClockViewModel
    var gameBoardViewModel: GameBoardViewModel
    let gameOptions: GameModeOptionsModel
    var gameOverModel: GameOverDataModel
    var gameOverViewModel: GameOverViewModel {
        let gameOverVM = GameOverViewModel(gameOverModel)
        gameOverVM.PlayAgainButton.action = self.playAgain
        gameOverVM.BackButton.action = self.exitGame
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
    init(gameOptions: GameModeOptionsModel) {
        // Step 1: Init Variables
        self.clock = ClockViewModel(timeLimit: gameOptions.timeLimit, isClockTimer: gameOptions.timeLimit > 0)
        self.gameBoardViewModel = GameBoardViewModel(boardHeight: 6, boardWidth: 5, boardSpacing: 5.0)
        self.gameOptions = gameOptions
        self.gameOverModel = GameOverDataModel(gameOptions)
        self.targetWord = gameOptions.targetWord
        
        super.init()
        
        print(self.targetWord)
    }
    
    /// Save state initializer
    init(gameSaveState: GameSaveStateModel) {
        
        // Step 1: Initialize Variables
        self.clock = ClockViewModel(gameSaveState.clockState)
        self.gameBoardViewModel = GameBoardViewModel(boardHeight: 6, boardWidth: 5, boardSpacing: 5.0)
        self.gameOptions = gameSaveState.gameOptionsModel
        self.gameOverModel = gameSaveState.gameOverModel
        self.targetWord = gameSaveState.gameOptionsModel.targetWord
        
        super.init()
        
        print(self.targetWord)
        
        // Step 2: Populate Collections
        self.keyboardViewModel.loadSaveState(gameSaveState: gameSaveState)
        self.gameBoardViewModel.loadSaveState(gameSaveState: gameSaveState)
    }
    
    // MARK: Keyboard functions
    /// Function to communicate to the active game word to add a letter
    func keyboardAddLetter(_ letter : ValidCharacters) {
        guard self.isKeyboardUnlocked else { return }
        self.gameBoardViewModel.activeWord?.addLetter(letter)
        if self.clock.isClockActive != true {
            self.clock.startClock()
        }
    }
    
    /// Function to communicate to subclass if the correct word or wrong word was submitted
    func keyboardEnter() {
        guard self.isKeyboardUnlocked else { return }
        
        if let wordSubmitted = gameBoardViewModel.activeWord?.getWord() {
            if self.targetWord == wordSubmitted {
                self.correctWordSubmitted()
            } else if (WordDatabaseHelper.shared.doesFiveLetterWordExist(wordSubmitted)) {
                self.wrongWordSubmitted()
            } else {
                self.invalidWordSubmitted()
            }
        } else {
            self.invalidWordSubmitted()
        }
    }
    
    /// Function to communicate to the active game word to delete a letter
    func keyboardDelete() {
        guard self.isKeyboardUnlocked else { return }
        self.gameBoardViewModel.activeWord?.removeLetter()
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
        if let activeWord = gameBoardViewModel.activeWord, let gameWord = activeWord.getWord() {
            let comparisons = [LetterComparison](repeating: .correct, count: 5)
            self.isKeyboardUnlocked = false
            activeWord.setBackgrounds(comparisons)
            self.keyboardViewModel.keyboardSetBackgrounds(gameWord.comparisonRankingMap(comparisons))
            
            self.gameOverModel.numValidGuesses += 1
            self.gameOverModel.numCorrectWords += 1
        }
    }
    
    /// Handles what to do if an invalid word is submitted
    func invalidWordSubmitted() {
        if let activeWord = gameBoardViewModel.activeWord {
            activeWord.shakeAnimation()
        }
        self.gameOverModel.numInvalidGuesses += 1
    }
    
    /// Handles what to do if the wrong word is submitted
    func wrongWordSubmitted() {
        if let activeWord = gameBoardViewModel.activeWord, let gameWord = activeWord.getWord() {
            // Builds comparisons and updates backgrounds on board and keyboard
            let comparisons = gameWord.comparison(targetWord)
        
            activeWord.setBackgrounds(comparisons)
            self.keyboardViewModel.keyboardSetBackgrounds(gameWord.comparisonRankingMap(comparisons))
            
            // Updates hints
            for (index, (letter, comparison)) in zip(gameWord.letters, comparisons).enumerated() {
                if comparison == .correct {
                    self.gameBoardViewModel.targetWordHints[index] = letter
                }
            }
            
            // Moves board position and updates gameOverModel
            self.gameBoardViewModel.boardPosition += 1
            self.gameOverModel.numValidGuesses += 1
            self.gameOverModel.lastGuessedWord = gameWord
        }
    }
    
    // MARK: Navigation functions
    /// Function to go back to game mode selection
    func exitGame() {
        self.exitGameAction()
    }
    
    /// Function to end the game
    func gameOver(speed : Double = 1.5) {
        self.isKeyboardUnlocked = false
        self.showPauseMenu = false
        
        self.clock.stopClock()
        self.gameOverModel.timeElapsed = self.clock.timeElapsed
        
        super.fadeToBlankDelay(delay: speed)
    }
    
    /// Function to pause the game
    func pauseGame() {
        self.showPauseMenu = true
        self.clock.stopClock()
    }
    
    /// Function to play a new game again
    func playAgain() {
        super.fadeToBlank(fromRoot: false)
        self.keyboardViewModel.resetKeyboard()
        self.gameBoardViewModel.resetBoardHard()
        self.clock.resetClock()
        
        self.gameOptions.resetTargetWord()
        self.gameOverModel = GameOverDataModel(self.gameOptions)
        
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
            boardPosition: self.gameBoardViewModel.boardPosition,
            clockState: self.clock.getClockSaveState(),
            gameBoardWords: self.gameBoardViewModel.getSaveState(),
            gameOptionsModel: self.gameOptions,
            gameOverModel: self.gameOverModel,
            keyboardLetters: keyboardSaveState,
            targetWordHints: self.gameBoardViewModel.targetWordHints
        )
    }
}
