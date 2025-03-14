/// Struct for saving clock state
struct ClockSaveStateModel : Codable {
    let isClockTimer: Bool
    
    let timeElapsed: Int
    let timeLimit: Int
    let timeRemaining: Int
}
