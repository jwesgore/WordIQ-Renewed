import SwiftUI

/// Game Board View Model
class GameBoardViewModel : ObservableObject, Identifiable {
    
    let boardHeight: Int
    let boardSpacing: CGFloat
    let boardWidth: Int
    
    @Published var activeWord: GameBoardWordViewModel?
    @Published var wordViewModels: [GameBoardWordViewModel] = []
    
    var id: UUID
    var boardPosition: Int
    var isBoardActive: Bool = true
    var targetWordHints: [ValidCharacters?] = []
    var targetWordBackgrounds: [LetterComparison] = []
    
    required init(boardHeight: Int, boardWidth: Int, boardSpacing: CGFloat, id: UUID = UUID()) {
        self.id = id
        
        self.boardHeight = boardHeight
        self.boardWidth = boardWidth
        self.boardSpacing = boardSpacing
        
        self.boardPosition = 0
        
        for _ in 0..<boardHeight {
            self.wordViewModels.append(GameBoardWordViewModel(boardWidth: boardWidth, boardSpacing: boardSpacing))
        }
        
        for _ in 0..<boardWidth {
            self.targetWordHints.append(nil)
            self.targetWordBackgrounds.append(.notSet)
        }
        
        self.activeWord = self.wordViewModels.first
    }
    
    /// Adds a letter onto the active word
    func addLetterToActiveWord(_ letter: ValidCharacters) {
        guard isBoardActive else { return }
        activeWord?.addLetter(letter)
    }
    
    /// Returns the save state for the board
    func getSaveState() -> GameBoardSaveStateModel {
        var gameBoardWordSaveStates = [GameBoardWordSaveStateModel]()
        
        for i in 0..<(self.boardPosition % self.boardHeight) {
            gameBoardWordSaveStates.append(self.wordViewModels[i].getSaveState())
        }
        
        return GameBoardSaveStateModel(id: id,
                                       gameBoardPosition: boardPosition,
                                       gameBoardWords: gameBoardWordSaveStates,
                                       targetWordHints: targetWordHints)
    }
    
    /// Returns the set hints for the game board
    func getTargetWordHints() -> [ValidCharacters?] {
        guard isBoardActive && (UserDefaultsHelper.shared.setting_showHints || boardPosition % boardHeight == 0) else {
            return [ValidCharacters?](repeating: nil, count: boardWidth)
        }
        return targetWordHints
    }
    
    /// Progresses the board down to the next line, runs closure if board is at the end
    func goToNextLine(atEndOfBoard: @escaping () -> Void) {
        guard isBoardActive else { return }
        
        self.boardPosition += 1
        
        guard self.boardPosition < self.boardHeight else {
            atEndOfBoard()
            return
        }

        self.activeWord = wordViewModels[self.boardPosition % self.boardHeight]
        self.activeWord?.loadHints(getTargetWordHints())
    }
    
    /// Load in save save
    func loadSaveState(gameSaveState: GameSaveStateModel) {
        let boardSaveState = gameSaveState.gameBoard
        
        self.id = boardSaveState.id
        self.boardPosition = boardSaveState.gameBoardPosition
        self.targetWordHints = boardSaveState.targetWordHints
        
        self.wordViewModels = []
        
        for i in 0..<boardHeight {
            let gameBoardWord = GameBoardWordViewModel(boardWidth: boardWidth, boardSpacing: boardSpacing)
            
            if i < boardSaveState.gameBoardWords.count {
                gameBoardWord.loadSaveState(boardSaveState.gameBoardWords[i])
            }
            
            self.wordViewModels.append(gameBoardWord)
        }
        
        self.activeWord = self.wordViewModels[boardSaveState.gameBoardPosition % boardHeight]
        self.activeWord?.loadHints(getTargetWordHints())
    }
    
    /// Removes the last letter from the active word
    func removeLetterFromActiveWord() {
        guard isBoardActive else { return }
        activeWord?.removeLetter()
    }
    
    /// Function to reset the board to its default state
    func resetBoardHard() {
        
        for word in self.wordViewModels {
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

    /// Function to reset the board to its default state with an animation
    func resetBoardWithAnimation(animationLength: Double = 0.25,
                                 speed: Double = 4.0,
                                 delay: Double = 0.0,
                                 loadHints: Bool = false,
                                 hardReset: Bool = false,
                                 complete: @escaping () -> Void = {}) {
        
        // Calculate animation delay
        let totalDelay = ((animationLength / 2.5 ) * Double(boardWidth)) + delay
        
        // Call reset on all word view models on board
        for i in stride(from: boardHeight - 1, through: 0, by: -1) {
            DispatchQueue.main.asyncAfter(deadline: .now() + ((animationLength / 2.5 ) * Double(boardWidth - i)) + delay) {
                self.wordViewModels[i].resetWithAnimation(animationLength: animationLength, speed: speed)
            }
        }
        
        // Set position to top word and ensure board is active
        boardPosition = 0
        isBoardActive = true
        activeWord = wordViewModels.first
        
        // If hard reset, clear hints and set backgrounds to not set for game over screen (used in frenzy mostly)
        if hardReset {
            for i in 0..<boardWidth {
                targetWordHints[i] = nil
                targetWordBackgrounds[i] = .notSet
            }
        }
        
        // Load hints (or dont) and run closure
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay + 0.2) {
            if loadHints {
                self.activeWord?.loadHints(self.getTargetWordHints())
            }
            
            complete()
        }
    }
    
    /// Function to reset the board to its default state with an animation async
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
    
    /// Sets the active word's background
    func setActiveWordBackground(_ comparisons: [LetterComparison]) {
        guard isBoardActive else { return }
        activeWord?.setBackgrounds(comparisons)
        
        for (index, incomingComparison) in comparisons.enumerated() {
            targetWordBackgrounds[index] = max(incomingComparison, targetWordBackgrounds[index])
        }
    }
    
    /// Sets the target word hints for the board
    func setTargetWordHints(_ comparisons: [LetterComparison]) {
        if let activeWord, let gameWord = activeWord.getWord() {
            for (index, (letter, comparison)) in zip(gameWord.letters, comparisons).enumerated() {
                if comparison == .correct {
                    self.targetWordHints[index] = letter
                }
            }
        }
    }
}
