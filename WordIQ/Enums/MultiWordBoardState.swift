/// Enum for helping track what state a multi word board is in
enum MultiWordBoardState {
    case solved
    case unsolved
    case boardMaxedOut
}

extension MultiWordBoardState {
    static func getGameState(from states: [MultiWordBoardState]) -> GameResult {
        if states.allSatisfy({ $0 == .solved }) { return .win }
        if states.contains(.boardMaxedOut) { return .lose }
        return .na
    }
}
