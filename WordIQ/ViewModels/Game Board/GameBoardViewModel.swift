import SwiftUI

/// ViewModel to manage the state and functionality of a game board.
///
/// This class handles the logic for a multi-row word-guessing game board, including
/// operations like adding/removing letters, saving/restoring board states, and animations.
class GameBoardViewModel: ObservableObject, Identifiable {
    
    // MARK: - Properties
    
    /// The height of the game board (number of rows).
    let boardHeight: Int
    
    /// The spacing between rows on the game board.
    let boardSpacing: CGFloat
    
    /// The width of the game board (number of letters per row).
    let boardWidth: Int
    
    /// The currently active word row.
    @Published var activeWord: GameBoardWordViewModel?
    
    /// A list of ViewModels for each row of the board.
    @Published var wordViewModels: [GameBoardWordViewModel] = []
    
    /// Unique identifier for the game board.
    var id: UUID
    
    /// Tracks the current position on the board (row index).
    var boardPosition: Int
    
    /// Indicates whether the board is active and accepting input.
    var isBoardActive: Bool = true
    
    /// List of letter hints for the target word, updated as the game progresses.
    var targetWordHints: [ValidCharacters?] = []
    
    /// List of background color states for each letter in the target word.
    var targetWordBackgrounds: [LetterComparison] = []
    
    // MARK: - Initializer
    
    /// Initializes a new `GameBoardViewModel` instance.
    ///
    /// - Parameters:
    ///   - boardHeight: The number of rows on the board.
    ///   - boardWidth: The number of letters in each row.
    ///   - boardSpacing: The spacing between rows.
    ///   - id: A unique identifier for the board. Defaults to a new UUID.
    required init(boardHeight: Int, boardWidth: Int, boardSpacing: CGFloat, id: UUID = UUID()) {
        self.id = id
        self.boardHeight = boardHeight
        self.boardWidth = boardWidth
        self.boardSpacing = boardSpacing
        self.boardPosition = 0
        
        // Initialize word view models for each row
        for _ in 0..<boardHeight {
            self.wordViewModels.append(GameBoardWordViewModel(boardWidth: boardWidth, boardSpacing: boardSpacing))
        }
        
        // Initialize hints and background states
        for _ in 0..<boardWidth {
            self.targetWordHints.append(nil)
            self.targetWordBackgrounds.append(.notSet)
        }
        
        // Set the first word as active
        self.activeWord = self.wordViewModels.first
    }
    
    // MARK: - Methods
    
    /// Adds a letter to the currently active word.
    /// - Parameter letter: The letter to add.
    func addLetterToActiveWord(_ letter: ValidCharacters) {
        guard isBoardActive else { return }
        activeWord?.addLetter(letter)
    }
    
    /// Removes the last letter from the currently active word.
    func removeLetterFromActiveWord() {
        guard isBoardActive else { return }
        activeWord?.removeLetter()
    }
    
    /// Moves the board to the next row, or runs a closure if the end of the board is reached.
    /// - Parameter atEndOfBoard: Closure to execute when the board reaches its last row.
    func goToNextLine(atEndOfBoard: @escaping () -> Void) {
        guard isBoardActive else { return }
        
        boardPosition += 1
        
        guard boardPosition < boardHeight else {
            atEndOfBoard()
            return
        }
        
        activeWord = wordViewModels[boardPosition % boardHeight]
        activeWord?.loadHints(getTargetWordHints())
    }
    
    /// Resets the board to its default state.
    func resetBoardHard() {
        for word in wordViewModels {
            word.reset()
        }
        
        boardPosition = 0
        isBoardActive = true
        activeWord = wordViewModels.first
        
        for i in 0..<boardWidth {
            targetWordHints[i] = nil
            targetWordBackgrounds[i] = .notSet
        }
    }
    
    /// Resets the board with animation and an optional completion closure.
    /// - Parameters:
    ///   - animationLength: The length of the animation.
    ///   - speed: The speed of the animation.
    ///   - delay: The delay before starting the animation.
    ///   - loadHints: Whether to load hints after resetting.
    ///   - hardReset: Whether to fully reset hints and backgrounds.
    ///   - complete: Closure to execute after the reset is complete.
    func resetBoardWithAnimation(animationLength: Double = 0.25,
                                 speed: Double = 4.0,
                                 delay: Double = 0.0,
                                 loadHints: Bool = false,
                                 hardReset: Bool = false,
                                 complete: @escaping () -> Void = {}) {
        let totalDelay = ((animationLength / 2.5) * Double(boardWidth)) + delay
        
        for i in stride(from: boardHeight - 1, through: 0, by: -1) {
            DispatchQueue.main.asyncAfter(deadline: .now() + ((animationLength / 2.5) * Double(boardWidth - i)) + delay) {
                self.wordViewModels[i].resetWithAnimation(animationLength: animationLength, speed: speed)
            }
        }
        
        boardPosition = 0
        isBoardActive = true
        activeWord = wordViewModels.first
        
        if hardReset {
            for i in 0..<boardWidth {
                targetWordHints[i] = nil
                targetWordBackgrounds[i] = .notSet
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay + 0.2) {
            if loadHints {
                self.activeWord?.loadHints(self.getTargetWordHints())
            }
            complete()
        }
    }
    
    /// Resets the board with animation using Swift's async-await syntax.
     /// - Parameters:
     ///   - animationLength: The length of the animation.
     ///   - speed: The speed of the animation.
     ///   - delay: The delay before starting the animation.
     ///   - loadHints: Whether to load hints after resetting.
     ///   - hardReset: Whether to fully reset hints and backgrounds.
     ///   - complete: Closure to execute after the reset is complete.
     func resetBoardWithAnimationAsync(animationLength: Double = 0.25,
                                       speed: Double = 4.0,
                                       delay: Double = 0.0,
                                       loadHints: Bool = false,
                                       hardReset: Bool = false,
                                       complete: @escaping () -> Void = {}) async {
         await withCheckedContinuation { continuation in
             self.resetBoardWithAnimation(animationLength: animationLength,
                                          speed: speed,
                                          delay: delay,
                                          loadHints: loadHints,
                                          hardReset: hardReset) {
                 continuation.resume()
             }
         }
     }
    
    /// Sets the backgrounds of the active word based on letter comparisons.
    /// - Parameter comparisons: An array of comparison results for each letter.
    func setActiveWordBackground(_ comparisons: [LetterComparison]) {
        guard isBoardActive else { return }
        activeWord?.setBackgrounds(comparisons)
        
        for (index, incomingComparison) in comparisons.enumerated() {
            targetWordBackgrounds[index] = max(incomingComparison, targetWordBackgrounds[index])
        }
    }
    
    /// Updates the board's target word hints based on letter comparisons.
    /// - Parameter comparisons: An array of comparison results for each letter.
    func setTargetWordHints(_ comparisons: [LetterComparison]) {
        if let activeWord, let gameWord = activeWord.getWord() {
            for (index, (letter, comparison)) in zip(gameWord.letters, comparisons).enumerated() {
                if comparison == .correct {
                    targetWordHints[index] = letter
                }
            }
        }
    }
    
    /// Loads a saved game state for the board.
    /// - Parameter gameSaveState: The saved state to restore.
    func loadSaveState(gameSaveState: GameSaveStateModel) {
        let boardSaveState = gameSaveState.gameBoard
        
        id = boardSaveState.id
        boardPosition = boardSaveState.gameBoardPosition
        targetWordHints = boardSaveState.targetWordHints
        
        wordViewModels = []
        
        for i in 0..<boardHeight {
            let gameBoardWord = GameBoardWordViewModel(boardWidth: boardWidth, boardSpacing: boardSpacing)
            if i < boardSaveState.gameBoardWords.count {
                gameBoardWord.loadSaveState(boardSaveState.gameBoardWords[i])
            }
            wordViewModels.append(gameBoardWord)
        }
        
        activeWord = wordViewModels[boardSaveState.gameBoardPosition % boardHeight]
        activeWord?.loadHints(getTargetWordHints())
    }
    
    /// Retrieves the save state of the board.
    /// - Returns: A model representing the board's save state.
    func getSaveState() -> GameBoardSaveStateModel {
        var gameBoardWordSaveStates = [GameBoardWordSaveStateModel]()
        
        for i in 0..<(boardPosition % boardHeight) {
            gameBoardWordSaveStates.append(wordViewModels[i].getSaveState())
        }
        
        return GameBoardSaveStateModel(id: id,
                                       gameBoardPosition: boardPosition,
                                       gameBoardWords: gameBoardWordSaveStates,
                                       targetWordHints: targetWordHints)
    }
    
    /// Retrieves the current target word hints.
    /// - Returns: An array of optional valid characters for each letter position.
    func getTargetWordHints() -> [ValidCharacters?] {
        guard isBoardActive && (UserDefaultsHelper.shared.setting_showHints || boardPosition % boardHeight == 0) else {
            return [ValidCharacters?](repeating: nil, count: boardWidth)
        }
        return targetWordHints
    }
}
