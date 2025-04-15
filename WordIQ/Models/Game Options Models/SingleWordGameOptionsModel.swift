import SwiftUI

/// Model used to package up game mode options for a single-word game.
///
/// This model holds the configuration for a single-word game, including the game mode,
/// difficulty, time limit, and target word. It also provides helper methods to generate
/// the appropriate view models for game play and game over screens.
class SingleWordGameOptionsModel: SingleWordGameOptions {
    
    // MARK: - Properties
    
    /// The selected game mode (e.g. standard, rush, frenzy, zen, daily).
    var gameMode: GameMode
    
    /// The difficulty level for the game.
    var gameDifficulty: GameDifficulty
    
    /// The time limit for the game; a value of 0 indicates no time limit.
    var timeLimit: Int
    
    /// The target word for the game.
    var targetWord: DatabaseWordModel
    
    // MARK: - Initializers
    
    /// Designated initializer that configures the game options with a specified target word.
    ///
    /// - Parameters:
    ///   - gameMode: The selected game mode.
    ///   - gameDifficulty: The selected game difficulty.
    ///   - timeLimit: The time limit for the game. A value of 0 indicates no time limit.
    ///   - targetWord: A `DatabaseWordModel` representing the word to be guessed.
    init(gameMode: GameMode, gameDifficulty: GameDifficulty, timeLimit: Int, targetWord: DatabaseWordModel) {
        self.gameMode = gameMode
        self.gameDifficulty = gameDifficulty
        self.timeLimit = timeLimit
        self.targetWord = targetWord
    }
    
    /// Convenience initializer that presets the target word.
    ///
    /// This initializer randomly fetches a five-letter word based on the supplied difficulty.
    ///
    /// - Parameters:
    ///   - gameMode: The game mode to use. Defaults to `.standardMode`.
    ///   - gameDifficulty: The game difficulty to use. Defaults to `.normal`.
    ///   - timeLimit: The time limit for the game. Defaults to 0 (no time limit).
    convenience init(gameMode: GameMode = .standardMode, gameDifficulty: GameDifficulty = .normal, timeLimit: Int = 0) {
        let targetWord = WordDatabaseHelper.shared.fetchRandomFiveLetterWord(withDifficulty: gameDifficulty)
        self.init(gameMode: gameMode, gameDifficulty: gameDifficulty, timeLimit: timeLimit, targetWord: targetWord)
    }
    
    // MARK: - ViewModel Generation Methods
    
    /// Retrieves the corresponding single-word game view model based on the current game mode options.
    ///
    /// - Returns: A `SingleBoardGameViewModel<GameBoardViewModel>` configured for the selected game mode.
    func getSingleWordGameViewModel() -> SingleBoardGameViewModel<GameBoardViewModel> {
        switch gameMode {
        case .standardMode:
            return StandardModeViewModel(gameOptions: self)
        case .rushMode:
            return RushModeViewModel(gameOptions: self)
        case .frenzyMode:
            return FrenzyModeViewModel(gameOptions: self)
        case .zenMode:
            return ZenModeViewModel(gameOptions: self)
        case .dailyGame:
            return DailyModeViewModel(gameOptions: self)
        default:
            fatalError("Invalid game mode selection")
        }
    }
    
    /// Generates a new game-over data model based on the current game options.
    ///
    /// - Returns: A new instance of `GameOverDataModel` configured with this model.
    func getSingleWordGameOverDataModelTemplate() -> GameOverDataModel {
        return GameOverDataModel(self)
    }
    
    /// Retrieves the twenty questions game view model for the current options.
    ///
    /// - Returns: A `TwentyQuestionsViewModel` configured accordingly.
    func getTwentyQuestionsGameViewModel() -> TwentyQuestionsViewModel {
        return TwentyQuestionsViewModel(gameOptions: self)
    }
    
    // MARK: - Reset Methods
    
    /// Resets the target word so that a new word is used.
    ///
    /// This method continuously fetches a new random five-letter word until it is different from the current word.
    func resetTargetWord() {
        let currentWord = targetWord
        while currentWord == targetWord {
            targetWord = WordDatabaseHelper.shared.fetchRandomFiveLetterWord(withDifficulty: gameDifficulty)
        }
    }
    
    /// Resets all game options back to their default values.
    func resetToDefaults() {
        gameMode = .standardMode
        gameDifficulty = .normal
        timeLimit = 0
    }
}
