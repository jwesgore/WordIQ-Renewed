import SwiftUI

class FourWordGameViewModel : FourWordGameBaseProtocol {
    
    let appNavigationController : AppNavigationController
    
    // MARK: Properties
    @Published var showPauseMenu = false
    
    var clock : ClockViewModel
    var gameBoardViewModel: MultiGameBoardViewModel
    var gameOptions: FourWordGameModeOptionsModel
    var gameOverModel: FourWordGameOverDataModel
    var gameOverViewModel: FourWordGameOverViewModel {
        let gameOverVM = FourWordGameOverViewModel(gameOverModel)
//        gameOverVM.PlayAgainButton.action = self.playAgain
//        gameOverVM.BackButton.action = self.exitGame
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
    var targetWords : [UUID: DatabaseWordModel] = [:]
    var exitGameAction: () -> Void = {}
    
    init(gameOptions: FourWordGameModeOptionsModel) {
        self.appNavigationController = AppNavigationController.shared
        self.clock = ClockViewModel(timeLimit: gameOptions.timeLimit, isClockTimer: false)
        self.gameBoardViewModel = MultiGameBoardViewModel(boardHeight: 9, boardWidth: 5, boardCount: 4, boardSpacing: 1.0, boardMargin: 10.0)
        self.gameOptions = gameOptions
        self.gameOverModel = FourWordGameOverDataModel(gameOptions)
        
        // Build target words
        for (id, targetWord) in zip(gameBoardViewModel.getBoardIds(), gameOptions.targetWords) {
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
        
        gameOverModel.numValidGuesses += 1

        Task {
            await withTaskGroup(of: Void.self) { taskGroup in
                for (id, targetWord) in targetWords {
                    taskGroup.addTask {
                        await MainActor.run {
                            targetWord == wordSubmitted ? self.correctWordSubmitted(id, activeWord: wordSubmitted) : self.wrongWordSubmitted(id, activeWord: wordSubmitted)
                        }
                    }
                }
            }
        }
      
        isKeyboardUnlocked = true
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
        
        gameOverModel.numCorrectWords += 1
    }
    
    /// Handles what to do if an invalid word is submitted
    func invalidWordSubmitted() {
        gameBoardViewModel.shakeActiveRows()
        gameOverModel.numInvalidGuesses += 1
    }
    
    /// Handles what to do if the wrong word is submitted
    func wrongWordSubmitted(_ id: UUID, activeWord: GameWordModel) {
        guard let targetWord = targetWords[id] else {
            fatalError("Unable to get active word")
        }
        
        let comparisons = activeWord.comparison(targetWord)
        
        gameBoardViewModel.setActiveWordBackground(id, comparisons: comparisons)
        keyboardViewModel.keyboardSetBackgrounds(activeWord.comparisonRankingMap(comparisons))
        
        gameBoardViewModel.setTargetWordHints(id, comparisons: comparisons)
        
        // Updates gameOverModel
        gameOverModel.lastGuessedWord = activeWord
        
        gameBoardViewModel.goToNextLine(id) {
            
        }
    }
    
    // MARK: Navigation functions
    /// Function to go back to game mode selection
    func exitGame() {
        self.exitGameAction()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // self.gameNavigationController.dispose()
        }
    }
    
    /// Function to end the game
    func gameOver(speed : Double = 1.5) {
        self.isKeyboardUnlocked = false
        self.showPauseMenu = false
        
        self.clock.stopClock()
        self.gameOverModel.timeElapsed = self.clock.timeElapsed
        
        // self.gameNavigationController.goToViewWithAnimation(.gameOver)
    }
    
    /// Function to pause the game
    func pauseGame() {
        self.showPauseMenu = true
        self.clock.stopClock()
    }
    
    /// Function to play a new game again
    func playAgain() {
        // self.gameNavigationController.goToViewWithAnimation(.game)
        self.keyboardViewModel.resetKeyboard()
        self.gameBoardViewModel.resetAllBoardsHard()
        self.clock.resetClock()
        
        self.gameOptions.resetTargetWords()
        // self.gameOverModel = GameOverDataModel(self.gameOptions)
        
        // self.targetWord = self.gameOverModel.targetWord
        self.isKeyboardUnlocked = true
        // print(self.targetWord)
    }
    
    /// Function to resume the game when paused
    func resumeGame() {
        self.showPauseMenu = false
        self.clock.startClock()
    }
}
