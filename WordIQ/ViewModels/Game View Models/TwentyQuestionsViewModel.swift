import SwiftUI

/// ViewModel to manage the Twenty Questions game mode.
///
/// This ViewModel extends `SingleBoardGameViewModel` and customizes game logic
/// for the Twenty Questions mode. It tracks correct and incorrect submissions,
/// manages game-over conditions, and handles board and keyboard resets.
class TwentyQuestionsViewModel : SingleBoardGameViewModel<TwentyQuestionsGameBoardViewModel> {
    
    // MARK: - Initializer
    
    /// Initializes the ViewModel with game options for Twenty Questions mode.
    /// - Parameter gameOptions: The configuration options for the game, including
    ///   target word and gameplay settings.
    override init(gameOptions: SingleWordGameOptionsModel) {
        super.init(gameOptions: gameOptions)
    }
    
    // MARK: - Word Submission Handlers
    
    /// Handles the logic when a correct word is submitted.
    ///
    /// This method calls the base logic to process the correct word submission,
    /// activates the next word using `setNextWordCorrect`, and checks for win/loss
    /// conditions. If the game continues, it resets the board and keyboard for the
    /// next round.
    override func correctWordSubmitted() {
        super.correctWordSubmitted() // Call base class logic
        
        gameBoardViewModel.numberOfQuestionsLeft -= 1
        gameBoardViewModel.setNextWordCorrect() // Mark the next word as correct
        gameOptionsModel.resetTargetWord() // Add a new target word
        gameOverDataModel.addNewWord(gameOptionsModel.targetWord) 
        
        // Check if the game is won
        guard gameOverDataModel.targetWordsCorrect.count < 5 else {
            self.gameOverDataModel.gameResult = .win
            self.gameOver()
            return
        }
        
        // Check if the game is lost
        guard gameOverDataModel.numberOfValidGuesses < 20 else {
            self.gameOverDataModel.gameResult = .lose
            self.gameOver()
            return
        }
        
        // Game continues: Get game word and comparison
        guard let activeWord = gameBoardViewModel.activeWord,
        let gameWord = activeWord.getWord() else {
            fatalError("Unable to get active word")
        }
        
        let saveState = activeWord.getSaveState()
        let comparisons = gameWord.comparison(targetWord)
        
        // Reset board and keyboard for the next word
        self.gameBoardViewModel.resetBoardWithAnimation(delay: 0.5, hardReset: true) {
            self.keyboardViewModel.resetKeyboard()
            
            // Add last word as first guess for new word
            self.gameBoardViewModel.setActiveWordBackground(comparisons)
            self.keyboardViewModel.keyboardSetBackgrounds(gameWord.comparisonRankingMap(comparisons))
            
            self.gameBoardViewModel.setTargetWordHints(comparisons)
        }
    }
    
    /// Handles the logic when an incorrect word is submitted.
    ///
    /// This method calls the base logic to process the wrong word submission,
    /// checks for loss conditions, and transitions to the next line. If the board
    /// is full, it resets the board with hints.
    override func wrongWordSubmitted() {
        super.wrongWordSubmitted() // Call base class logic
        
        gameBoardViewModel.numberOfQuestionsLeft -= 1
        
        // Check if the game is lost
        guard gameOverDataModel.numberOfValidGuesses < 20 else {
            self.gameOverDataModel.gameResult = .lose
            self.gameOver()
            return
        }
        
        // Advance to the next line, reset the board if maxed out
        super.gameBoardViewModel.goToNextLine {
            super.gameBoardViewModel.resetBoardWithAnimation(delay: 0.5, loadHints: true)
        }
    }
    
    func submitLastWord() {
        
    }
}
