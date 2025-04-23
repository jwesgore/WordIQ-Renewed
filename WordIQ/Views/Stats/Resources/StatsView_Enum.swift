enum StatsView_Filter_Enum: String, CaseIterable {
    case all = "All"
    case daily = "Daily"
    case standard = "Standard"
    case rush = "Rush"
    case frenzy = "Frenzy"
    case zen = "Zen"
    case quadStandard = "Quad"
    case twentyQuestions = "20 Guesses"
}

extension StatsView_Filter_Enum {
    var asGameMode: GameMode {
        switch self {
        case .daily: return .dailyGame
        case .standard: return .standardMode
        case .rush: return .rushMode
        case .frenzy: return .frenzyMode
        case .zen: return .zenMode
        case .quadStandard: return .quadWordMode
        case .twentyQuestions: return .twentyQuestions
        default: fatalError(#function)
        }
    }
}

extension StatsView_Filter_Enum {
    var isWinnable: Bool {
        switch self {
        case .daily, .standard, .rush, .quadStandard, .twentyQuestions: return true
        default: return false
        }
    }
    
    var guessIncludePlus: Bool {
        switch self {
        case .all, .rush, .zen: return true
        default: return false
        }
    }
    
    var guessStartIndex: Int {
        switch self {
        case .quadStandard: return 4
        default: return 1
        }
    }
    
    var guessEndIndex: Int {
        switch self {
        case .all, .rush, .zen: return 7
        case .quadStandard: return 9
        default: return 6
        }
    }
}
