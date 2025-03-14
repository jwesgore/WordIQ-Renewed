import SwiftUI

/// ViewModel to manage the playable game screen
class GameViewModel : BaseViewNavigation {
    
    // MARK: Concurrency
    let group = DispatchGroup()
    let queue = DispatchQueue(label: "GameViewModelQueue")
    
    // MARK: Fields
    let funcKeyWidthMultiplier = 0.13
    let keyHeightMultiplier = 0.06
    let letterKeyWidthMultiplier = 0.085
    
    var _targetWordHints : [ValidCharacters?]
    
    // MARK: Properties
    @Published var showPauseMenu = false
    
    var activeWord : GameBoardWordViewModel?
    var boardPosition : Int
    var clock : ClockViewModel
    var gameBoardWords = [GameBoardWordViewModel]()
    let gameOptions : GameModeOptionsModel
    var gameOverModel : GameOverDataModel
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
    var isKeyboardActive = true
    var keyboardDeleteButton : KeyboardFunctionViewModel
    var keyboardEnterButton : KeyboardFunctionViewModel
    var keyboardLetterButtons = [ValidCharacters : KeyboardLetterViewModel]()
    var targetWord : DatabaseWordModel
    var targetWordHints : [ValidCharacters?] {
        get {
            if (UserDefaultsHelper.shared.setting_showHints || boardPosition % 6 == 0) {
                return _targetWordHints
            } else {
                return [ValidCharacters?](repeating: nil, count: 5)
            }
        }
        set {
            _targetWordHints = newValue
        }
    }
    var exitGameAction: () -> Void = {}
    
    // MARK: Initializers
    /// Base initializer
    init(gameOptions: GameModeOptionsModel) {
        // Step 1: Init Variables
        self.boardPosition = 0
        self.clock = ClockViewModel(timeLimit: gameOptions.timeLimit, isClockTimer: gameOptions.timeLimit > 0)
        self.gameOptions = gameOptions
        self.gameOverModel = GameOverDataModel(gameOptions)
        
        self.keyboardEnterButton = KeyboardFunctionViewModel(keyboardFunction: .enter,
                                                             height: UIScreen.main.bounds.height * keyHeightMultiplier,
                                                             width: UIScreen.main.bounds.width * funcKeyWidthMultiplier)
        self.keyboardDeleteButton = KeyboardFunctionViewModel(keyboardFunction: .backspace,
                                                              height: UIScreen.main.bounds.height * keyHeightMultiplier,
                                                              width: UIScreen.main.bounds.width * funcKeyWidthMultiplier)
        
        self.targetWord = gameOptions.targetWord
        self._targetWordHints = [ValidCharacters?](repeating: nil, count: 5)
        
        super.init()
        
        print(self.targetWord)
        
        // Step 2: Populate Collections
        for letter in ValidCharacters.allCases {
            self.keyboardLetterButtons[letter] = KeyboardLetterViewModel(
                action: { self.keyboardAddLetter(letter) },
                letter: letter,
                height: UIScreen.main.bounds.height * keyHeightMultiplier,
                width: UIScreen.main.bounds.width * letterKeyWidthMultiplier)
        }
        
        for _ in 0..<6 {
            self.gameBoardWords.append(GameBoardWordViewModel())
        }
        
        // Step 3: Finish initialization
        self.keyboardEnterButton.action = { self.keyboardEnter() }
        self.keyboardDeleteButton.action = { self.keyboardDelete() }
        self.activeWord = self.gameBoardWords.first
    }
    
    /// Save state initializer
    init(gameSaveState: GameSaveStateModel) {
        // Step 1: Initialize Variables
        self.boardPosition = gameSaveState.boardPosition
        self.clock = ClockViewModel(gameSaveState.clockState)
        self.gameOptions = gameSaveState.gameOptionsModel
        self.gameOverModel = gameSaveState.gameOverModel
        
        self.keyboardEnterButton = KeyboardFunctionViewModel(keyboardFunction: .enter,
                                                             height: UIScreen.main.bounds.height * keyHeightMultiplier,
                                                             width: UIScreen.main.bounds.width * funcKeyWidthMultiplier)
        self.keyboardDeleteButton = KeyboardFunctionViewModel(keyboardFunction: .backspace,
                                                              height: UIScreen.main.bounds.height * keyHeightMultiplier,
                                                              width: UIScreen.main.bounds.width * funcKeyWidthMultiplier)
        
        self.targetWord = gameSaveState.gameOptionsModel.targetWord
        self._targetWordHints = gameSaveState.targetWordHints
        
        super.init()
        
        print(self.targetWord)
        
        // Step 2: Populate Collections
        for letter in ValidCharacters.allCases {
            self.keyboardLetterButtons[letter] = KeyboardLetterViewModel(
                action: { self.keyboardAddLetter(letter) },
                letter: letter,
                backgroundColor: gameSaveState.keyboardLetters[letter] ?? .notSet,
                height: UIScreen.main.bounds.height * keyHeightMultiplier,
                width: UIScreen.main.bounds.width * letterKeyWidthMultiplier)
        }
        
        for i in 0..<6 {
            let gameBoardWord = GameBoardWordViewModel()
            
            if i < gameSaveState.gameBoardWords.count {
                gameBoardWord.loadSaveState(gameSaveState.gameBoardWords[i])
            }
            
            self.gameBoardWords.append(gameBoardWord)
        }
        
        // Step 3: Finish initialization
        self.activeWord = self.gameBoardWords[gameSaveState.boardPosition]
        self.keyboardEnterButton.action = { self.keyboardEnter() }
        self.keyboardDeleteButton.action = { self.keyboardDelete() }
    }
    
    // MARK: Keyboard functions
    /// Function to communicate to the active game word to add a letter
    func keyboardAddLetter(_ letter : ValidCharacters) {
        guard self.isKeyboardActive else { return }
        self.activeWord?.addLetter(letter)
        if self.clock.isClockActive != true {
            self.clock.startClock()
        }
    }
    
    /// Function to communicate to subclass if the correct word or wrong word was submitted
    func keyboardEnter() {
        guard self.isKeyboardActive else { return }
        
        if let wordSubmitted = activeWord?.getWord() {
            if self.targetWord == wordSubmitted {
                self.correctWordSubmitted()
            } else if (WordDatabaseHelper.shared.doesWordExist(wordSubmitted)) {
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
        guard self.isKeyboardActive else { return }
        self.activeWord?.removeLetter()
    }
    
    /// Function to reset the keyboard to its default state
    func keyboardReset() {
        for keyboardButton in keyboardLetterButtons {
            keyboardButton.value.reset()
        }
    }
    
    /// Sets the background values on the keyboard keys
    func keyboardSetBackgrounds(_ comparisonMap: [ValidCharacters : LetterComparison]) {
        for comparison in comparisonMap {
            if let keyboardButton = keyboardLetterButtons[comparison.key] {
                keyboardButton.backgroundColor = max(keyboardButton.backgroundColor, comparison.value)
            }
        }
    }
    
    // MARK: Board functions
    /// Function to reset the board to its default state
    func boardReset(done: @escaping () -> Void = {}) {
        self.isKeyboardActive = false
        
        for word in self.gameBoardWords {
            word.reset()
        }
        
        self.boardPosition = 0
        self.activeWord = self.gameBoardWords.first
        self.targetWordHints = [ValidCharacters?](repeating: nil, count: 5)
        
        self.isKeyboardActive = true
    }
    
    /// Function to reset the board to its default state with an animation
    func boardResetWithAnimation(loadHints:Bool = false, animationLength: Double = 0.25, speed: Double = 4.0, delay: Double = 0.0, done: @escaping () -> Void = {}) {
        // disable the keyboard
        self.isKeyboardActive = false
        
        // clear the board
        for i in stride(from: 5, through: 0, by: -1) {
            DispatchQueue.main.asyncAfter(deadline: .now() + ((animationLength / 2.5 ) * Double(6 - i)) + delay, execute: {
                self.gameBoardWords[i].resetWithAnimation(animationLength: animationLength, speed: speed)
            })
        }
        
        self.boardPosition = 0
        self.activeWord = self.gameBoardWords.first
        
        // renable the keyboard and perform any actions passed in
        DispatchQueue.main.asyncAfter(deadline: .now() + ((animationLength / 2.5) * (5.0 + speed)) + delay, execute: {
            done()
            self.isKeyboardActive = true
        })
    }
    
    // MARK: Enter Key pressed functions
    /// Handles what to do if the correct word is submitted
    func correctWordSubmitted() {
        if let activeWord = activeWord, let gameWord = activeWord.getWord() {
            let comparisons = [LetterComparison](repeating: .correct, count: 5)
            self.isKeyboardActive = false
            activeWord.setBackgrounds(comparisons)
            self.keyboardSetBackgrounds(gameWord.comparisonRankingMap(comparisons))
            
            self.gameOverModel.numValidGuesses += 1
            self.gameOverModel.numCorrectWords += 1
        }
    }
    
    /// Handles what to do if an invalid word is submitted
    func invalidWordSubmitted() {
        if let activeWord = activeWord {
            activeWord.shakeAnimation()
        }
        self.gameOverModel.numInvalidGuesses += 1
    }
    
    /// Handles what to do if the wrong word is submitted
    func wrongWordSubmitted() {
        if let activeWord = activeWord, let gameWord = activeWord.getWord() {
            // Builds comparisons and updates backgrounds on board and keyboard
            let comparisons = gameWord.comparison(targetWord)
        
            activeWord.setBackgrounds(comparisons)
            self.keyboardSetBackgrounds(gameWord.comparisonRankingMap(comparisons))
            
            // Updates hints
            for (index, (letter, comparison)) in zip(gameWord.letters, comparisons).enumerated() {
                if comparison == .correct {
                    self.targetWordHints[index] = letter
                }
            }
            
            // Moves board position and updates gameOverModel
            self.boardPosition += 1
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
        self.isKeyboardActive = false
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
        self.keyboardReset()
        self.boardReset()
        self.clock.resetClock()
        
        self.gameOptions.resetTargetWord()
        self.gameOverModel = GameOverDataModel(self.gameOptions)
        
        self.targetWord = self.gameOverModel.targetWord
        
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
        
        // Get Game Board save state
        var gameBoardWordSaveStates = [GameBoardWordSaveStateModel]()
        
        for i in 0..<(self.boardPosition % 6) {
            gameBoardWordSaveStates.append(self.gameBoardWords[i].getSaveState())
        }
        
        // Get Keyboard save state
        var keyboardSaveState: [ValidCharacters : LetterComparison] = [:]
        
        for (key, value) in self.keyboardLetterButtons {
            keyboardSaveState[key] = value.backgroundColor
        }
        
        return GameSaveStateModel (
            boardPosition: self.boardPosition,
            clockState: self.clock.getClockSaveState(),
            gameBoardWords: gameBoardWordSaveStates,
            gameOptionsModel: self.gameOptions,
            gameOverModel: self.gameOverModel,
            keyboardLetters: keyboardSaveState,
            targetWordHints: self._targetWordHints
        )
    }
}
