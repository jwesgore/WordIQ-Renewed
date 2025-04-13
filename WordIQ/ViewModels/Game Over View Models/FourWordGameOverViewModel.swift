import SwiftUI

/// ViewModel for the game over screen in the Four Word Game.
///
/// This ViewModel manages and displays game over statistics, and provides
/// view models for game over screen buttons to either exit the game or play again.
class FourWordGameOverViewModel: ObservableObject {
    
    // MARK: - Constants
    
    /// Dimensions for function buttons (height, width).
    let functionButtonDimensions: (CGFloat, CGFloat) = (50, 400)
    
    // MARK: - Private Properties
    
    /// Closure to execute when the "Play Again" button is pressed.
    private let extraPlayAgainAction: () -> Void
    
    /// Closure to execute when the "Exit Game" button is pressed.
    private let extraGameOverAction: () -> Void
    
    // MARK: - Published Stats Info Models
    
    /// Stat info for the first row (e.g. time elapsed).
    @Published var firstRowStat = InfoItemModel()
    
    /// Stat info for the second row (e.g. number of valid guesses).
    @Published var secondRowStat = InfoItemModel()
    
    /// Stat info for the third row (e.g. current streak).
    @Published var thirdRowStat = InfoItemModel()
    
    /// Stat info for the fourth row (e.g. win percentage).
    @Published var fourthRowStat = InfoItemModel()
    
    // MARK: - Button View Models
    
    /// The back button used to exit the game over screen.
    lazy var backButton: TopDownButtonViewModel = {
        TopDownButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1) {
            self.extraGameOverAction()
            AppNavigationController.shared.exitFromFourWordGame()
        }
    }()
    
    /// The play again button used to restart the game.
    lazy var playAgainButton: TopDownButtonViewModel = {
        TopDownButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1) {
            self.extraPlayAgainAction()
            AppNavigationController.shared.playAgainFourWordGame()
        }
    }()
    
    // MARK: - Public Properties
    
    /// The game over data model containing game statistics for display.
    var gameOverData: GameOverDataModel
    
    // MARK: - Initialization
    
    /// Initializes a new instance of FourWordGameOverViewModel.
    ///
    /// - Parameters:
    ///   - gameOverData: The model containing game over statistics.
    ///   - extraPlayAgainAction: An optional closure to perform additional actions when playing again (default is a no-op).
    ///   - extraGameOverAction: An optional closure to perform additional actions when exiting the game (default is a no-op).
    init(_ gameOverData: GameOverDataModel,
         extraPlayAgainAction: @escaping () -> Void = {},
         extraGameOverAction: @escaping () -> Void = {}) {
        self.gameOverData = gameOverData
        self.extraPlayAgainAction = extraPlayAgainAction
        self.extraGameOverAction = extraGameOverAction
        
        setRowDefaults()
    }
    
    // MARK: - Configuration Methods
    
    /// Configures default values (icons and labels) for all stat info rows.
    func setRowDefaults() {
        // First Row Defaults (Time Elapsed)
        firstRowStat.icon = SFAssets.timer
        firstRowStat.label = SystemNames.GameOver.timeElapsed
        
        // Second Row Defaults (Guesses)
        secondRowStat.icon = SFAssets.numberSign
        secondRowStat.label = SystemNames.GameOver.guesses
        
        // Third Row Defaults (Current Streak)
        thirdRowStat.icon = SFAssets.star
        thirdRowStat.label = SystemNames.GameOver.currentStreak
        
        // Fourth Row Defaults (Win Percentage)
        fourthRowStat.icon = SFAssets.stats
        fourthRowStat.label = SystemNames.GameOver.winPercent
    }
    
    /// Updates the stat rows with the given statistics model.
    ///
    /// - Parameter statsModel: The stats model containing up-to-date game information.
    func setRowValues(statsModel: StatsModel) {
        firstRowStat.value = TimeUtility.formatTimeShort(gameOverData.timeElapsed)
        secondRowStat.value = gameOverData.numberOfValidGuesses.description
        thirdRowStat.value = statsModel.currentStreak.description
        fourthRowStat.value = ValueConverter.doubleToPercent(statsModel.winRate)
    }
    
    /// Attempts to save the game over data to the database and user defaults.
    ///
    /// - Parameter databaseHelper: A helper object used to interface with the game database.
    func trySaveGameData(databaseHelper: GameDatabaseHelper) {
        databaseHelper.saveGame(gameOverData)
        UserDefaultsHelper.shared.update(gameOverData)
    }
}
