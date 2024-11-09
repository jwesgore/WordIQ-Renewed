import SwiftUI

/// All possible game end conditions
enum GameResult: String, Codable {
    case win
    case lose
    case na
    
    var gameOverString: String {
        switch self {
        case .win: return "Congradulations!"
        case .lose: return "Game Over"
        case .na: return "Game Over"
        }
    }
}
