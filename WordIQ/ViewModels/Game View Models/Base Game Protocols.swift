import SwiftUI

// MARK: Game View Models
/// Protocol to define structure for base game requirements
protocol GameBaseProtocol : ObservableObject {
    var clockViewModel: ClockViewModel { get set }
    var isKeyboardUnlocked: Bool { get set }
    var showPauseMenu: Bool { get set }
    
    func exitGame()
    func pauseGame()
}

/// Protocol to define structure for single word game requirements
protocol SingleBoardGame : GameBaseProtocol {
    var targetWord: DatabaseWordModel { get }
    var gameOptionsModel: SingleBoardGameOptionsModel { get set }
}

/// Protocol to define structure for four word game requirements
protocol MultiBoardGame : GameBaseProtocol {
    var targetWords: OrderedDictionaryCodable<UUID, DatabaseWordModel> { get set }
    var gameOptionsModel: MultiBoardGameOptionsModel { get set }
}
