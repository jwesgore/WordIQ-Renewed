import SwiftUI
import SwiftData

/// View Model for the game over screen
class SingleWordGameOverViewModel : ObservableObject {
    
    // MARK: - Constants
    let functionButtonDimensions : (CGFloat, CGFloat) = (50, 400)
    
    private let extraPlayAgainAction : () -> Void
    private let extraGameOverAction : () -> Void
    
    // MARK: - Stats Info Models
    @Published var firstRowStat = InfoItemModel()
    @Published var secondRowStat = InfoItemModel()
    @Published var thirdRowStat = InfoItemModel()
    @Published var fourthRowStat = InfoItemModel()
    
    // MARK: - Button View Models
    lazy var backButton: TopDownButtonViewModel = {
        TopDownButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1) {
            self.extraGameOverAction()
            AppNavigationController.shared.exitFromSingleWordGame()
        }
    }()
    lazy var playAgainButton: TopDownButtonViewModel = {
        TopDownButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1) {
            self.extraPlayAgainAction()
            AppNavigationController.shared.playAgainSingleWordGame()
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
    
    // MARK: - Row Data Functions
    /// Initialize the icon and label defaults for each row based on the game mode
    func setRowDefaults() {
        // Set First Row Defaults
        firstRowStat.icon = SFAssets.timer
        firstRowStat.label = SystemNames.GameOver.timeElapsed
        
        // Set Second Row Defaults
        secondRowStat.icon = SFAssets.numberSign
        secondRowStat.label = SystemNames.GameOver.guesses
        
        switch gameOverData.gameMode {
        case .frenzyMode:
            // Set Third Row Defaults
            thirdRowStat.icon = SFAssets.star
            thirdRowStat.label = SystemNames.GameOver.score
            
            // Set Fourth Row Defaults
            fourthRowStat.icon = SFAssets.timer
            fourthRowStat.label = SystemNames.GameOver.timePerWord
        case .zenMode:
            // Set Third Row Defaults
            thirdRowStat.icon = SFAssets.timer
            thirdRowStat.label = SystemNames.GameOver.gamesPlayed
        default:
            // Set Third Row Defaults
            thirdRowStat.icon = SFAssets.star
            thirdRowStat.label = SystemNames.GameOver.currentStreak
            
            // Set Fourth Row Defaults
            fourthRowStat.icon = SFAssets.stats
            fourthRowStat.label = SystemNames.GameOver.winPercent
        }
    }
    
    /// Set the values on all stats items based on the game mode
    func setRowValues(statsModel: StatsModel) {
        
        // Set First and Second Row values
        firstRowStat.value = TimeUtility.formatTimeShort(gameOverData.timeElapsed)
        secondRowStat.value = gameOverData.numberOfValidGuesses.description
        
        switch gameOverData.gameMode {
        case .dailyGame, .standardMode, .rushMode:
            thirdRowStat.value = statsModel.currentStreak.description
            fourthRowStat.value = ValueConverter.doubleToPercent(statsModel.winRate)
        case .frenzyMode:
            let numberOfCorrectWords = gameOverData.targetWordsCorrect.count
            thirdRowStat.value = numberOfCorrectWords.description
            if numberOfCorrectWords > 0 {
                fourthRowStat.value = TimeUtility.formatTimeShort(gameOverData.timeElapsed / numberOfCorrectWords)
            }
            else {
                fourthRowStat.value = TimeUtility.formatTimeShort(gameOverData.timeElapsed)
            }
        case .zenMode:
            thirdRowStat.value = statsModel.totalGamesPlayed.description
        default:
            break
        }
    }
    
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
