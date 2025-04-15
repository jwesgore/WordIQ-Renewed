import SwiftUI
import SwiftData

/// ViewModel for the game over screen in a single-word game.
///
/// This model manages game-over statistics, configures the display for various game modes,
/// and provides view models for buttons that allow the player to exit or restart the game.
class SingleWordGameOverViewModel: ObservableObject {
    
    // MARK: - Constants
    
    /// Dimensions for function buttons (height, width).
    let functionButtonDimensions: (CGFloat, CGFloat) = (50, 400)
    
    // MARK: - Private Properties
    
    /// Closure executed when the "Play Again" button is pressed.
    private let extraPlayAgainAction: () -> Void
    
    /// Closure executed when the "Game Over" (exit) button is pressed.
    private let extraGameOverAction: () -> Void
    
    // MARK: - Published Stats Info Models
    
    /// Information model for the first row (e.g. time elapsed).
    @Published var firstRowStat = InfoItemModel()
    
    /// Information model for the second row (e.g. number of valid guesses).
    @Published var secondRowStat = InfoItemModel()
    
    /// Information model for the third row (e.g. current streak, games played, or score).
    @Published var thirdRowStat = InfoItemModel()
    
    /// Information model for the fourth row (e.g. win percentage or time per word).
    @Published var fourthRowStat = InfoItemModel()
    
    // MARK: - Button View Models
    
    /// Back button to exit the game over screen.
    lazy var backButton: TopDownButtonViewModel = {
        TopDownButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1) {
            self.extraGameOverAction()
            AppNavigationController.shared.exitFromSingleWordGame()
        }
    }()
    
    /// Play again button to restart the game.
    lazy var playAgainButton: TopDownButtonViewModel = {
        TopDownButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1) {
            self.extraPlayAgainAction()
            AppNavigationController.shared.playAgainSingleWordGame()
        }
    }()
    
    // MARK: - Public Properties
    
    /// The game over data model containing game statistics.
    var gameOverData: GameOverDataModel
    
    // MARK: - Initialization
    
    /// Initializes a new instance of SingleWordGameOverViewModel.
    ///
    /// - Parameters:
    ///   - gameOverData: A GameOverDataModel instance containing statistics for the game over screen.
    ///   - extraPlayAgainAction: An optional closure to perform additional actions when playing again.
    ///   - extraGameOverAction: An optional closure to perform additional actions when exiting the game.
    init(_ gameOverData: GameOverDataModel,
         extraPlayAgainAction: @escaping () -> Void = {},
         extraGameOverAction: @escaping () -> Void = {}) {
        self.gameOverData = gameOverData
        self.extraPlayAgainAction = extraPlayAgainAction
        self.extraGameOverAction = extraGameOverAction
        
        setRowDefaults()
    }
    
    // MARK: - Row Data Functions
    
    /// Configures the default icons and labels for each row based on the game mode.
    func setRowDefaults() {
        // First Row: Time Elapsed
        firstRowStat.icon = SFAssets.timer.rawValue
        firstRowStat.label = SystemNames.GameOver.timeElapsed
        
        // Second Row: Number of Guesses
        secondRowStat.icon = SFAssets.numberSign.rawValue
        secondRowStat.label = SystemNames.GameOver.guesses
        
        // Configure based on game mode
        switch gameOverData.gameMode {
        case .frenzyMode:
            thirdRowStat.icon = SFAssets.star.rawValue
            thirdRowStat.label = SystemNames.GameOver.score
            
            fourthRowStat.icon = SFAssets.timer.rawValue
            fourthRowStat.label = SystemNames.GameOver.timePerWord
        case .zenMode:
            thirdRowStat.icon = SFAssets.timer.rawValue
            thirdRowStat.label = SystemNames.GameOver.gamesPlayed
        default:
            thirdRowStat.icon = SFAssets.star.rawValue
            thirdRowStat.label = SystemNames.GameOver.currentStreak
            
            fourthRowStat.icon = SFAssets.stats.rawValue
            fourthRowStat.label = SystemNames.GameOver.winPercent
        }
    }
    
    /// Updates the stat rows with current values based on the provided StatsModel.
    ///
    /// - Parameter statsModel: A model containing up-to-date game statistics.
    func setRowValues(statsModel: StatsModel) {
        // First and Second Row values
        firstRowStat.value = TimeUtility.formatTimeShort(gameOverData.timeElapsed)
        secondRowStat.value = gameOverData.numberOfValidGuesses.description
        
        switch gameOverData.gameMode {
        case .dailyGame, .standardMode, .rushMode:
            thirdRowStat.value = statsModel.currentStreak.description
            fourthRowStat.value = ValueConverter.doubleToPercent(statsModel.winRate)
        case .frenzyMode:
            let numberOfCorrectWords = gameOverData.targetWordsCorrect.count
            thirdRowStat.value = numberOfCorrectWords.description
            
            // Avoid division by zero when calculating time per word
            fourthRowStat.value = numberOfCorrectWords > 0
                ? TimeUtility.formatTimeShort(gameOverData.timeElapsed / numberOfCorrectWords)
                : TimeUtility.formatTimeShort(gameOverData.timeElapsed)
        case .zenMode:
            thirdRowStat.value = statsModel.totalGamesPlayed.description
        default:
            break
        }
    }
    
    // MARK: - Data Persistence
    
    /// Attempts to save the game over data.
    ///
    /// If in daily mode and the game has already been played, the save is skipped.
    ///
    /// - Parameter databaseHelper: A helper object managing game database operations.
    func trySaveGameData(databaseHelper: GameDatabaseHelper) {
        let isDailyMode = gameOverData.gameMode == .dailyGame
        
        guard !(isDailyMode && AppNavigationController.shared.isDailyAlreadyPlayed) else {
            print("Daily already played")
            return
        }
        
        databaseHelper.saveGame(gameOverData)
        UserDefaultsHelper.shared.update(gameOverData)
    }
}
