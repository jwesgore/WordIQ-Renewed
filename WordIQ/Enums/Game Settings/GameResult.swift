import SwiftUI

/// All possible game end conditions
enum GameResult: String, Codable {
    case win
    case lose
    case na
    
    var gameOverString: String {
        switch self {
        case .win: return "Congratulations!"
        case .lose: return "Game Over"
        case .na: return "Game Over"
        }
    }
    
    var id : Int {
        switch self {
        case .na: return 0
        case .lose: return 1
        case .win: return 2
        }
    }
    
    static func fromId(_ id : Int) -> GameResult {
        switch id {
        case 0: return .na
        case 1: return .lose
        case 2: return .win
        default: return .na
        }
    }
}
