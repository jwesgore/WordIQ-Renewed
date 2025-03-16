
/// Enum to keep track of game time limit options
enum GameTimeLimit {
    case rush, frenzy, none
    
    var values : (Int, Int, Int) {
        switch self {
        case .rush: return (30, 60, 90)
        case .frenzy: return (60, 90, 150)
        case .none: return (0, 0, 0)
        }
    }
    
    /// Parses the given game mode and returns the correct time for it
    static func getTimesFromGameMode(_ gamemode : GameMode) -> (Int, Int, Int) {
        switch gamemode {
        case .rushMode: return GameTimeLimit.rush.values
        case .frenzyMode: return GameTimeLimit.frenzy.values
        default: return GameTimeLimit.none.values
        }
    }
}
