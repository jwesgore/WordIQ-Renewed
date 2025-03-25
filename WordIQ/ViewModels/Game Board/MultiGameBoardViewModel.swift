import SwiftUI

/// View Model for multiple Game Boards
class MultiGameBoardViewModel : ObservableObject {
    
    let boardCount: Int
    let boardHeight: Int
    let boardSpacing: CGFloat
    let boardMargin: CGFloat
    let boardWidth: Int
    
    var activeWord: GameBoardWordViewModel
    var gameBoards: [UUID: GameBoardViewModel] = [:]
    
    init(boardHeight: Int, boardWidth: Int, boardCount: Int, boardSpacing: CGFloat, boardMargin: CGFloat) {
        self.boardCount = boardCount
        self.boardHeight = boardHeight
        self.boardWidth = boardWidth
        self.boardSpacing = boardSpacing
        self.boardMargin = boardMargin
        
        self.activeWord = GameBoardWordViewModel(boardWidth: boardWidth, boardSpacing: boardSpacing)
        
        for _ in 0..<boardCount {
            let gameBoard = GameBoardViewModel(boardHeight: boardHeight, boardWidth: boardWidth, boardSpacing: boardSpacing)
            gameBoard.setFontOptions(fontSize: .title3, fontWeight: .semiBold)
            
            gameBoards[gameBoard.id] = gameBoard
        }
    }
    
    /// Adds a letter to all boards
    func addLetterToActiveWord(_ letter: ValidCharacters) {
        activeWord.addLetter(letter)
        for gameBoard in gameBoards.values { gameBoard.addLetterToActiveWord(letter) }
    }
    
    /// Returns all the IDs of the boards
    func getBoardIds() -> [UUID] {
        return gameBoards.values.map { $0.id }
    }
    
    /// Get the target word hints for all boards
    func getAllTargetWordHints() -> [UUID: [ValidCharacters?]] {
        return gameBoards.values.reduce(into: [:]) { result, gameBoard in
            result[gameBoard.id] = gameBoard.getTargetWordHints()
        }
    }
    
    // TODO: Determine if returning [UUID: GameBoardSaveStateModel] is necessary or if it should just return [GameBoardSaveStateModel]
    /// Get the save states of all the boards
    func getSaveStates() -> [UUID: GameBoardSaveStateModel] {
        return gameBoards.values.reduce(into: [:]) { result, gameBoard in
            result[gameBoard.id] = gameBoard.getSaveState()
        }
    }
    
    /// Get the target word hints for a single board
    func getTargetWordHints(_ id: UUID) -> [ValidCharacters?] {
        guard let gameBoard = gameBoards[id] else {
            fatalError("Invalid board ID: \(id)")
        }
        return gameBoard.getTargetWordHints()
    }
    
    /// Progresses all boards to the next line
    func goToNextLine(atEndOfBoard: @escaping () -> Void) {
        
        var atEndOfBoardCalled = false
        
        activeWord.reset()
        
        for gameBoard in gameBoards.values {
            gameBoard.goToNextLine() {
                atEndOfBoardCalled = true
            }
        }
        
        if atEndOfBoardCalled { atEndOfBoard() }
    }
    
    /// Progresses all boards to the next line
    func goToNextLine(_ id: UUID, atEndOfBoard: @escaping () -> Void) {
        guard let gameBoard = gameBoards[id] else {
            fatalError("Invalid board ID: \(id)")
        }
        
        activeWord.reset()
        
        gameBoard.goToNextLine() {
            atEndOfBoard()
        }
    }
    
    /// Removes letter from all boards
    func removeLetterFromActiveWord() {
        activeWord.removeLetter()
        for gameBoard in gameBoards.values { gameBoard.removeLetterFromActiveWord() }
    }
    
    /// Resets all sub board to their default state
    func resetAllBoardsHard() {
        
        activeWord.reset()
        
        for gameBoard in gameBoards.values { gameBoard.resetBoardHard() }
    }
    
    /// Function to reset the board to its default state with an animation
    func resetAllBoardsWithAnimation(animationLength: Double = 0.25,
                                     speed: Double = 4.0,
                                     delay: Double = 0.0,
                                     loadHints: Bool = false,
                                     hardReset: Bool = false,
                                     complete: @escaping () -> Void = {}) {
        Task {
            await withTaskGroup(of: Void.self) { taskGroup in
                for gameBoard in gameBoards.values {
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
    
    /// Resets a single board to its default state
    func resetBoardHard(_ id: UUID) {
        guard let gameBoard = gameBoards[id] else {
            fatalError("Invalid board ID: \(id)")
        }
        gameBoard.resetBoardHard()
    }
    
    /// Resets a single board with animation
    func resetBoardWithAnimation( _ id: UUID,
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
    
    /// Sets the backgrounds for the active row on a single board
    func setActiveWordBackground(_ id: UUID, comparisons: [LetterComparison]) {
        guard let gameBoard = gameBoards[id] else {
            fatalError("Invalid board ID: \(id)")
        }
        
        gameBoard.setActiveWordBackground(comparisons)
    }
    
    /// Sets the target word hints for a single board
    func setTargetWordHints (_ id: UUID, comparisons: [LetterComparison]) {
        guard let gameBoard = gameBoards[id] else {
            fatalError("Invalid board ID: \(id)")
        }
            
        gameBoard.setTargetWordHints(comparisons)
    }
    
    /// Sets the target word hints for the board
    func setTargetWordHints (_ comparisons: [UUID: [LetterComparison]]) {
        for id in comparisons.keys {
            if let gameBoard = gameBoards[id], let boardComparisons = comparisons[id] {
                gameBoard.setTargetWordHints(boardComparisons)
            }
        }
    }
    
    /// Calls shake animation on all boards
    func shakeActiveRows() {
        for gameBoard in gameBoards.values {
            gameBoard.activeWord?.shake()
        }
    }
}
