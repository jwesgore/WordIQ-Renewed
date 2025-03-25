import SwiftUI
import CoreData

/// View Model for the game over screen
class SingleWordGameOverViewModel : ObservableObject {
    
    // MARK: Constants
    let databaseHelper = GameDatabaseHelper()
    let functionButtonDimensions : (CGFloat, CGFloat) = (50, 400)
    
    // MARK: Stats Info Models
    @Published var firstRowStat = InfoItemModel()
    @Published var secondRowStat = InfoItemModel()
    @Published var thirdRowStat = InfoItemModel()
    @Published var fourthRowStat = InfoItemModel()
    
    // MARK: Button View Models
    var backButton : TopDownButtonViewModel
    var playAgainButton : TopDownButtonViewModel
    
    /// Initializer
    init() {
        self.backButton = TopDownButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1) {
            GameSelectionNavigationController.shared.exitFromGame()
        }
        self.playAgainButton = TopDownButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1) {
            SingleWordGameNavigationController.shared().goToGameView()
        }
        
        self.setRowDefaults()
    }
    
    // MARK: Row Data Functions
    /// Initialize the icon and label defaults for each row based on the game mode
    func setRowDefaults(gameMode : GameMode = AppNavigationController.shared.singleWordGameModeOptions.gameMode) {
        // Set First Row Defaults
        firstRowStat.icon = SFAssets.timer
        firstRowStat.label = SystemNames.GameOver.timeElapsed
        
        // Set Second Row Defaults
        secondRowStat.icon = SFAssets.numberSign
        secondRowStat.label = SystemNames.GameOver.guesses
        
        switch gameMode {
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
    func setRowValues(_ gameOverData: SingleWordGameOverDataModel) {
        // Set First and Second Row values
        firstRowStat.value = TimeUtility.formatTimeShort(gameOverData.timeElapsed)
        secondRowStat.value = gameOverData.numValidGuesses.description
        
        switch gameOverData.gameMode {
        case .dailyGame:
            thirdRowStat.value = UserDefaultsHelper.shared.currentStreak_daily.description
            fourthRowStat.value = ValueConverter.doubleToPercent(databaseHelper.getGameModeWinPercentage(mode: gameOverData.gameMode))
        case .standardMode:
            thirdRowStat.value = UserDefaultsHelper.shared.currentStreak_standard.description
            fourthRowStat.value = ValueConverter.doubleToPercent(databaseHelper.getGameModeWinPercentage(mode: gameOverData.gameMode))
        case .rushMode:
            thirdRowStat.value = UserDefaultsHelper.shared.currentStreak_rush.description
            fourthRowStat.value = ValueConverter.doubleToPercent(databaseHelper.getGameModeWinPercentage(mode: gameOverData.gameMode))
        case .frenzyMode:
            thirdRowStat.value = gameOverData.numCorrectWords.description
            if gameOverData.numCorrectWords > 0 {
                fourthRowStat.value = TimeUtility.formatTimeShort(gameOverData.timeElapsed / gameOverData.numCorrectWords)
            }
            else {
                fourthRowStat.value = TimeUtility.formatTimeShort(gameOverData.timeElapsed)
            }
        case .zenMode:
            thirdRowStat.value = databaseHelper.getGameModeCount(mode: gameOverData.gameMode).description
        default:
            break
        }
    }
    
    // MARK: General Functions
    /// Save game over data
    func saveData(_ gameOverData: SingleWordGameOverDataModel) {
        guard !(gameOverData.gameMode == .dailyGame && UserDefaultsHelper.shared.lastDailyPlayed == gameOverData.targetWord.daily) else {
            print("Daily already played")
            return
        }
        
        databaseHelper.saveGame(gameOverData)
        UserDefaultsHelper.shared.update(gameOverData)
    }
}
