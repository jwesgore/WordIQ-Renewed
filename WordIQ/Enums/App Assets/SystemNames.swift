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
        
        static let generalSettings = "General Settings"
        static let colorBlindMode = "Color Blind Mode"
        static let hapticFeedback = "Haptic Feedback"
        static let showHints = "Show Hints"
        static let soundEffects = "Sound Effects"
        static let quickplaySettings = "Quickplay Settings"
        static let gameplaySettings = "Gameplay Settings"
        static let gameTimeLimit = "Time Limit"
        static let gameMode = "Game Mode"
        static let gameDifficulty = "Difficulty"
        static let notificationSettings = "Notification Settings"
        static let notifications = "Notifications"
        static let dailyNotification1 = "Daily Reminder 1"
        static let dailyNotification2 = "Daily Reminder 2"
    }
    
    enum GameStats {
        // MARK: Titles
        static let title = "Statistics"
        static let generalStats = "General Stats"
        static let dailyModeStats = "Daily Mode Stats"
        static let standardModeStats = "Standard Mode Stats"
        static let rushModeStats = "Rush Mode Stats"
        static let frenzyModeStats = "Frenzy Mode Stats"
        static let zenModeStats = "Zen Mode Stats"
        
        // MARK: Stats
        static let avgScore = "Avg. Score"
        static let avgTime = "Avg. Time"
        static let avgTimePerWord = "Avg. Time Per Word"
        static let bestStreak = "Best Streak"
        static let bestScore = "Best Score"
        static let currentStreak = "Current Streak"
        static let gamesPlayed = "Games Played"
        static let guessesMade = "Guesses Made"
        static let timePlayed = "Time Played"
        static let winPercentage = "Win %"
    }
    
    enum GamePause {
        static let title = "Paused"
        static let resumeGame = "Resume Game"
    }
    
    enum GameOver {
        static let bestStreak = "Best Streak"
        static let currentStreak = "Current Streak"
        static let gamesPlayed = "Games Played"
        static let guesses = "Guesses"
        static let score = "Score"
        static let timeElapsed = "Time Elapsed"
        static let timePerWord = "Time Per Word"
        static let timeRemaining = "Time Remaining"
        static let winPercent = "Win %"
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
