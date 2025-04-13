import SwiftUI

/// Protocol defining the base structure and requirements for a game.
///
/// This protocol provides common properties and functions shared across all game types,
/// including clock management, pause menu handling, and game navigation.
protocol GameBaseProtocol : ObservableObject {
    /// ViewModel for managing the game clock.
    var clockViewModel: ClockViewModel { get set }
    
    /// Boolean to indicate whether the keyboard is unlocked for input.
    var isKeyboardUnlocked: Bool { get set }
    
    /// Boolean to control the visibility of the pause menu.
    var showPauseMenu: Bool { get set }
    
    /// Exits the current game and navigates back to mode selection.
    func exitGame()
    
    /// Pauses the current game and displays the pause menu.
    func pauseGame()
}

/// Protocol defining the structure and requirements for a single-board game.
///
/// This protocol extends `GameBaseProtocol` to include properties specific to single-board gameplay,
/// such as the target word and game options model.
protocol SingleBoardGame : GameBaseProtocol {
    /// The target word for the current single-board game.
    var targetWord: DatabaseWordModel { get }
    
    /// Model containing configuration options for the single-board game.
    var gameOptionsModel: SingleBoardGameOptionsModel { get set }
}

/// Protocol defining the structure and requirements for a multi-board game.
///
/// This protocol extends `GameBaseProtocol` to include properties specific to multi-board gameplay,
/// such as the collection of target words and game options model.
protocol MultiBoardGame : GameBaseProtocol {
    /// A dictionary of target words for the current multi-board game, keyed by UUID.
    var targetWords: OrderedDictionaryCodable<UUID, DatabaseWordModel> { get set }
    
    /// Model containing configuration options for the multi-board game.
    var gameOptionsModel: MultiBoardGameOptionsModel { get set }
}
