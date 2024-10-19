import SwiftUICore

/// All possible game end conditions
enum GameOverResult: String, Codable {
    case win
    case lose
    case gameover
    case null
}
