
/// Enum that defines views for the AppNavigationController
enum SystemViewEnum : NavigationEnum {
    case empty
    case fourWordGame
    case gameModeSelection
    case singleWordGame
    case splashScreen
    case twentyQuestionsGame
    
    static func empty() -> SystemViewEnum {
        .empty
    }
}

/// Enum that defines the subview for SingleWordNavigationController
enum GameViewEnum : NavigationEnum {
    case empty
    case game
    case gameOver
    
    static func empty() -> GameViewEnum {
        .empty
    }
}

enum GameSelectionViewEnum : NavigationEnum {
    case empty
    case modeOptions
    case modeSelection
    case settings
    case stats
    
    static func empty() -> GameSelectionViewEnum {
        .empty
    }
}

protocol NavigationEnum : Equatable {
    static func empty() -> Self
}
