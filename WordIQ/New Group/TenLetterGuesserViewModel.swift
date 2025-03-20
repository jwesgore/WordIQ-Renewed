import SwiftUI

class TenLetterGuesserViewModel : ObservableObject {
    
    // MARK: Fields
    let funcKeyWidthMultiplier = 0.13
    let keyHeightMultiplier = 0.06
    let letterKeyWidthMultiplier = 0.085
    
    // var _targetWordHints : [ValidCharacters?]
    
    // MARK: Properties
    @Published var showPauseMenu = false
    
    var activeWord : TenLetterGuesserWordViewModel?
    var boardPosition : Int
    var clock : ClockViewModel
    var gameBoardWords = [TenLetterGuesserWordViewModel]()
    // let gameOptions : GameModeOptionsModel
    // var gameOverModel : GameOverDataModel
//    var gameOverViewModel: GameOverViewModel {
//        let gameOverVM = GameOverViewModel(gameOverModel)
//        gameOverVM.PlayAgainButton.action = self.playAgain
//        gameOverVM.BackButton.action = self.exitGame
//        return gameOverVM
//    }
//    var gamePauseViewModel: GamePauseViewModel {
//        let gamePauseVM = GamePauseViewModel()
//        gamePauseVM.ResumeGameButton.action = self.resumeGame
//        gamePauseVM.EndGameButton.action = self.exitGame
//        return gamePauseVM
//    }
    var isKeyboardActive = true
    var keyboardDeleteButton : KeyboardFunctionViewModel
    var keyboardEnterButton : KeyboardFunctionViewModel
    var keyboardLetterButtons = [ValidCharacters : KeyboardLetterViewModel]()
    // var targetWord : DatabaseWordModel
//    var targetWordHints : [ValidCharacters?] {
//        get {
//            if (UserDefaultsHelper.shared.setting_showHints || boardPosition % 6 == 0) {
//                return _targetWordHints
//            } else {
//                return [ValidCharacters?](repeating: nil, count: 10)
//            }
//        }
//        set {
//            _targetWordHints = newValue
//        }
//    }
    // var exitGameAction: () -> Void = {}
    
    init() {
        self.boardPosition = 0
        self.clock = ClockViewModel(timeLimit: 0, isClockTimer: false)
        
        self.keyboardEnterButton = KeyboardFunctionViewModel(keyboardFunction: .enter,
                                                             height: UIScreen.main.bounds.height * keyHeightMultiplier,
                                                             width: UIScreen.main.bounds.width * funcKeyWidthMultiplier)
        self.keyboardDeleteButton = KeyboardFunctionViewModel(keyboardFunction: .backspace,
                                                              height: UIScreen.main.bounds.height * keyHeightMultiplier,
                                                              width: UIScreen.main.bounds.width * funcKeyWidthMultiplier)
        
        // Collections
        for _ in 0..<10 {
            self.gameBoardWords.append(TenLetterGuesserWordViewModel())
        }
        
        for letter in ValidCharacters.allCases {
            self.keyboardLetterButtons[letter] = KeyboardLetterViewModel(
                action: { self.keyboardAddLetter(letter) },
                letter: letter,
                backgroundColor: .notSet,
                height: UIScreen.main.bounds.height * keyHeightMultiplier,
                width: UIScreen.main.bounds.width * letterKeyWidthMultiplier)
        }
        
        
        self.keyboardEnterButton.action = { self.keyboardEnter() }
        self.keyboardDeleteButton.action = { self.keyboardDelete() }
        self.activeWord = self.gameBoardWords.first
    }
    
    func keyboardAddLetter(_ letter : ValidCharacters) {
        guard self.isKeyboardActive else { return }
        self.activeWord?.addLetter(letter)
        if self.clock.isClockActive != true {
            self.clock.startClock()
        }
    }
    
    /// Function to communicate to the active game word to delete a letter
    func keyboardDelete() {
        guard self.isKeyboardActive else { return }
        self.activeWord?.removeLetter()
    }
    
    /// Function to communicate to subclass if the correct word or wrong word was submitted
    func keyboardEnter() {
        guard self.isKeyboardActive else { return }
        
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
    
}
