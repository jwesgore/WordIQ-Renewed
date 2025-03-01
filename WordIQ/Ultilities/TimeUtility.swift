
/// Utility for static time functions
class TimeUtility {
    
    // MARK: Format Time Functions
    /// Returns a string representation of the time in minutes
    static func formatTimeShort(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        
        if hours == 0 {
            return String(format: "%d:%02d", minutes, remainingSeconds)
        }
        else {
            return String(format: "%d:%02d:%02d", hours, minutes, remainingSeconds)
        }
    }
    
    /// Returns a string representation of the time in minutes
    static func formatTimeLong(_ seconds: Int) -> String {
        var timeString = ""
        
        let days = seconds / 86400
        let hours = (seconds / 3600) % 24
        let minutes = (seconds / 60) % 60
        let remainingSeconds = seconds % 60
        
        if days > 0 {timeString += days.formatted() + " days "}
        if hours > 0 {timeString += hours.formatted() + " hours "}
        if minutes > 0 {timeString += minutes.formatted() + " minutes "}
        timeString += remainingSeconds.formatted() + " seconds"
        return timeString
    }
}
