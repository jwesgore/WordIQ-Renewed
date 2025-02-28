/// All possible game difficulty settings
enum GameDifficulty: String, Codable {
    case easy
    case normal
    case hard
    
    // Get mode as string
    var asString: String {
        switch self {
        case .easy: return "Easy"
        case .normal: return "Normal"
        case .hard: return "Hard"
        }
    }
    
    // Get mode ID
    var id: Int {
        switch self {
        case .easy: return 3
        case .normal: return 2
        case .hard: return 1
        }
    }
    
    // Get mode by ID
    static func fromId(_ id: Int) -> GameDifficulty? {
        switch id {
        case 3: return .easy
        case 2: return .normal
        case 1: return .hard
        default: return nil
        }
    }
}
