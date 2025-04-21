import SwiftUI

/// ViewModel to support a quad mode game.
///
/// This class implements the `MultiBoardGame` protocol to manage the logic and functionality
/// for games with four boards. It handles game states, keyboard interactions, and navigation
/// while also supporting gameplay with multiple target words.
class FourWordGameViewModel : MultiBoardGame {

    // MARK: - Properties
    
    var gameNavigationController : GameNavigationController {
        return AppNavigationController.shared.multiWordGameNavigationController
    }
    
    /// Boolean to indicate whether the header buttons are active
    var isHeaderButtonsUnlocked = true {
        didSet {
            gameHeaderViewModel.isHeaderButtonsUnlocked = isHeaderButtonsUnlocked
        }
    }
    
    /// ViewModel to manage the game clock.
    var clockViewModel: ClockViewModel
    
    /// Dictionary to track the state of each game board by its UUID.
    var gameBoardStates: [UUID: MultiWordBoardState] = [:]
    
    /// ViewModel for managing the collection of game boards.
    var gameBoardViewModel: MultiGameBoardViewModel
    
    /// Model containing the configuration options for the multi-board game.
    var gameOptionsModel: MultiWordGameOptionsModel
    
    /// Model to track game-over data, including the player's performance and results.
    var gameOverDataModel: GameOverDataModel
    
    lazy var gameHeaderViewModel: GameHeaderViewModel = {
        GameHeaderViewModel(clock: self.clockViewModel, controller: self.gameNavigationController)
    }()
    
    /// Boolean to determine whether the keyboard is unlocked for input.
    var isKeyboardUnlocked = true {
        didSet {
            keyboardViewModel.isKeyboardUnlocked = isKeyboardUnlocked
        }
    }
    
    /// ViewModel for handling keyboard interactions.
    lazy var keyboardViewModel: KeyboardViewModel = {
        KeyboardViewModel(keyboardAddLetter: self.keyboardAddLetter,
                          keyboardEnter: self.keyboardEnter,
                          keyboardDelete: self.keyboardDelete)
    }()
    
    /// Dictionary of target words for the game, keyed by UUID.
    var targetWords: OrderedDictionaryCodable<UUID, DatabaseWordModel>
    
    // MARK: - Initializer
    
    /// Initializes the `FourWordGameViewModel` with the given game options.
    /// - Parameter gameOptions: The configuration options for the multi-board game.
    init(gameOptions: MultiWordGameOptionsModel) {
        clockViewModel = ClockViewModel(timeLimit: gameOptions.timeLimit, isClockTimer: false)
        gameBoardStates = Dictionary(uniqueKeysWithValues: gameOptions.targetWords.allKeys.map { ($0, .unsolved) })
        gameBoardViewModel = MultiGameBoardViewModel(gameOptions)
        gameOptionsModel = gameOptions
        gameOverDataModel = gameOptions.getMultiBoardGameOverDataModelTemplate()
        targetWords = gameOptions.targetWords.copy()
        
        for targetWord in targetWords.allValues {
            print(targetWord.word)
        }
    }
    
    // MARK: - Keyboard Functions
    
    /// Adds a letter to the active word on the currently active game board.
    /// - Parameter letter: The letter to add.
    func keyboardAddLetter(_ letter: ValidCharacters) {
        guard isKeyboardUnlocked else { return }
        
        gameBoardViewModel.addLetterToActiveWord(letter)
        
        if !clockViewModel.isClockActive { clockViewModel.startClock() }
    }
    
    /// Processes the submission of a word from the keyboard.
    func keyboardEnter() {
        guard self.isKeyboardUnlocked else { return }
        
        guard let wordSubmitted = gameBoardViewModel.activeWord.getWord(),
              WordDatabaseClient.shared.doesFiveLetterWordExist(wordSubmitted) else {
            gameOverDataModel.numberOfInvalidGuesses += 1
            invalidWordSubmitted()
            return
        }
        
        isKeyboardUnlocked = false
        gameOverDataModel.numberOfValidGuesses += 1
        
        for (id, targetWord) in targetWords where gameBoardStates[id] == .unsolved {
            if targetWord == wordSubmitted {
                self.correctWordSubmitted(id, activeWord: wordSubmitted)
                self.gameBoardStates[id] = .solved
            } else {
                self.wrongWordSubmitted(id, activeWord: wordSubmitted) {
                    self.gameBoardStates[id] = .boardMaxedOut
                }
            }
        }

        switch MultiWordBoardState.getGameState(from: Array(gameBoardStates.values)) {
        case .win:
            gameOverDataModel.gameResult = .win
            gameOver()
        case .lose:
            gameOverDataModel.gameResult = .lose
            gameOver()
        default:
            isKeyboardUnlocked = true
        }
    }
    
    /// Deletes a letter from the active word on the currently active game board.
    func keyboardDelete() {
        guard isKeyboardUnlocked else { return }
        
        gameBoardViewModel.removeLetterFromActiveWord()
    }
    
    // MARK: - Word Submission Handlers
    
    /// Handles logic for submitting the correct word on a specific board.
    /// - Parameters:
    ///   - id: The UUID of the game board where the word was submitted.
    ///   - activeWord: The submitted word.
    func correctWordSubmitted(_ id: UUID, activeWord: GameWordModel) {
        let comparisons = LetterComparison.getCollection(size: activeWord.word.count, value: .correct)

        gameBoardViewModel.setActiveWordBackground(id, comparisons: comparisons)
        keyboardViewModel.keyboardSetBackgrounds(activeWord.comparisonRankingMap(comparisons))
        
        gameBoardViewModel.gameBoards[id]?.isBoardActive = false
        
        gameOverDataModel.addCorrectGuess(id: id, incrementValidGuesses: false)
    }
    
    /// Handles logic for submitting an invalid word.
    func invalidWordSubmitted() {
        gameBoardViewModel.shakeActiveRows()
    }
    
    /// Handles logic for submitting a wrong word on a specific board.
    /// - Parameters:
    ///   - id: The UUID of the game board where the word was submitted.
    ///   - activeWord: The submitted word.
    ///   - isGameOver: Closure to call when the board is maxed out.
    func wrongWordSubmitted(_ id: UUID, activeWord: GameWordModel, isGameOver: @escaping () -> Void) {
        guard let targetWord = targetWords[id] else {
            fatalError("Unable to get active word")
        }
        
        let comparisons = activeWord.comparison(targetWord)
        gameBoardViewModel.setActiveWordBackground(id, comparisons: comparisons)
        keyboardViewModel.keyboardSetBackgrounds(activeWord.comparisonRankingMap(comparisons))
        
        gameBoardViewModel.setTargetWordHints(id, comparisons: comparisons)
        gameOverDataModel.addIncorrectGuess(id, comparisons: comparisons, incrementValidGuesses: false)
        
        gameBoardViewModel.goToNextLine(id, atEndOfBoard: isGameOver)
    }
    
    // MARK: - Navigation Functions
    /// Ends the current game and updates the game-over state.
    /// - Parameter speed: The speed of the game-ending animation.
    func gameOver(speed: Double = 1.5) {
        isHeaderButtonsUnlocked = false
        
        clockViewModel.stopClock()
        gameOverDataModel.timeElapsed = clockViewModel.timeElapsed
        gameOverDataModel.targetWordsBackgrounds = gameBoardViewModel.getTargetWordsBackgrounds().toCodable()
        
        AppNavigationController.shared.goToFourWordGameOver()
    }
    
    /// Restarts the game by resetting all boards and related states.
    func playAgain() {
        keyboardViewModel.resetKeyboard()
        gameBoardViewModel.resetAllBoardsHard()
        clockViewModel.resetClock()
        
        gameOptionsModel.resetTargetWords()
        gameOverDataModel = gameOptionsModel.getMultiBoardGameOverDataModelTemplate()

        for (id, targetWord) in gameOptionsModel.targetWords {
            gameBoardStates[id] = .unsolved
            targetWords[id] = targetWord
            print(targetWord)
        }
        
        isKeyboardUnlocked = true
        isHeaderButtonsUnlocked = true
    }
}
