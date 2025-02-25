/// Enum to support system wide strings that may get reused
enum SystemNames {
    enum Data {
        static let gameDatabase = "WordIQCoreData"
        static let gameResults = "GameResultsModel"
    }
    
    // MARK: Splash Screen
    enum Title {
        static let title = "WordIQ"
        static let caption = "Fun. Lightweight. Offline."
    }
    
    // MARK: Game Modes
    enum GameModes {
        static let standard = "Standard"
        static let rush = "Rush"
        static let frenzy = "Frenzy"
        static let zen = "Zen"
        
        static let daily = "Daily"
        static let quickplay = "Quickplay"
        
        static let standardMode = "Standard Mode"
        static let rushMode = "Rush Mode"
        static let frenzyMode = "Frenzy Mode"
        static let zenMode = "Zen Mode"
    }
    
    enum GameSettings {
        static let settings = "Settings"
        static let colorBlindMode = "Color Blind Mode"
        static let tapticFeedback = "Taptic Feedback"
        static let showHints = "Show Hints"
        static let soundEffects = "Sound Effects"
        static let quickplaySettings = "Quickplay Settings"
        static let gameplaySettings = "Gameplay Settings"
        static let gameTimeLimit = "Time Limit"
        static let gameMode = "Game Mode"
        static let gameDifficulty = "Difficulty"
    }
    
    enum GamePause {
        static let title = "Paused"
        static let resumeGame = "Resume Game"
    }
    
    // MARK: Game Over
    enum GameOver {
        static let timeElapsed = "Time Elapsed"
        static let gamesPlayed = "Games Played"
        static let score = "Score"
        static let guesses = "Guesses"
    }
    
    static let mainMenu = "Main Menu"
    static let playAgain = "Play Again"
    
    // MARK: Tabview icons
    static let game = "Game"
    static let friends = "Friends"
    static let stats = "Stats"
    
    // MARK: Misc
    static let startGame = "Start Game"
    static let back = "Back"
}
