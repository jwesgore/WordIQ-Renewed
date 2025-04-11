import SwiftUI

/// View Model to support a quad mode game
class FourWordGameViewModel : MultiBoardGame {
    
    // MARK: - Properties
    @Published var showPauseMenu = false
    
    var clockViewModel : ClockViewModel
    var gameBoardStates : [UUID: MultiWordBoardState] = [:]
    var gameBoardViewModel: MultiGameBoardViewModel
    var gameOptionsModel: MultiBoardGameOptionsModel
    var gameOverDataModel: GameOverDataModel
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
    var targetWords : OrderedDictionaryCodable<UUID, DatabaseWordModel>
    
    init(gameOptions: MultiBoardGameOptionsModel) {
        self.clockViewModel = ClockViewModel(timeLimit: gameOptions.timeLimit, isClockTimer: false)
        self.gameBoardStates = Dictionary(uniqueKeysWithValues: gameOptions.targetWords.allKeys.map { ($0, .unsolved) })
        self.gameBoardViewModel = MultiGameBoardViewModel(gameOptions)
        self.gameOptionsModel = gameOptions
        self.gameOverDataModel = gameOptions.getMultiBoardGameOverDataModelTemplate()
        self.targetWords = gameOptions.targetWords.copy()
        
        for targetWord in targetWords.allValues {
            print(targetWord.word)
        }
    }
    
    // MARK: - Keyboard functions
    /// Function to communicate to the active game word to add a letter
    func keyboardAddLetter(_ letter : ValidCharacters) {
        guard isKeyboardUnlocked else { return }
        
        gameBoardViewModel.addLetterToActiveWord(letter)
        
        if !clockViewModel.isClockActive { clockViewModel.startClock() }
    }
    
    /// Function to communicate to subclass if the correct word or wrong word was submitted
    func keyboardEnter() {
        guard self.isKeyboardUnlocked else { return }
        
        guard let wordSubmitted = gameBoardViewModel.activeWord.getWord(),
                WordDatabaseHelper.shared.doesFiveLetterWordExist(wordSubmitted) else {
            gameOverDataModel.numberOfInvalidGuesses += 1
            invalidWordSubmitted()
            return
        }
        
        // Lock the keyboard and determine if word is correct
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
    
    /// Function to communicate to the active game word to delete a letter
    func keyboardDelete() {
        guard isKeyboardUnlocked else { return }
        
        gameBoardViewModel.removeLetterFromActiveWord()
    }
    
    // MARK: - Enter Key pressed functions
    /// Handles what to do if the correct word is submitted
    func correctWordSubmitted(_ id: UUID, activeWord: GameWordModel) {
        let comparisons = LetterComparison.getCollection(size: activeWord.word.count, value: .correct)

        gameBoardViewModel.setActiveWordBackground(id, comparisons: comparisons)
        keyboardViewModel.keyboardSetBackgrounds(activeWord.comparisonRankingMap(comparisons))
        
        gameBoardViewModel.gameBoards[id]?.isBoardActive = false
        
        gameOverDataModel.addCorrectGuess(id: id, incrementValidGuesses: false)
    }
    
    /// Handles what to do if an invalid word is submitted
    func invalidWordSubmitted() {
        gameBoardViewModel.shakeActiveRows()
    }
    
    /// Handles what to do if the wrong word is submitted
    func wrongWordSubmitted(_ id: UUID, activeWord: GameWordModel, isGameOver: @escaping () -> Void) {
        guard let targetWord = targetWords[id] else {
            fatalError("Unable to get active word")
        }
        
        // Builds comparisons and updates backgrounds on board and keyboard
        let comparisons = activeWord.comparison(targetWord)
        
        gameBoardViewModel.setActiveWordBackground(id, comparisons: comparisons)
        keyboardViewModel.keyboardSetBackgrounds(activeWord.comparisonRankingMap(comparisons))
        
        // Updates hints and game over model
        gameBoardViewModel.setTargetWordHints(id, comparisons: comparisons)
        gameOverDataModel.addIncorrectGuess(id, comparisons: comparisons, incrementValidGuesses: false)
        
        gameBoardViewModel.goToNextLine(id, atEndOfBoard: isGameOver)
    }
    
    // MARK: - Navigation functions
    /// Function to go back to game mode selection
    func exitGame() {
        clockViewModel.stopClock()
        AppNavigationController.shared.exitFromFourWordGame()
    }
    
    /// Function to end the game
    func gameOver(speed : Double = 1.5) {
        showPauseMenu = false
        
        clockViewModel.stopClock()
        gameOverDataModel.timeElapsed = clockViewModel.timeElapsed
        gameOverDataModel.targetWordsBackgrounds = gameBoardViewModel.getTargetWordsBackgrounds().toCodable()
        
        AppNavigationController.shared.goToFourWordGameOver()
    }
    
    /// Function to pause the game
    func pauseGame() {
        showPauseMenu = true
        clockViewModel.stopClock()
    }
    
    /// Function to play a new game again
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
    }
    
    /// Function to resume the game when paused
    func resumeGame() {
        showPauseMenu = false
        clockViewModel.startClock()
    }
}
