import SwiftUI

/// ViewModel to manage the playable game screen
class GameViewModel : ObservableObject, GameViewModelSubClass {

    var Clock : ClockViewModel
    var KeyboardLetterButtons : [ValidCharacters : KeyboardLetterViewModel]
    var KeyboardEnterButton : KeyboardFunctionViewModel
    var KeyboardDeleteButton : KeyboardFunctionViewModel
    private var IsKeyboardActive : Bool
    
    var GameBoardWords : [GameBoardWordViewModel]
    private var ActiveWord : GameBoardWordViewModel?
    private var TargetWord : GameWordModel

    let gameMode : GameMode
    let letterKeyWidthMultiplier = 0.085
    let funcKeyWidthMultiplier = 0.13
    let keyHeightMultiplier = 0.06
    
    init(gameOptions: GameModeOptionsModel) {
        // Step 1: Init Variables
        self.gameMode = gameOptions.gameMode
        self.Clock = ClockViewModel(timeLimit: gameOptions.timeLimit, isClockTimer: gameOptions.timeLimit > 0)
        self.KeyboardLetterButtons = [ValidCharacters : KeyboardLetterViewModel]()
        self.KeyboardEnterButton = KeyboardFunctionViewModel(keyboardFunction: .enter,
                                                             height: UIScreen.main.bounds.height * keyHeightMultiplier,
                                                             width: UIScreen.main.bounds.width * funcKeyWidthMultiplier)
        self.KeyboardDeleteButton = KeyboardFunctionViewModel(keyboardFunction: .backspace,
                                                              height: UIScreen.main.bounds.height * keyHeightMultiplier,
                                                              width: UIScreen.main.bounds.width * funcKeyWidthMultiplier)
        self.IsKeyboardActive = true
        
        self.GameBoardWords = [GameBoardWordViewModel]()
        self.TargetWord = DatabaseHelper.shared.fetchRandomWord(withDifficulty: gameOptions.gameDifficulty)
        print(self.TargetWord)
        
        // Step 2: Populate Collections
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
        
        // Step 3: Finish initialization
        self.KeyboardEnterButton.action = { self.keyboardEnter() }
        self.KeyboardDeleteButton.action = { self.keyboardDelete() }
        self.ActiveWord = self.GameBoardWords.first
    }
    
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
            } else if (DatabaseHelper.shared.doesWordExist(wordSubmitted)) {
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
    
    // MARK: Section for subclass required functions
    func correctWordSubmitted() { fatalError("This method must be overridden") }
    func wrongWordSubmitted() { fatalError("This method must be overridden") }
    func invalidWordSubmitted() { fatalError("This method must be overridden") }
}

protocol GameViewModelSubClass {
    func correctWordSubmitted()
    func wrongWordSubmitted()
    func invalidWordSubmitted()
}
