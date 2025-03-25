import SwiftUI

/// Model used to package up game mode options
class SingleWordGameModeOptionsModel : SingleWordGameOptionsProtocol {
    var gameMode: GameMode
    var gameDifficulty: GameDifficulty
    var timeLimit: Int
    var targetWord: DatabaseWordModel
        
    /// Initializer that takes in a target word
    init(gameMode: GameMode, gameDifficulty: GameDifficulty, timeLimit: Int, targetWord: DatabaseWordModel) {
        self.gameMode = gameMode
        self.gameDifficulty = gameDifficulty
        self.timeLimit = timeLimit
        self.targetWord = targetWord
    }
    
    /// Initializer that presets the target word
    convenience init(gameMode: GameMode = .standardMode, gameDifficulty: GameDifficulty = .normal, timeLimit: Int = 0) {
        let targetWord = WordDatabaseHelper.shared.fetchRandomFiveLetterWord(withDifficulty: gameDifficulty)
        self.init(gameMode: gameMode, gameDifficulty: gameDifficulty, timeLimit: timeLimit, targetWord: targetWord)
    }
    
    /// Gets the view model for the set game mode options
    func getSingleWordGameViewModel() -> SingleWordGameViewModel {
        switch gameMode {
        case .standardMode: return StandardModeViewModel(gameOptions: self)
        case .rushMode: return RushModeViewModel(gameOptions: self)
        case .frenzyMode: return FrenzyModeViewModel(gameOptions: self)
        case .zenMode: return ZenModeViewModel(gameOptions: self)
        case .dailyGame: return DailyModeViewModel(gameOptions: self)
        default: fatalError("Invalid game mode selection")
        }
    }
    
    /// Gets a fresh game over data model base on current settings
    func getSingleWordGameOverDataModelTemplate() -> SingleWordGameOverDataModel {
        return SingleWordGameOverDataModel(self)
    }
    
    /// Resets the target word so the model can be persisted
    func resetTargetWord() {
        self.targetWord = WordDatabaseHelper.shared.fetchRandomFiveLetterWord(withDifficulty: gameDifficulty);
    }
    
    /// Resets all values back to default so the model can be persisted
    func resetToDefaults() {
        self.gameMode = .standardMode
        self.gameDifficulty = .normal
        self.timeLimit = 0
    }
}

