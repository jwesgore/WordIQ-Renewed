/// Utility for time-related formatting functions
class TimeUtility {
    // MARK: - Format Time Functions
    
    /**
     Converts a time in seconds to a short string representation.
     
     - Parameter seconds: The total time in seconds.
     - Returns: A string in the format "MM:SS" for durations under an hour, or "HH:MM:SS" for longer durations.
     */
    static func formatTimeShort(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        
        if hours == 0 {
            return String(format: "%d:%02d", minutes, remainingSeconds)
        } else {
            return String(format: "%d:%02d:%02d", hours, minutes, remainingSeconds)
        }
    }
    
    /**
     Converts a time in seconds to a detailed string representation.
     
     - Parameter seconds: The total time in seconds.
     - Returns: A human-readable string in the format "X days Y hours Z minutes W seconds".
     */
    static func formatTimeLong(_ seconds: Int) -> String {
        let days = seconds / 86400
        let hours = (seconds % 86400) / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        
        var timeString = ""
        if days > 0 { timeString += "\(days) days " }
        if hours > 0 { timeString += "\(hours) hours " }
        if minutes > 0 { timeString += "\(minutes) minutes " }
        timeString += "\(remainingSeconds) seconds"
        
        return timeString
    }
    
    /**
     Converts a time in seconds to a detailed string representation.
     
     - Parameter seconds: The total time in seconds.
     - Returns: A human-readable string in the format "XD YH ZM WS".
     */
    static func formatTimeAbbreviated(_ seconds: Int, lowercased: Bool = false, concat: Bool = false) -> String {
        let days = seconds / 86400
        let hours = (seconds % 86400) / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        
        var timeString = ""
        if days > 0 { timeString += "\(days)\(lowercased ? "d" : "D") " }
        if hours > 0 { timeString += "\(hours)\(lowercased ? "h" : "H") " }
        if minutes > 0 { timeString += "\(minutes)\(lowercased ? "m" : "M") " }
        if !(concat && days > 0 && hours > 0 && minutes > 0) {
            timeString += "\(remainingSeconds)\(lowercased ? "s" : "S")"
        }
        return timeString
    }
}
