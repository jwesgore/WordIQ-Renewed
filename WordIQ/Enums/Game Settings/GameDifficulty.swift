/// All possible game difficulty settings
enum GameDifficulty: String, Codable {
    case easy
    case normal
    case hard
    
    var asString: String {
        switch self {
        case .easy: return "Easy"
        case .normal: return "Normal"
        case .hard: return "Hard"
        }
    }
    
    var asInt: Int {
        switch self {
        case .easy: return 3
        case .normal: return 2
        case .hard: return 1
        }
    }
}
