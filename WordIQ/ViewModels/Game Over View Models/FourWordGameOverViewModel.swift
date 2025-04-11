import SwiftUI

/// View Model for a game over screen
class FourWordGameOverViewModel : ObservableObject {
    
    // MARK: Constants
    let functionButtonDimensions : (CGFloat, CGFloat) = (50, 400)
    
    private let extraPlayAgainAction : () -> Void
    private let extraGameOverAction : () -> Void
    
    // MARK: Stats Info Models
    @Published var firstRowStat = InfoItemModel()
    @Published var secondRowStat = InfoItemModel()
    @Published var thirdRowStat = InfoItemModel()
    @Published var fourthRowStat = InfoItemModel()
    
    // MARK: Button View Models
    lazy var backButton: TopDownButtonViewModel = {
        TopDownButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1) {
            self.extraGameOverAction()
            AppNavigationController.shared.exitFromFourWordGame()
        }
    }()
    lazy var playAgainButton: TopDownButtonViewModel = {
        TopDownButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1) {
            self.extraPlayAgainAction()
            AppNavigationController.shared.playAgainFourWordGame()
        }
    }()
    
    var gameOverData: GameOverDataModel
    
    /// Initializer
    init(_ gameOverData: GameOverDataModel,
         extraPlayAgainAction: @escaping () -> Void = {},
         extraGameOverAction: @escaping () -> Void = {}) {
        self.gameOverData = gameOverData
        self.extraPlayAgainAction = extraPlayAgainAction
        self.extraGameOverAction = extraGameOverAction
        
        setRowDefaults()
    }
    
    func setRowDefaults() {
        // Set First Row Defaults
        firstRowStat.icon = SFAssets.timer
        firstRowStat.label = SystemNames.GameOver.timeElapsed
        
        // Set Second Row Defaults
        secondRowStat.icon = SFAssets.numberSign
        secondRowStat.label = SystemNames.GameOver.guesses
        
        // Set Third Row Defaults
        thirdRowStat.icon = SFAssets.star
        thirdRowStat.label = SystemNames.GameOver.currentStreak
        
        // Set Fourth Row Defaults
        fourthRowStat.icon = SFAssets.stats
        fourthRowStat.label = SystemNames.GameOver.winPercent
    }
    
    func setRowValues(statsModel: StatsModel) {
        // Set First and Second Row values
        firstRowStat.value = TimeUtility.formatTimeShort(gameOverData.timeElapsed)
        secondRowStat.value = gameOverData.numberOfValidGuesses.description
        thirdRowStat.value = statsModel.currentStreak.description
        fourthRowStat.value = ValueConverter.doubleToPercent(statsModel.winRate)
    }
    
    func trySaveGameData(databaseHelper: GameDatabaseHelper) {
        databaseHelper.saveGame(gameOverData)
        UserDefaultsHelper.shared.update(gameOverData)
    }
}
