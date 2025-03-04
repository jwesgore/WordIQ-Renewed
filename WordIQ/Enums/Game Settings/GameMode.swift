/// All possible game modes
enum GameMode: String, Codable, Identifiable, Equatable {
    case standardgame
    case rushgame
    case frenzygame
    case zengame
    case daily
    case quickplay
    
    // Get GameMode Id
    var id: Int {
        switch self {
        case .standardgame: return 0
        case .rushgame: return 1
        case .frenzygame: return 2
        case .zengame: return 3
        case .daily: return 4
        case .quickplay: return 5
        }
    }
    
    // Get GameMode as string
    var value: String {
        switch self {
        case .standardgame: return "Standard"
        case .rushgame: return "Rush"
        case .frenzygame: return "Frenzy"
        case .zengame: return "Zen"
        case .daily: return "Daily"
        case .quickplay: return "Quickplay"
        }
    }
    
    // Get text description for GameMode
    var description: String {
        switch self {
        case .standardgame: return "The classic game you know and love. Six guesses to get the word."
        case .rushgame: return "Make as many guesses as you want, but you only have so much time."
        case .frenzygame: return "Only six guesses and a time limit. How many words can you get?"
        case .zengame: return "No time limit, no guess limit. Just play to have fun."
        default: return ""
        }
    }
    
    // Get text caption for GameMode
    var caption: String {
        switch self {
        case .standardgame: return "Guess the word"
        case .rushgame: return "Test your speed"
        case .frenzygame: return "Test your endurance"
        case .zengame: return "Take it easy"
        default: return ""
        }
    }
    
    // Get GameMode from id
    static func fromId(_ id: Int) -> GameMode? {
        switch id {
        case 0: return .standardgame
        case 1: return .rushgame
        case 2: return .frenzygame
        case 3: return .zengame
        case 4: return .daily
        case 5: return .quickplay
        default: return nil
        }
    }
}
