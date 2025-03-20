import SwiftUI

class GameBoardViewModel : ObservableObject {
    
    let boardHeight: Int
    let boardSpacing: CGFloat
    let boardWidth: Int
    
    @Published var activeWord: GameBoardWordViewModel?
    @Published var wordViewModels: [GameBoardWordViewModel] = []
    
    var boardPosition: Int
    var targetWordHints: [ValidCharacters?] = []
    
    init(boardHeight: Int, boardWidth: Int, boardSpacing: CGFloat) {
        self.boardHeight = boardHeight
        self.boardWidth = boardWidth
        self.boardSpacing = boardSpacing
        
        self.boardPosition = 0
        
        for _ in 0..<boardHeight {
            self.wordViewModels.append(GameBoardWordViewModel(boardWidth: boardWidth, boardSpacing: boardSpacing))
        }
        
        for _ in 0..<boardWidth {
            self.targetWordHints.append(nil)
        }
        
        self.activeWord = self.wordViewModels.first
    }
    
    func getSaveState() -> [GameBoardWordSaveStateModel] {
        var gameBoardWordSaveStates = [GameBoardWordSaveStateModel]()
        
        for i in 0..<(self.boardPosition % self.boardHeight) {
            gameBoardWordSaveStates.append(self.wordViewModels[i].getSaveState())
        }
        
        return gameBoardWordSaveStates
    }
    
    func getTargetWordHints() -> [ValidCharacters?] {
        if (UserDefaultsHelper.shared.setting_showHints || boardPosition % boardHeight == 0) {
            return targetWordHints
        } else {
            return [ValidCharacters?](repeating: nil, count: boardWidth)
        }
    }
    
    func goToNextLine(atEndOfBoard: @escaping () -> Void) {
        guard self.boardPosition < self.boardHeight else {
            atEndOfBoard()
            return
        }

        self.activeWord = wordViewModels[self.boardPosition % self.boardHeight]
        self.activeWord?.loadHints(getTargetWordHints())
    }
    
    func loadSaveState(gameSaveState: GameSaveStateModel) {
        self.boardPosition = gameSaveState.boardPosition
        self.targetWordHints = gameSaveState.targetWordHints
        
        for i in 0..<boardHeight {
            let gameBoardWord = GameBoardWordViewModel(boardWidth: boardWidth, boardSpacing: boardSpacing)
            
            if i < gameSaveState.gameBoardWords.count {
                gameBoardWord.loadSaveState(gameSaveState.gameBoardWords[i])
            }
            
            self.wordViewModels.append(gameBoardWord)
        }
        
        self.activeWord = self.wordViewModels[gameSaveState.boardPosition]
        self.activeWord?.loadHints(getTargetWordHints())
    }
    
    /// Function to reset the board to its default state
    func resetBoardHard() {
        
        for word in self.wordViewModels {
            word.reset()
        }
        
        self.activeWord = self.wordViewModels.first
        self.boardPosition = 0
        self.targetWordHints = [ValidCharacters?](repeating: nil, count: self.boardWidth)
    }
    
    func resetBoardSoft() {
        
    }
    
    /// Function to reset the board to its default state with an animation
    func resetBoardWithAnimation(animationLength: Double = 0.25,
                                 speed: Double = 4.0,
                                 delay: Double = 0.0,
                                 loadHints: Bool = false,
                                 hardReset: Bool = false,
                                 complete: @escaping () -> Void = {}) {
        
        let totalDelay = ((animationLength / 2.5 ) * Double(boardWidth)) + delay
        
        for i in stride(from: boardHeight - 1, through: 0, by: -1) {
            DispatchQueue.main.asyncAfter(deadline: .now() + ((animationLength / 2.5 ) * Double(boardWidth - i)) + delay) {
                self.wordViewModels[i].resetWithAnimation(animationLength: animationLength, speed: speed)
            }
        }
        
        self.boardPosition = 0
        self.activeWord = self.wordViewModels.first
        
        if hardReset {
            self.targetWordHints = [ValidCharacters?](repeating: nil, count: boardWidth)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay + 0.2) {
            if loadHints {
                self.activeWord?.loadHints(self.getTargetWordHints())
            }
            
            complete()
        }
    }
}
