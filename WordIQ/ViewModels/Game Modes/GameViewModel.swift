import SwiftUI

/// ViewModel to manage the playable game screen
class GameViewModel : BaseViewNavigation {

    // MARK: Fields
    var _targetWordHints : [ValidCharacters?]
    
    // MARK: Properties
    var Clock : ClockViewModel
    var KeyboardLetterButtons : [ValidCharacters : KeyboardLetterViewModel]
    var KeyboardEnterButton : KeyboardFunctionViewModel
    var KeyboardDeleteButton : KeyboardFunctionViewModel
    var IsKeyboardActive : Bool
    
    var BoardPosition : Int
    var GameBoardWords : [GameBoardWordViewModel]
    var ActiveWord : GameBoardWordViewModel?
    var TargetWord : DatabaseWordModel
    var TargetWordHints : [ValidCharacters?] {
        get {
            if (UserDefaultsHelper.shared.setting_showHints || BoardPosition % 6 == 0) {
                return _targetWordHints
            } else {
                return [ValidCharacters?](repeating: nil, count: 5)
            }
        }
        set {
            _targetWordHints = newValue
        }
    }
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
    
    var exitGameAction: () -> Void = {}
    
    @Published var showPauseMenu: Bool
    
    let gameOptions : GameModeOptionsModel
    let letterKeyWidthMultiplier = 0.085
    let funcKeyWidthMultiplier = 0.13
    let keyHeightMultiplier = 0.06
    
    init(gameOptions: GameModeOptionsModel) {
        // Step 1: Init Variables
        self.gameOptions = gameOptions
        self.Clock = ClockViewModel(timeLimit: gameOptions.timeLimit, isClockTimer: gameOptions.timeLimit > 0)
        self.KeyboardLetterButtons = [ValidCharacters : KeyboardLetterViewModel]()
        self.KeyboardEnterButton = KeyboardFunctionViewModel(keyboardFunction: .enter,
                                                             height: UIScreen.main.bounds.height * keyHeightMultiplier,
                                                             width: UIScreen.main.bounds.width * funcKeyWidthMultiplier)
        self.KeyboardDeleteButton = KeyboardFunctionViewModel(keyboardFunction: .backspace,
                                                              height: UIScreen.main.bounds.height * keyHeightMultiplier,
                                                              width: UIScreen.main.bounds.width * funcKeyWidthMultiplier)
        self.IsKeyboardActive = true
        self.showPauseMenu = false
        
        self.BoardPosition = 0
        self.GameBoardWords = [GameBoardWordViewModel]()
        self.TargetWord = gameOptions.targetWord
        self._targetWordHints = [ValidCharacters?](repeating: nil, count: 5)
        self.gameOverModel = GameOverDataModel(gameOptions)
        print(self.TargetWord)

        super.init()
        
        // Step 3: Populate Collections
        for letter in ValidCharacters.allCases {
            self.KeyboardLetterButtons[letter] = KeyboardLetterViewModel(
                                                     action: { self.keyboardAddLetter(letter) },
                                                     letter: letter,
                                                     height: UIScreen.main.bounds.height * keyHeightMultiplier,
                                                     width: UIScreen.main.bounds.width * letterKeyWidthMultiplier)
        }
        
        for _ in 0..<6 {
            self.GameBoardWords.append(GameBoardWordViewModel())
        }
        
        // Step 4: Finish initialization
        self.KeyboardEnterButton.action = { self.keyboardEnter() }
        self.KeyboardDeleteButton.action = { self.keyboardDelete() }
        self.ActiveWord = self.GameBoardWords.first
    }
    
    // MARK: Keyboard functions
    /// Function to communicate to the active game word to add a letter
    func keyboardAddLetter(_ letter : ValidCharacters) {
        guard self.IsKeyboardActive else { return }
        self.ActiveWord?.addLetter(letter)
        if self.Clock.isClockActive != true {
            self.Clock.startClock()
        }
    }
    
    /// Function to communicate to subclass if the correct word or wrong word was submitted
    func keyboardEnter() {
        guard self.IsKeyboardActive else { return }
        
        if let wordSubmitted = ActiveWord?.getWord() {
            if self.TargetWord == wordSubmitted {
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
        guard self.IsKeyboardActive else { return }
        self.ActiveWord?.removeLetter()
    }
    
    /// Function to reset the keyboard to its default state
    func keyboardReset() {
        for keyboardButton in KeyboardLetterButtons {
            keyboardButton.value.reset()
        }
    }
    
    /// Sets the background values on the keyboard keys
    func keyboardSetBackgrounds(_ comparisonMap: [ValidCharacters : LetterComparison]) {
        for comparison in comparisonMap {
            if let keyboardButton = KeyboardLetterButtons[comparison.key] {
                keyboardButton.backgroundColor = max(keyboardButton.backgroundColor, comparison.value)
            }
        }
    }
    
    // MARK: Board functions
    /// Function to reset the board to its default state
    func boardReset(done: @escaping () -> Void = {}) {
        self.IsKeyboardActive = false
        
        for word in self.GameBoardWords {
            word.reset()
        }
        
        self.BoardPosition = 0
        self.ActiveWord = self.GameBoardWords.first
        self.TargetWordHints = [ValidCharacters?](repeating: nil, count: 5)
        
        self.IsKeyboardActive = true
    }
    
    /// Function to reset the board to its default state with an animation
    func boardResetWithAnimation(loadHints:Bool = false, animationLength: Double = 0.25, speed: Double = 4.0, delay: Double = 0.0, done: @escaping () -> Void = {}) {
        // disable the keyboard
        self.IsKeyboardActive = false
        
        // clear the board
        for i in stride(from: 5, through: 0, by: -1) {
            DispatchQueue.main.asyncAfter(deadline: .now() + ((animationLength / 2.5 ) * Double(6 - i)) + delay, execute: {
                self.GameBoardWords[i].resetWithAnimation(animationLength: animationLength, speed: speed)
            })
        }
        
        self.BoardPosition = 0
        self.ActiveWord = self.GameBoardWords.first
        
        // renable the keyboard and perform any actions passed in
        DispatchQueue.main.asyncAfter(deadline: .now() + ((animationLength / 2.5) * (5.0 + speed)) + delay, execute: {
            done()
            self.IsKeyboardActive = true
        })
    }
        
    // MARK: Enter Key pressed functions
    /// Handles what to do if the correct word is subbmitted
    func correctWordSubmitted() {
        if let activeWord = ActiveWord, let gameWord = activeWord.getWord() {
            let comparisons = [LetterComparison](repeating: .correct, count: 5)
            self.IsKeyboardActive = false
            activeWord.setBackgrounds(comparisons)
            self.keyboardSetBackgrounds(gameWord.comparisonRankingMap(comparisons))
            
            self.gameOverModel.numValidGuesses += 1
            self.gameOverModel.numCorrectWords += 1
        }
    }
    
    /// Handles what to do if an invalid word is subbmitted
    func invalidWordSubmitted() {
        if let activeWord = ActiveWord {
            activeWord.ShakeAnimation()
        }
        self.gameOverModel.numInvalidGuesses += 1
    }
    
    /// Handles what to do if the wrong word is subbmitted
    func wrongWordSubmitted() {
        if let activeWord = ActiveWord, let gameWord = activeWord.getWord() {
            // Builds comparisons and updates backgrounds on board and keyboard
            let comparisons = gameWord.comparison(TargetWord)
            activeWord.setBackgrounds(comparisons)
            self.keyboardSetBackgrounds(gameWord.comparisonRankingMap(comparisons))
            
            // Updates hints
            for (index, (letter, comparison)) in zip(gameWord.letters, comparisons).enumerated() {
                if comparison == .correct {
                    self.TargetWordHints[index] = letter
                }
            }
            
            // Moves board position and updates gameOverModel
            self.BoardPosition += 1
            self.gameOverModel.numValidGuesses += 1
            self.gameOverModel.lastGuessedWord = gameWord
        }
    }
    
    // MARK: Navigation functions
    /// Function to pause the game
    func pauseGame() {
        self.showPauseMenu = true
        self.Clock.stopClock()
    }
    
    /// Function to resume the game when paused
    func resumeGame() {
        self.showPauseMenu = false
        self.Clock.startClock()
    }
    
    /// Function to end the game
    func gameover(speed : Double = 1.5) {
        self.IsKeyboardActive = false
        self.showPauseMenu = false
        
        self.Clock.stopClock()
        self.gameOverModel.timeElapsed = self.Clock.timeElapsed
        
        super.fadeToBlankDelay(delay: speed)
    }
    
    /// Function to play a new game again
    func playAgain() {
        super.fadeToBlank(fromRoot: false)
        self.keyboardReset()
        self.boardReset()
        self.Clock.resetClock()
        
        self.gameOptions.resetTargetWord()
        self.gameOverModel = GameOverDataModel(self.gameOptions)

        self.TargetWord = self.gameOverModel.targetWord
        
        print(self.TargetWord)
    }
    
    /// Function to go back to game mode selection
    func exitGame() {
        self.exitGameAction()
    }
}
