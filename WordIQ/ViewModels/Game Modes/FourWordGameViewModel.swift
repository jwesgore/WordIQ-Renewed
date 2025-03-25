import SwiftUI

class FourWordGameViewModel : FourWordGameBaseProtocol {
    
    // MARK: Properties
    @Published var showPauseMenu = false
    
    var clock : ClockViewModel
    var gameBoardStates : [UUID: MultiWordBoardState] = [:]
    var gameBoardViewModel: MultiGameBoardViewModel
    var gameOptions: FourWordGameModeOptionsModel
    var gameOverDataModel: FourWordGameOverDataModel
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
    var targetWords : [UUID: DatabaseWordModel] = [:]
    var exitGameAction: () -> Void = {}
    
    init(gameOptions: FourWordGameModeOptionsModel) {

        self.clock = ClockViewModel(timeLimit: gameOptions.timeLimit, isClockTimer: false)
        self.gameBoardViewModel = MultiGameBoardViewModel(boardHeight: 9, boardWidth: 5, boardCount: 4, boardSpacing: 1.0, boardMargin: 10.0)
        self.gameOptions = gameOptions
        self.gameOverDataModel = FourWordGameOverDataModel(gameOptions)
        
        // Build target words
        for (id, targetWord) in zip(gameBoardViewModel.getBoardIds(), gameOptions.targetWords) {
            gameBoardStates[id] = .unsolved
            targetWords[id] = targetWord
        }
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
        
        guard let wordSubmitted = gameBoardViewModel.activeWord.getWord(),
        WordDatabaseHelper.shared.doesFiveLetterWordExist(wordSubmitted) else {
            invalidWordSubmitted()
            return
        }
        
        isKeyboardUnlocked = false
        
        gameOverDataModel.numValidGuesses += 1

        Task {
            await withTaskGroup(of: Void.self) { taskGroup in
                for (id, targetWord) in targetWords where gameBoardStates[id] == .unsolved {
                    taskGroup.addTask {
                        await MainActor.run {
                            if targetWord == wordSubmitted {
                                self.correctWordSubmitted(id, activeWord: wordSubmitted)
                                self.gameBoardStates[id] = .solved
                            } else {
                                self.wrongWordSubmitted(id, activeWord: wordSubmitted) {
                                    self.gameBoardStates[id] = .boardMaxedOut
                                }
                            }
                        }
                    }
                }
            }
            
            switch MultiWordBoardState.getGameState(from: Array(gameBoardStates.values)) {
            case .win:
                await MainActor.run {
                    gameOverDataModel.gameResult = .win
                    gameOver()
                }
            case .lose:
                await MainActor.run {
                    gameOverDataModel.gameResult = .lose
                    gameOver()
                }
            default:
                isKeyboardUnlocked = true
            }
        }
    }
    
    /// Function to communicate to the active game word to delete a letter
    func keyboardDelete() {
        guard isKeyboardUnlocked else { return }
        
        gameBoardViewModel.removeLetterFromActiveWord()
    }
    
    // MARK: Enter Key pressed functions
    /// Handles what to do if the correct word is submitted
    func correctWordSubmitted(_ id: UUID, activeWord: GameWordModel) {
        let comparisons = [LetterComparison](repeating: .correct, count: 5)

        gameBoardViewModel.setActiveWordBackground(id, comparisons: comparisons)
        keyboardViewModel.keyboardSetBackgrounds(activeWord.comparisonRankingMap(comparisons))
        
        gameBoardViewModel.gameBoards[id]?.isBoardActive = false
        
        gameOverDataModel.numCorrectWords += 1
    }
    
    /// Handles what to do if an invalid word is submitted
    func invalidWordSubmitted() {
        gameBoardViewModel.shakeActiveRows()
        gameOverDataModel.numInvalidGuesses += 1
    }
    
    /// Handles what to do if the wrong word is submitted
    func wrongWordSubmitted(_ id: UUID, activeWord: GameWordModel, isGameOver: @escaping () -> Void) {
        guard let targetWord = targetWords[id] else {
            fatalError("Unable to get active word")
        }
        
        let comparisons = activeWord.comparison(targetWord)
        
        gameBoardViewModel.setActiveWordBackground(id, comparisons: comparisons)
        keyboardViewModel.keyboardSetBackgrounds(activeWord.comparisonRankingMap(comparisons))
        
        gameBoardViewModel.setTargetWordHints(id, comparisons: comparisons)
        
        // Updates gameOverModel
        gameOverDataModel.lastGuessedWord = activeWord
        
        gameBoardViewModel.goToNextLine(id, atEndOfBoard: isGameOver)
    }
    
    // MARK: Navigation functions
    /// Function to go back to game mode selection
    func exitGame() {
        GameSelectionNavigationController.shared.exitFromGame()
    }
    
    /// Function to end the game
    func gameOver(speed : Double = 1.5) {
        showPauseMenu = false
        
        clock.stopClock()
        gameOverDataModel.timeElapsed = clock.timeElapsed
        
        MultiWordGameNavigationController.shared().goToGameOverView()
    }
    
    /// Function to pause the game
    func pauseGame() {
        showPauseMenu = true
        clock.stopClock()
    }
    
    /// Function to play a new game again
    func playAgain() {
        keyboardViewModel.resetKeyboard()
        gameBoardViewModel.resetAllBoardsHard()
        clock.resetClock()
        
        gameOptions.resetTargetWords()
        gameOverDataModel = gameOptions.getFourWordGameOverDataModelTemplate()
        
        for (id, targetWord) in zip(gameBoardViewModel.getBoardIds(), gameOptions.targetWords) {
            gameBoardStates[id] = .unsolved
            targetWords[id] = targetWord
        }
        isKeyboardUnlocked = true
        // print(self.targetWord)
    }
    
    /// Function to resume the game when paused
    func resumeGame() {
        showPauseMenu = false
        clock.startClock()
    }
}
