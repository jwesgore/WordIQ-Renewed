import SwiftUI

/// ViewModel to manage the GameModeSelectionView
class GameModeSelectionViewModel: BaseViewNavigation {
    
    @Published var Offset : Int = 2000
    
    var StartButton : ThreeDButtonViewModel
    var BackButton : ThreeDButtonViewModel
    
    var DifficultySelectionManager : ThreeDRadioButtonGroupViewModel
    var EasyDifficultyButton : ThreeDRadioButtonViewModel
    var NormalDifficultyButton : ThreeDRadioButtonViewModel
    var HardDifficultyButton : ThreeDRadioButtonViewModel
    
    var TimeSelectionManager : ThreeDRadioButtonGroupViewModel
    var TimeSelection1Button : ThreeDRadioButtonViewModel
    var TimeSelection2Button : ThreeDRadioButtonViewModel
    var TimeSelection3Button : ThreeDRadioButtonViewModel
    
    var DailyGameButton : ThreeDButtonViewModel
    var QuickplayGameButton : ThreeDButtonViewModel
    var StandardGameModeButton : ThreeDButtonViewModel
    var RushGameModeButton : ThreeDButtonViewModel
    var FrenzyGameModeButton : ThreeDButtonViewModel
    var ZenGameModeButton : ThreeDButtonViewModel
    
    @Published var GameModeOptions : GameModeOptionsModel
    @Published var DisplaySettings: Bool = false
    @Published var DisplayStats: Bool = false
    @Published var TimeLimitOptions : (Int, Int, Int) = (0, 0, 0)
    
    // Calculated Values
    var showTimeLimitOptions: Bool {
        return [GameMode.rushgame, GameMode.frenzygame].contains(GameModeOptions.gameMode)
    }
    
    // Set Values
    let HalfButtonDimensions: (CGFloat, CGFloat) = (60, 200)
    let GameModeButtonDimension: (CGFloat, CGFloat) = (60, 400)
    let DifficultyButtonDimension: (CGFloat, CGFloat) = (50, 400)
    let TimeSelectionButtonDimension: (CGFloat, CGFloat) = (50, 400)
    let NavigationButtonDimension: (CGFloat, CGFloat) = (50, 400)
    
    override init() {
        // Step 1: Initialize Models
        self.GameModeOptions = GameModeOptionsModel()
        
        // Step 2: Initialize all buttons without action
        self.StartButton = ThreeDButtonViewModel(height: NavigationButtonDimension.0, width: NavigationButtonDimension.1)
        self.BackButton = ThreeDButtonViewModel(height: NavigationButtonDimension.0, width: NavigationButtonDimension.1)
        
        self.DifficultySelectionManager = ThreeDRadioButtonGroupViewModel()
        self.EasyDifficultyButton = ThreeDRadioButtonViewModel(groupManager: DifficultySelectionManager, height: DifficultyButtonDimension.0, width: DifficultyButtonDimension.1)
        self.NormalDifficultyButton = ThreeDRadioButtonViewModel(buttonIsPressed: true, groupManager: DifficultySelectionManager, height: DifficultyButtonDimension.0, width: DifficultyButtonDimension.1)
        self.HardDifficultyButton = ThreeDRadioButtonViewModel(groupManager: DifficultySelectionManager, height: DifficultyButtonDimension.0, width: DifficultyButtonDimension.1)
        
        self.TimeSelectionManager = ThreeDRadioButtonGroupViewModel()
        self.TimeSelection1Button = ThreeDRadioButtonViewModel(groupManager: TimeSelectionManager, height: TimeSelectionButtonDimension.0, width: TimeSelectionButtonDimension.1)
        self.TimeSelection2Button = ThreeDRadioButtonViewModel(buttonIsPressed: true, groupManager: TimeSelectionManager, height: TimeSelectionButtonDimension.0, width: TimeSelectionButtonDimension.1)
        self.TimeSelection3Button = ThreeDRadioButtonViewModel(groupManager: TimeSelectionManager, height: TimeSelectionButtonDimension.0, width: TimeSelectionButtonDimension.1)
        
        self.DailyGameButton = ThreeDButtonViewModel(height: HalfButtonDimensions.0, width: HalfButtonDimensions.1)
        self.QuickplayGameButton = ThreeDButtonViewModel(height: HalfButtonDimensions.0, width: HalfButtonDimensions.1)
        self.StandardGameModeButton = ThreeDButtonViewModel(height: GameModeButtonDimension.0, width: GameModeButtonDimension.1, speed: 0.02)
        self.RushGameModeButton = ThreeDButtonViewModel(height: GameModeButtonDimension.0, width: GameModeButtonDimension.1)
        self.FrenzyGameModeButton = ThreeDButtonViewModel(height: GameModeButtonDimension.0, width: GameModeButtonDimension.1)
        self.ZenGameModeButton = ThreeDButtonViewModel(height: GameModeButtonDimension.0, width: GameModeButtonDimension.1)
        
        // Step 3: Init base
        super.init()
        
        // Step 4: Add actions to buttons
        self.StartButton.action = {
            self.startGame()
        }
        self.BackButton.action = {
            self.goBackToModeSelection()
        }
        
        self.EasyDifficultyButton.action = {
            self.GameModeOptions.gameDifficulty = .easy
        }
        self.NormalDifficultyButton.action = {
            self.GameModeOptions.gameDifficulty = .normal
        }
        self.HardDifficultyButton.action = {
            self.GameModeOptions.gameDifficulty = .hard
        }
        
        self.TimeSelection1Button.action = {
            self.GameModeOptions.timeLimit = self.TimeLimitOptions.0
        }
        self.TimeSelection2Button.action = {
            self.GameModeOptions.timeLimit = self.TimeLimitOptions.1
        }
        self.TimeSelection3Button.action = {
            self.GameModeOptions.timeLimit = self.TimeLimitOptions.2
        }
        
        self.DailyGameButton.action = {
            self.startDaily()
        }
        self.QuickplayGameButton.action = {
            self.GameModeOptions.gameMode = UserDefaultsHelper.shared.quickplaySetting_mode
            self.GameModeOptions.timeLimit = UserDefaultsHelper.shared.quickplaySetting_timeLimit
            self.GameModeOptions.gameDifficulty = UserDefaultsHelper.shared.quickplaySetting_difficulty
            self.startGame()
        }
        self.StandardGameModeButton.action = {
            self.TimeLimitOptions = GameTimeLimit.none.values
            self.GameModeOptions.gameMode = .standardgame
            self.GameModeOptions.timeLimit = 0
            self.goToGameModeOptions(.standardgame)
        }
        self.RushGameModeButton.action = {
            self.TimeLimitOptions = GameTimeLimit.rush.values
            self.GameModeOptions.gameMode = .rushgame
            self.GameModeOptions.timeLimit = GameTimeLimit.rush.values.1
            self.TimeSelectionManager.communicate(self.TimeSelection2Button.id)
            self.goToGameModeOptions(.rushgame)
        }
        self.FrenzyGameModeButton.action = {
            self.TimeLimitOptions = GameTimeLimit.frenzy.values
            self.GameModeOptions.gameMode = .frenzygame
            self.GameModeOptions.timeLimit = GameTimeLimit.frenzy.values.1
            self.TimeSelectionManager.communicate(self.TimeSelection2Button.id)
            self.goToGameModeOptions(.frenzygame)
        }
        self.ZenGameModeButton.action = {
            self.TimeLimitOptions = GameTimeLimit.none.values
            self.GameModeOptions.gameMode = .zengame
            self.GameModeOptions.timeLimit = 0
            self.goToGameModeOptions(.zengame)
        }
        
        // Step 5: Add radio buttons to their managers
        self.DifficultySelectionManager.add(EasyDifficultyButton, NormalDifficultyButton, HardDifficultyButton)
        self.TimeSelectionManager.add(TimeSelection1Button, TimeSelection2Button, TimeSelection3Button)
    }
    
    // MARK: Navigation Functions
    /// Starts the game in daily mode
    func startDaily() {
        self.GameModeOptions.gameMode = .daily
        self.GameModeOptions.timeLimit = 0
        self.GameModeOptions.gameDifficulty = .daily
        self.GameModeOptions.targetWord = WordDatabaseHelper.shared.fetchDailyWord()
        super.fadeToBlankDelay(delay:0.25, hang: 0.25)
    }
    
    /// Starts the game with the defined game options
    func startGame() {
        self.GameModeOptions.resetTargetWord()
        super.fadeToBlankDelay(delay:0.25, hang: 0.25)
    }
    
    /// Function to transition the view from mode selection to options
    func goToGameModeOptions(_ gameMode: GameMode) {
        withAnimation (.easeInOut(duration: 0.5)) {
            self.Offset = 0
        }
    }
    
    /// Function to transition the view from options to mode selection
    func goBackToModeSelection() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            withAnimation (.easeInOut(duration: 0.5)) {
                self.Offset = 2000
            } completion: {
                self.GameModeOptions.resetToDefaults()
                self.TimeLimitOptions = (0, 0, 0)
            }
        }
    }

    /// Resets all values for when game is exited
    func exitFromGame() {
        self.goBackToModeSelection()
        super.fadeToBlank(fromRoot: false)
    }
    
    /// Creates a game view model based on the game mode options set
    func getGameViewModel() -> GameViewModel {
        let gameVM : GameViewModel = {
            switch GameModeOptions.gameMode {
            case .standardgame:
                return StandardModeViewModel(gameOptions: self.GameModeOptions)
            case .rushgame:
                return RushModeViewModel(gameOptions: self.GameModeOptions)
            case .frenzygame:
                return FrenzyModeViewModel(gameOptions: self.GameModeOptions)
            case .zengame:
                return ZenModeViewModel(gameOptions: self.GameModeOptions)
            case .daily:
                return DailyModeViewModel(gameOptions: self.GameModeOptions)
            case .quickplay:
                return StandardModeViewModel(gameOptions: self.GameModeOptions)
            }
        }()
        gameVM.exitGameAction = exitFromGame
        return gameVM
    }
    
}
