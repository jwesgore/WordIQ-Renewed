import SwiftUI

/// ViewModel to manage multiple game boards.
///
/// This class provides functionality to manage multiple game boards, enabling operations
/// like resetting, animations, saving/restoring states, and updating the game logic
/// across all boards.
class MultiGameBoardViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// Number of game boards to manage.
    let boardCount: Int
    
    /// Height of each game board (number of rows).
    let boardHeight: Int
    
    /// Spacing between rows on each game board.
    let boardSpacing: CGFloat
    
    /// Margin around each game board.
    let boardMargin: CGFloat
    
    /// Width of each game board (number of letters per row).
    let boardWidth: Int
    
    /// The currently active word across all boards.
    var activeWord: GameBoardWordViewModel
    
    /// Dictionary of game boards, keyed by their unique ID.
    var gameBoards = OrderedDictionary<UUID, GameBoardViewModel>()
    
    // MARK: - Initializers
    
    /// Initializes the ViewModel with specified parameters.
    ///
    /// - Parameters:
    ///   - boardHeight: The height of each game board.
    ///   - boardWidth: The width of each game board.
    ///   - boardCount: The number of game boards.
    ///   - boardSpacing: The spacing between rows on the boards.
    ///   - boardMargin: The margin around each board.
    ///   - targetWords: An optional dictionary mapping board IDs to their target words.
    init(boardHeight: Int,
         boardWidth: Int,
         boardCount: Int,
         boardSpacing: CGFloat,
         boardMargin: CGFloat,
         targetWords: OrderedDictionaryCodable<UUID, DatabaseWordModel>? = nil) {
        self.boardCount = boardCount
        self.boardHeight = boardHeight
        self.boardWidth = boardWidth
        self.boardSpacing = boardSpacing
        self.boardMargin = boardMargin
        
        self.activeWord = GameBoardWordViewModel(boardWidth: boardWidth, boardSpacing: boardSpacing)
        
        if let targetWords = targetWords {
            for (id, _) in targetWords {
                gameBoards[id] = GameBoardViewModel(boardHeight: boardHeight,
                                                     boardWidth: boardWidth,
                                                     boardSpacing: boardSpacing,
                                                     id: id)
            }
        } else {
            for _ in 0..<boardCount {
                let gameBoard = GameBoardViewModel(boardHeight: boardHeight,
                                                   boardWidth: boardWidth,
                                                   boardSpacing: boardSpacing)
                gameBoards[gameBoard.id] = gameBoard
            }
        }
    }
    
    /// Convenience initializer using game options.
    ///
    /// - Parameter gameOptions: Configuration options for the multi-board game.
    convenience init(_ gameOptions: MultiWordGameOptionsModel) {
        self.init(boardHeight: 9, boardWidth: 5, boardCount: 4, boardSpacing: 1.0, boardMargin: 10.0, targetWords: gameOptions.targetWords)
    }
    
    // MARK: - Board Management Methods
    
    /// Adds a letter to the active word on all boards.
    ///
    /// - Parameter letter: The letter to add.
    func addLetterToActiveWord(_ letter: ValidCharacters) {
        activeWord.addLetter(letter)
        for gameBoard in gameBoards.allValues {
            gameBoard.addLetterToActiveWord(letter)
        }
    }
    
    /// Returns all board IDs.
    ///
    /// - Returns: An array of UUIDs for the boards.
    func getBoardIds() -> [UUID] {
        return gameBoards.allKeys
    }
    
    /// Retrieves target word hints for all boards.
    ///
    /// - Returns: A dictionary mapping each board's ID to its target word hints.
    func getAllTargetWordHints() -> [UUID: [ValidCharacters?]] {
        return gameBoards.allValues.reduce(into: [:]) { result, gameBoard in
            result[gameBoard.id] = gameBoard.getTargetWordHints()
        }
    }
    
    /// Retrieves the save states of all boards.
    ///
    /// - Returns: A dictionary mapping each board's ID to its save state.
    func getSaveStates() -> [UUID: GameBoardSaveStateModel] {
        return gameBoards.allValues.reduce(into: [:]) { result, gameBoard in
            result[gameBoard.id] = gameBoard.getSaveState()
        }
    }
    
    /// Retrieves target word hints for a single board.
    ///
    /// - Parameter id: The ID of the board.
    /// - Returns: An array of optional hints for the board’s target word.
    func getTargetWordHints(_ id: UUID) -> [ValidCharacters?] {
        guard let gameBoard = gameBoards[id] else {
            fatalError("Invalid board ID: \(id)")
        }
        return gameBoard.getTargetWordHints()
    }
    
    /// Retrieves all target word backgrounds for all boards.
    ///
    /// - Returns: An ordered dictionary mapping board IDs to their target word background comparisons.
    func getTargetWordsBackgrounds() -> OrderedDictionary<UUID, [LetterComparison]> {
        return gameBoards.mapValues { $0.targetWordBackgrounds }
    }
    
    // MARK: - Board Progression Methods
    
    /// Progresses all boards to the next line.
    ///
    /// - Parameter atEndOfBoard: Closure to execute when a board reaches its end.
    func goToNextLine(atEndOfBoard: @escaping () -> Void) {
        var atEndOfBoardCalled = false
        
        // Reset the universal active word view model.
        activeWord.reset()
        
        for gameBoard in gameBoards.allValues {
            gameBoard.goToNextLine() {
                atEndOfBoardCalled = true
            }
        }
        
        if atEndOfBoardCalled { atEndOfBoard() }
    }
    
    /// Progresses a single board to the next line.
    ///
    /// - Parameters:
    ///   - id: The board's ID.
    ///   - atEndOfBoard: Closure to execute if the board reaches its end.
    func goToNextLine(_ id: UUID, atEndOfBoard: @escaping () -> Void) {
        guard let gameBoard = gameBoards[id] else {
            fatalError("Invalid board ID: \(id)")
        }
        
        activeWord.reset()
        gameBoard.goToNextLine() {
            atEndOfBoard()
        }
    }
    
    /// Removes the last letter from the active word on all boards.
    func removeLetterFromActiveWord() {
        activeWord.removeLetter()
        for gameBoard in gameBoards.allValues {
            gameBoard.removeLetterFromActiveWord()
        }
    }
    
    /// Resets all boards to their default state.
    func resetAllBoardsHard() {
        activeWord.reset()
        for gameBoard in gameBoards.allValues {
            gameBoard.resetBoardHard()
        }
    }
    
    /// Resets all boards with animation.
    ///
    /// - Parameters:
    ///   - animationLength: The duration of the animation.
    ///   - speed: The speed parameter for the animation.
    ///   - delay: The delay before the animation starts.
    ///   - loadHints: Whether to load hints after resetting.
    ///   - hardReset: Whether to perform a full reset.
    ///   - complete: Closure to execute after all boards have been reset.
    func resetAllBoardsWithAnimation(animationLength: Double = 0.25,
                                     speed: Double = 4.0,
                                     delay: Double = 0.0,
                                     loadHints: Bool = false,
                                     hardReset: Bool = false,
                                     complete: @escaping () -> Void = {}) {
        Task {
            await withTaskGroup(of: Void.self) { taskGroup in
                for gameBoard in gameBoards.allValues {
                    taskGroup.addTask {
                        await gameBoard.resetBoardWithAnimationAsync(animationLength: animationLength,
                                                                     speed: speed,
                                                                     delay: delay,
                                                                     loadHints: loadHints,
                                                                     hardReset: hardReset)
                    }
                }
            }
            complete()
        }
    }
    
    /// Resets a single board to its default state.
    ///
    /// - Parameter id: The ID of the board to reset.
    func resetBoardHard(_ id: UUID) {
        guard let gameBoard = gameBoards[id] else {
            fatalError("Invalid board ID: \(id)")
        }
        gameBoard.resetBoardHard()
    }
    
    /// Resets a single board with animation.
    ///
    /// - Parameters:
    ///   - id: The ID of the board to reset.
    ///   - animationLength: The duration of the animation.
    ///   - speed: The speed parameter for the animation.
    ///   - delay: The delay before starting the animation.
    ///   - loadHints: Whether to load hints after resetting.
    ///   - hardReset: Whether to perform a full reset.
    ///   - complete: Closure to execute after the reset is complete.
    func resetBoardWithAnimation(_ id: UUID,
                                 animationLength: Double = 0.25,
                                 speed: Double = 4.0,
                                 delay: Double = 0.0,
                                 loadHints: Bool = false,
                                 hardReset: Bool = false,
                                 complete: @escaping () -> Void = {}) {
        guard let gameBoard = gameBoards[id] else {
            fatalError("Invalid board ID: \(id)")
        }
        
        activeWord.reset()
        
        gameBoard.resetBoardWithAnimation(animationLength: animationLength,
                                          speed: speed,
                                          delay: delay,
                                          loadHints: loadHints,
                                          hardReset: hardReset)
        complete()
    }
    
    // MARK: - Board Appearance Methods
    
    /// Sets the backgrounds for a single board's active row.
    ///
    /// - Parameters:
    ///   - id: The ID of the board.
    ///   - comparisons: An array of comparison results for each letter.
    func setActiveWordBackground(_ id: UUID, comparisons: [LetterComparison]) {
        guard let gameBoard = gameBoards[id] else {
            fatalError("Invalid board ID: \(id)")
        }
        
        gameBoard.setActiveWordBackground(comparisons)
    }
    
    /// Sets the target word hints for a single board.
    ///
    /// - Parameters:
    ///   - id: The ID of the board.
    ///   - comparisons: An array of comparison results for each letter.
    func setTargetWordHints(_ id: UUID, comparisons: [LetterComparison]) {
        guard let gameBoard = gameBoards[id] else {
            fatalError("Invalid board ID: \(id)")
        }
        gameBoard.setTargetWordHints(comparisons)
    }
    
    /// Sets the target word hints for multiple boards.
    ///
    /// - Parameter comparisons: A dictionary mapping board IDs to arrays of comparison results.
    func setTargetWordHints(_ comparisons: [UUID: [LetterComparison]]) {
        for id in comparisons.keys {
            if let gameBoard = gameBoards[id], let boardComparisons = comparisons[id] {
                gameBoard.setTargetWordHints(boardComparisons)
            }
        }
    }
    
    /// Triggers a shake animation on the active rows of all boards.
    func shakeActiveRows() {
        for gameBoard in gameBoards.allValues {
            gameBoard.activeWord?.shake()
        }
    }
}
