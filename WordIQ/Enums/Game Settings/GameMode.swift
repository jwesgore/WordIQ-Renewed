/// All possible game modes
enum GameMode: String, Codable, Identifiable {
    case standardgame
    case rushgame
    case frenzygame
    case zengame
    case daily
    case quickplay
    
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
    
    var description: String {
        switch self {
        case .standardgame: return "The classic game you know and love. Six guesses to get the word."
        case .rushgame: return "Make as many guesses as you want, but you only have so much time."
        case .frenzygame: return "Only six guesses and a time limit. How many words can you get?"
        case .zengame: return "No time limit, no guess limit. Just play to have fun."
        default: return ""
        }
    }
    
    var caption: String {
        switch self {
        case .standardgame: return "Guess the word"
        case .rushgame: return "Test your speed"
        case .frenzygame: return "Test your endurance"
        case .zengame: return "Take it easy"
        default: return ""
        }
    }
}
