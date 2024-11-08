import SwiftUI

/// ViewModel to manage the GameModeSelectionView
class GameModeSelectionViewModel: ObservableObject {
    
    @Published private var _offset : Int = 2000
    var Offset : Int {
        get {
            return _offset
        }
        set {
            withAnimation (.easeInOut(duration: 0.5)) {
                _offset = newValue
            }
        }
    }
    
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
    
    var GameModeOptions : GameModeOptionsModel
    @Published var TimeLimitOptions : (Int, Int, Int) = (0, 0, 0)
    
    let HalfButtonDimensions: (CGFloat, CGFloat) = (75, 200)
    let GameModeButtonDimension: (CGFloat, CGFloat) = (75, 400)
    let DifficultyButtonDimension: (CGFloat, CGFloat) = (75, 400)
    let TimeSelectionButtonDimension: (CGFloat, CGFloat) = (50, 400)
    let NavigationButtonDimension: (CGFloat, CGFloat) = (75, 400)
    
    init() {
        // Step 1: Initialize Models
        self.GameModeOptions = GameModeOptionsModel(gameMode: .standardgame, gameDifficulty: .normal, timeLimit: 0)
        
        // Step 2: Initialize all buttons without action
        self.StartButton = ThreeDButtonViewModel(height: NavigationButtonDimension.0, width: NavigationButtonDimension.1)
        self.BackButton = ThreeDButtonViewModel(height: NavigationButtonDimension.0, width: NavigationButtonDimension.1)
        
        self.DifficultySelectionManager = ThreeDRadioButtonGroupViewModel()
        self.EasyDifficultyButton = ThreeDRadioButtonViewModel(groupManager: DifficultySelectionManager, height: DifficultyButtonDimension.0, width: DifficultyButtonDimension.1)
        self.NormalDifficultyButton = ThreeDRadioButtonViewModel(groupManager: DifficultySelectionManager, height: DifficultyButtonDimension.0, width: DifficultyButtonDimension.1)
        self.HardDifficultyButton = ThreeDRadioButtonViewModel(groupManager: DifficultySelectionManager, height: DifficultyButtonDimension.0, width: DifficultyButtonDimension.1)
        
        self.TimeSelectionManager = ThreeDRadioButtonGroupViewModel()
        self.TimeSelection1Button = ThreeDRadioButtonViewModel(groupManager: TimeSelectionManager, height: TimeSelectionButtonDimension.0, width: TimeSelectionButtonDimension.1)
        self.TimeSelection2Button = ThreeDRadioButtonViewModel(groupManager: TimeSelectionManager, height: TimeSelectionButtonDimension.0, width: TimeSelectionButtonDimension.1)
        self.TimeSelection3Button = ThreeDRadioButtonViewModel(groupManager: TimeSelectionManager, height: TimeSelectionButtonDimension.0, width: TimeSelectionButtonDimension.1)
        
        self.DailyGameButton = ThreeDButtonViewModel(height: HalfButtonDimensions.0, width: HalfButtonDimensions.1)
        self.QuickplayGameButton = ThreeDButtonViewModel(height: HalfButtonDimensions.0, width: HalfButtonDimensions.1)
        self.StandardGameModeButton = ThreeDButtonViewModel(height: GameModeButtonDimension.0, width: GameModeButtonDimension.1)
        self.RushGameModeButton = ThreeDButtonViewModel(height: GameModeButtonDimension.0, width: GameModeButtonDimension.1)
        self.FrenzyGameModeButton = ThreeDButtonViewModel(height: GameModeButtonDimension.0, width: GameModeButtonDimension.1)
        self.ZenGameModeButton = ThreeDButtonViewModel(height: GameModeButtonDimension.0, width: GameModeButtonDimension.1)
        
        // Step 3: Add actions to buttons
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
            self.goToGameModeOptions(.daily)
        }
        self.QuickplayGameButton.action = {
            self.goToGameModeOptions(.quickplay)
        }
        self.StandardGameModeButton.action = {
            self.TimeLimitOptions = (0,0,0)
            self.GameModeOptions.gameMode = .standardgame
            self.GameModeOptions.timeLimit = 0
            self.goToGameModeOptions(.standardgame)
        }
        self.RushGameModeButton.action = {
            self.TimeLimitOptions = (30, 60, 90)
            self.GameModeOptions.gameMode = .rushgame
            self.goToGameModeOptions(.rushgame)
        }
        self.FrenzyGameModeButton.action = {
            self.TimeLimitOptions = (60, 90, 150)
            self.GameModeOptions.gameMode = .frenzygame
            self.goToGameModeOptions(.frenzygame)
        }
        self.ZenGameModeButton.action = {
            self.TimeLimitOptions = (0,0,0)
            self.GameModeOptions.gameMode = .zengame
            self.GameModeOptions.timeLimit = 0
            self.goToGameModeOptions(.zengame)
        }
        
        // Step 4: Add radio buttons to their managers
        self.DifficultySelectionManager.add(EasyDifficultyButton, NormalDifficultyButton, HardDifficultyButton)
        self.TimeSelectionManager.add(TimeSelection1Button, TimeSelection2Button, TimeSelection3Button)
    }
    
    /// Starts the game with the defined game options
    func startGame() {
        
    }
    
    /// Function to transition the view from mode selection to options
    func goToGameModeOptions(_ gameMode: GameMode) {
        self.Offset = 0
    }
    
    /// Function to transition the view from options to mode selection
    func goBackToModeSelection() {
        self.Offset = 2000
    }
    
}
