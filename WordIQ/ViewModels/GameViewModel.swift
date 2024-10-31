import SwiftUI

/// ViewModel to manage the playable game screen
class GameViewModel : ObservableObject {
//    var GoalWord : GameWordModel
    
    var Clock : ClockViewModel
    var KeyboardLetterButtons : [ValidCharacters : KeyboardLetterViewModel]
    var KeyboardEnterButton : KeyboardFunctionViewModel
    var KeyboardDeleteButton : KeyboardFunctionViewModel
    
    var GameBoardWords : [GameBoardWordViewModel]
    private var ActiveWord : GameBoardWordViewModel?

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
        self.GameBoardWords = [GameBoardWordViewModel]()
        
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
        self.ActiveWord?.addLetter(letter)
        if self.Clock.isClockActive != true {
            self.Clock.startClock()
        }
    }
    
    func keyboardEnter() {
        
    }
    
    /// Function to communicate to the active game word to delete a letter
    func keyboardDelete() {
        self.ActiveWord?.removeLetter()
    }

}
