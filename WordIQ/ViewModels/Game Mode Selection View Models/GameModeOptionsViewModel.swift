import SwiftUI

class GameModeOptionsViewModel : ObservableObject {
    
    @Published var timeLimitOptions : (Int, Int, Int) = (0, 0, 0)
    
    var difficultySelectionManager : TopDownRadioButtonGroupViewModel
    var easyDifficultyButton : TopDownRadioButtonViewModel
    var normalDifficultyButton : TopDownRadioButtonViewModel
    var hardDifficultyButton : TopDownRadioButtonViewModel
    
    var timeSelectionManager : TopDownRadioButtonGroupViewModel
    var timeSelection1Button : TopDownRadioButtonViewModel
    var timeSelection2Button : TopDownRadioButtonViewModel
    var timeSelection3Button : TopDownRadioButtonViewModel
    
    var startButton : TopDownButtonViewModel
    var backButton : TopDownButtonViewModel
    
    let difficultyButtonDimension: (CGFloat, CGFloat) = (50, 400)
    let navigationButtonDimension: (CGFloat, CGFloat) = (50, 400)
    let timeSelectionButtonDimension: (CGFloat, CGFloat) = (50, 400)
    
    let singleWordGameModeOptions = AppNavigationController.shared.singleWordGameModeOptions
    
    var showTimeLimitOptions: Bool {
        return [GameMode.rushMode, GameMode.frenzyMode].contains(singleWordGameModeOptions.gameMode)
    }
    
    init() {
        self.difficultySelectionManager = TopDownRadioButtonGroupViewModel()
        self.easyDifficultyButton = TopDownRadioButtonViewModel(height: difficultyButtonDimension.0, width: difficultyButtonDimension.1, groupManager: difficultySelectionManager)
        self.normalDifficultyButton = TopDownRadioButtonViewModel(height: difficultyButtonDimension.0, width: difficultyButtonDimension.1, groupManager: difficultySelectionManager, isPressed: true)
        self.hardDifficultyButton = TopDownRadioButtonViewModel(height: difficultyButtonDimension.0, width: difficultyButtonDimension.1, groupManager: difficultySelectionManager)
        
        self.timeSelectionManager = TopDownRadioButtonGroupViewModel()
        self.timeSelection1Button = TopDownRadioButtonViewModel(height: timeSelectionButtonDimension.0, width: timeSelectionButtonDimension.1, groupManager: timeSelectionManager)
        self.timeSelection2Button = TopDownRadioButtonViewModel(height: timeSelectionButtonDimension.0, width: timeSelectionButtonDimension.1, groupManager: timeSelectionManager, isPressed: true)
        self.timeSelection3Button = TopDownRadioButtonViewModel(height: timeSelectionButtonDimension.0, width: timeSelectionButtonDimension.1, groupManager: timeSelectionManager)
        
        self.startButton = TopDownButtonViewModel(height: navigationButtonDimension.0, width: navigationButtonDimension.1)
        self.backButton = TopDownButtonViewModel(height: navigationButtonDimension.0, width: navigationButtonDimension.1)
        
        self.easyDifficultyButton.action = {
            self.singleWordGameModeOptions.gameDifficulty = .easy
        }
        self.normalDifficultyButton.action = {
            self.singleWordGameModeOptions.gameDifficulty = .normal
        }
        self.hardDifficultyButton.action = {
            self.singleWordGameModeOptions.gameDifficulty = .hard
        }
        self.timeSelection1Button.action = {
            self.singleWordGameModeOptions.timeLimit = self.timeLimitOptions.0
        }
        self.timeSelection2Button.action = {
            self.singleWordGameModeOptions.timeLimit = self.timeLimitOptions.1
        }
        self.timeSelection3Button.action = {
            self.singleWordGameModeOptions.timeLimit = self.timeLimitOptions.2
        }
        self.startButton.action = {
            AppNavigationController.shared.goToSingleWordGame()
        }
        self.backButton.action = {
            GameSelectionNavigationController.shared.goToGameModeSelection()
        }
        
        // Add radio buttons to their managers
        self.difficultySelectionManager.add(easyDifficultyButton, normalDifficultyButton, hardDifficultyButton)
        self.timeSelectionManager.add(timeSelection1Button, timeSelection2Button, timeSelection3Button)
    }
    
    /// Sets the game mode options model to defaults for a specific mode
    func setSingleWordGameMode(_ gameMode: GameMode) {
        switch gameMode {
        case .standardMode:
            setSingleWordGameModeStandard()
        case .rushMode:
            setSingleWordGameModeRush()
        case .frenzyMode:
            setSingleWordGameModeFrenzy()
        case .zenMode:
            setSingleWordGameModeZen()
        case .quickplay:
            setSingleWordGameModeQuickPlay()
            AppNavigationController.shared.goToSingleWordGame()
        case .dailyGame:
            setSingleWordGameModeDaily()
            AppNavigationController.shared.goToSingleWordGame()
        default:
            setSingleWordGameModeStandard()
        }
    }
    
    /// Prepares the game mode options for the daily puzzle
    private func setSingleWordGameModeDaily() {
        singleWordGameModeOptions.gameMode = .dailyGame
        singleWordGameModeOptions.timeLimit = 0
        singleWordGameModeOptions.gameDifficulty = .daily
        singleWordGameModeOptions.targetWord = WordDatabaseHelper.shared.fetchDailyFiveLetterWord()
    }
    
    /// Sets the game mode options to quick play saved settings
    private func setSingleWordGameModeQuickPlay() {
        singleWordGameModeOptions.gameMode = UserDefaultsHelper.shared.quickplaySetting_mode
        singleWordGameModeOptions.timeLimit = UserDefaultsHelper.shared.quickplaySetting_timeLimit
        singleWordGameModeOptions.gameDifficulty = UserDefaultsHelper.shared.quickplaySetting_difficulty
    }
    
    /// Sets the game mode options to standard mode defaults
    private func setSingleWordGameModeStandard() {
        timeLimitOptions = GameTimeLimit.none.values
        singleWordGameModeOptions.gameMode = .standardMode
        singleWordGameModeOptions.timeLimit = 0
    }
    
    /// Sets the game mode options to rush mode defaults
    private func setSingleWordGameModeRush() {
        timeLimitOptions = GameTimeLimit.rush.values
        singleWordGameModeOptions.gameMode = .rushMode
        singleWordGameModeOptions.timeLimit = GameTimeLimit.rush.values.1
        timeSelectionManager.communicate(timeSelection2Button.id)
    }
    
    /// Sets the game mode options to frenzy mode defaults
    private func setSingleWordGameModeFrenzy() {
        timeLimitOptions = GameTimeLimit.frenzy.values
        singleWordGameModeOptions.gameMode = .frenzyMode
        singleWordGameModeOptions.timeLimit = GameTimeLimit.frenzy.values.1
        timeSelectionManager.communicate(timeSelection2Button.id)
    }
    
    /// Sets the game mode options to zen mode defaults
    private func setSingleWordGameModeZen() {
        timeLimitOptions = GameTimeLimit.none.values
        singleWordGameModeOptions.gameMode = .zenMode
        singleWordGameModeOptions.timeLimit = 0
    }
}
