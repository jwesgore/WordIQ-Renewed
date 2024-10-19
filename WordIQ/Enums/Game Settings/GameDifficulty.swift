/// All possible game difficulty settings
enum GameDifficulty: String, Codable {
    case easy
    case normal
    case hard
    
    var value: String {
        switch self {
        case .easy: return "Easy"
        case .normal: return "Normal"
        case .hard: return "Hard"
        }
    }
}
