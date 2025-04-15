import SwiftUI

/// View Model for the Twenty Questions mode game board.
///
/// This ViewModel manages the state and logic for the Twenty Questions game mode, where
/// players attempt to guess words within a limited number of questions. It tracks the
/// activation states of circles and provides methods for resetting the board and progressing
/// through the game.
class TwentyQuestionsGameBoardViewModel : GameBoardViewModel {

    // MARK: - Properties
    
    /// A list that represents the activation states of circles on the board.
    ///
    /// Each index corresponds to a circle, and the value (`true` or `false`) indicates
    /// whether the circle is active.
    @Published var circleStates: [Bool] = [false, false, false, false, false]
    
    /// The number of questions left for the player in the current game.
    @Published var numberOfQuestionsLeft: Int = 20
    
    /// Tracks the index of the next circle to activate for correct answers.
    private var correctAnswerIndex: Int = 0
    
    // MARK: - Methods
    
    /// Resets the game board to its default state.
    ///
    /// This method clears all activation states for the circles, resets the number of
    /// questions left to 20, and sets the `correctAnswerIndex` back to 0.
    /// Additionally, it calls the base class method `resetBoardHard`.
    override func resetBoardHard() {
        circleStates = Array(repeating: false, count: circleStates.count)
        numberOfQuestionsLeft = 20
        correctAnswerIndex = 0
        
        super.resetBoardHard()
    }
    
    /// Activates the next circle to indicate a correct answer and progresses the game state.
    ///
    /// This method animates the activation of the next circle in the list and increments
    /// the `correctAnswerIndex` to move to the next circle. It ensures smooth transitions
    /// for correct guesses.
    func setNextWordCorrect() {
        withAnimation {
            circleStates[correctAnswerIndex] = true
        } completion: {
            self.correctAnswerIndex += 1
        }
    }
    
}
