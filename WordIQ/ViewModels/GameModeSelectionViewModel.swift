import SwiftUI

/// ViewModel to manage the GameModeSelectionView
class GameModeSelectionViewModel : ObservableObject {
    
    let appNavigationController: AppNavigationController
    let selectionNavigationController : GameSelectionNavigationController
    
    var StartButton : TopDownButtonViewModel
    var BackButton : TopDownButtonViewModel
    
    var DifficultySelectionManager : TopDownRadioButtonGroupViewModel
    var EasyDifficultyButton : TopDownRadioButtonViewModel
    var NormalDifficultyButton : TopDownRadioButtonViewModel
    var HardDifficultyButton : TopDownRadioButtonViewModel
    
    var TimeSelectionManager : TopDownRadioButtonGroupViewModel
    var TimeSelection1Button : TopDownRadioButtonViewModel
    var TimeSelection2Button : TopDownRadioButtonViewModel
    var TimeSelection3Button : TopDownRadioButtonViewModel
    
    var DailyGameButton : TopDownButtonViewModel
    var QuickplayGameButton : TopDownButtonViewModel
    var StandardGameModeButton : TopDownButtonViewModel
    var RushGameModeButton : TopDownButtonViewModel
    var FrenzyGameModeButton : TopDownButtonViewModel
    var ZenGameModeButton : TopDownButtonViewModel
    
    var FourWordGameModeButton : TopDownButtonViewModel
    
    var GameViewModel : SingleWordGameViewModel?
    
    @Published var singleWordGameModeOptions : SingleWordGameModeOptionsModel
    @Published var multiWordGameModeOptions : FourWordGameModeOptionsModel
    @Published var DisplaySettings: Bool = false
    @Published var DisplayStats: Bool = false
    @Published var TimeLimitOptions : (Int, Int, Int) = (0, 0, 0)
    
    // Calculated Values
    var showTimeLimitOptions: Bool {
        return [GameMode.rushMode, GameMode.frenzyMode].contains(singleWordGameModeOptions.gameMode)
    }
    
    // Set Values
    let HalfButtonDimensions: (CGFloat, CGFloat) = (70, 200)
    let GameModeButtonDimension: (CGFloat, CGFloat) = (70, 400)
    let DifficultyButtonDimension: (CGFloat, CGFloat) = (50, 400)
    let TimeSelectionButtonDimension: (CGFloat, CGFloat) = (50, 400)
    let NavigationButtonDimension: (CGFloat, CGFloat) = (50, 400)
    
    init() {
        
        // Step 1: Initialize Models
        self.appNavigationController = AppNavigationController.shared
        self.selectionNavigationController = GameSelectionNavigationController.shared
        self.singleWordGameModeOptions = SingleWordGameModeOptionsModel()
        self.multiWordGameModeOptions = FourWordGameModeOptionsModel()
        
        // Step 2: Initialize all buttons without action
        self.StartButton = TopDownButtonViewModel(height: NavigationButtonDimension.0, width: NavigationButtonDimension.1)
        self.BackButton = TopDownButtonViewModel(height: NavigationButtonDimension.0, width: NavigationButtonDimension.1)
        
        self.DifficultySelectionManager = TopDownRadioButtonGroupViewModel()
        self.EasyDifficultyButton = TopDownRadioButtonViewModel(height: DifficultyButtonDimension.0, width: DifficultyButtonDimension.1, groupManager: DifficultySelectionManager)
        self.NormalDifficultyButton = TopDownRadioButtonViewModel(height: DifficultyButtonDimension.0, width: DifficultyButtonDimension.1, groupManager: DifficultySelectionManager, isPressed: true)
        self.HardDifficultyButton = TopDownRadioButtonViewModel(height: DifficultyButtonDimension.0, width: DifficultyButtonDimension.1, groupManager: DifficultySelectionManager)
        
        self.TimeSelectionManager = TopDownRadioButtonGroupViewModel()
        self.TimeSelection1Button = TopDownRadioButtonViewModel(height: TimeSelectionButtonDimension.0, width: TimeSelectionButtonDimension.1, groupManager: TimeSelectionManager)
        self.TimeSelection2Button = TopDownRadioButtonViewModel(height: TimeSelectionButtonDimension.0, width: TimeSelectionButtonDimension.1, groupManager: TimeSelectionManager, isPressed: true)
        self.TimeSelection3Button = TopDownRadioButtonViewModel(height: TimeSelectionButtonDimension.0, width: TimeSelectionButtonDimension.1, groupManager: TimeSelectionManager)
        
        self.DailyGameButton = TopDownButtonViewModel(height: HalfButtonDimensions.0, width: HalfButtonDimensions.1)
        self.QuickplayGameButton = TopDownButtonViewModel(height: HalfButtonDimensions.0, width: HalfButtonDimensions.1)
        self.StandardGameModeButton = TopDownButtonViewModel(height: GameModeButtonDimension.0, width: GameModeButtonDimension.1)
        self.RushGameModeButton = TopDownButtonViewModel(height: GameModeButtonDimension.0, width: GameModeButtonDimension.1)
        self.FrenzyGameModeButton = TopDownButtonViewModel(height: GameModeButtonDimension.0, width: GameModeButtonDimension.1)
        self.ZenGameModeButton = TopDownButtonViewModel(height: GameModeButtonDimension.0, width: GameModeButtonDimension.1)
        self.FourWordGameModeButton = TopDownButtonViewModel(height: GameModeButtonDimension.0, width: GameModeButtonDimension.1)
        
        // Step 4: Add actions to buttons
        self.StartButton.action = {
            self.startSingleWordGame()
        }
        self.BackButton.action = {
            self.goBackToModeSelection()
        }
        
        self.EasyDifficultyButton.action = {
            self.singleWordGameModeOptions.gameDifficulty = .easy
        }
        self.NormalDifficultyButton.action = {
            self.singleWordGameModeOptions.gameDifficulty = .normal
        }
        self.HardDifficultyButton.action = {
            self.singleWordGameModeOptions.gameDifficulty = .hard
        }
        
        self.TimeSelection1Button.action = {
            self.singleWordGameModeOptions.timeLimit = self.TimeLimitOptions.0
        }
        self.TimeSelection2Button.action = {
            self.singleWordGameModeOptions.timeLimit = self.TimeLimitOptions.1
        }
        self.TimeSelection3Button.action = {
            self.singleWordGameModeOptions.timeLimit = self.TimeLimitOptions.2
        }
        
        self.DailyGameButton.action = {
            self.startDaily()
        }
        self.QuickplayGameButton.action = {
            self.singleWordGameModeOptions.gameMode = UserDefaultsHelper.shared.quickplaySetting_mode
            self.singleWordGameModeOptions.timeLimit = UserDefaultsHelper.shared.quickplaySetting_timeLimit
            self.singleWordGameModeOptions.gameDifficulty = UserDefaultsHelper.shared.quickplaySetting_difficulty
            self.startSingleWordGame()
        }
        self.StandardGameModeButton.action = {
            self.TimeLimitOptions = GameTimeLimit.none.values
            self.singleWordGameModeOptions.gameMode = .standardMode
            self.singleWordGameModeOptions.timeLimit = 0
            self.goToGameModeOptions(.standardMode)
        }
        self.RushGameModeButton.action = {
            self.TimeLimitOptions = GameTimeLimit.rush.values
            self.singleWordGameModeOptions.gameMode = .rushMode
            self.singleWordGameModeOptions.timeLimit = GameTimeLimit.rush.values.1
            self.TimeSelectionManager.communicate(self.TimeSelection2Button.id)
            self.goToGameModeOptions(.rushMode)
        }
        self.FrenzyGameModeButton.action = {
            self.TimeLimitOptions = GameTimeLimit.frenzy.values
            self.singleWordGameModeOptions.gameMode = .frenzyMode
            self.singleWordGameModeOptions.timeLimit = GameTimeLimit.frenzy.values.1
            self.TimeSelectionManager.communicate(self.TimeSelection2Button.id)
            self.goToGameModeOptions(.frenzyMode)
        }
        self.ZenGameModeButton.action = {
            self.TimeLimitOptions = GameTimeLimit.none.values
            self.singleWordGameModeOptions.gameMode = .zenMode
            self.singleWordGameModeOptions.timeLimit = 0
            self.goToGameModeOptions(.zenMode)
        }
        self.FourWordGameModeButton.action = {
            self.startMultiWordGame()
        }
        
        // Step 5: Add radio buttons to their managers
        self.DifficultySelectionManager.add(EasyDifficultyButton, NormalDifficultyButton, HardDifficultyButton)
        self.TimeSelectionManager.add(TimeSelection1Button, TimeSelection2Button, TimeSelection3Button)
    }
    
    // MARK: Navigation Functions
    /// Starts the game in daily mode
    func startDaily() {
        self.singleWordGameModeOptions.gameMode = .dailyGame
        self.singleWordGameModeOptions.timeLimit = 0
        self.singleWordGameModeOptions.gameDifficulty = .daily
        self.singleWordGameModeOptions.targetWord = WordDatabaseHelper.shared.fetchDailyFiveLetterWord()
        self.appNavigationController.goToViewWithAnimation(.singleWordGame, delay:0.25, pauseLength: 0.25)
    }
    
    /// Starts the game with the defined game options
    func startSingleWordGame() {
        self.singleWordGameModeOptions.resetTargetWord()
        self.appNavigationController.goToViewWithAnimation(.singleWordGame, delay:0.25, pauseLength: 0.25)
    }
    
    func startMultiWordGame() {
        self.multiWordGameModeOptions.resetToDefaults()
        self.appNavigationController.goToViewWithAnimation(.fourWordGame, delay:0.25, pauseLength: 0.25)
    }
    
    /// Function to transition the view from mode selection to options
    func goToGameModeOptions(_ gameMode: GameMode) {
        self.selectionNavigationController.goToViewWithAnimation(.gameModeSelectionOptions)
    }
    
    /// Function to transition the view from options to mode selection
    func goBackToModeSelection() {
        self.selectionNavigationController.goToViewWithAnimation(.gameModeSelection) {
            self.singleWordGameModeOptions.resetToDefaults()
            //self.multiWordGameModeOptions.resetToDefaults()
            self.TimeLimitOptions = (0, 0, 0)
        }
    }

    /// Resets all values for when game is exited
    func exitFromGame() {
        self.goBackToModeSelection()
        self.appNavigationController.goToViewWithAnimation(.gameModeSelection)
    }
    
    func getFourWordGameViewModel() -> FourWordGameViewModel {
        let viewModel = FourWordGameViewModel(gameOptions: multiWordGameModeOptions)
        viewModel.exitGameAction = exitFromGame
        return viewModel
    }
    
    /// Creates a game view model based on the game mode options set
    func getSingleWordGameViewModel() -> SingleWordGameViewModel {
        let viewModel : SingleWordGameViewModel = {
            switch singleWordGameModeOptions.gameMode {
            case .standardMode:
                return StandardModeViewModel(gameOptions: self.singleWordGameModeOptions)
            case .rushMode:
                return RushModeViewModel(gameOptions: self.singleWordGameModeOptions)
            case .frenzyMode:
                return FrenzyModeViewModel(gameOptions: self.singleWordGameModeOptions)
            case .zenMode:
                return ZenModeViewModel(gameOptions: self.singleWordGameModeOptions)
            case .dailyGame:
                return DailyModeViewModel(gameOptions: self.singleWordGameModeOptions)
            default:
                return StandardModeViewModel(gameOptions: self.singleWordGameModeOptions)
            }
        }()
        viewModel.exitGameAction = exitFromGame
        GameViewModel = viewModel
        return viewModel
    }
    
}
