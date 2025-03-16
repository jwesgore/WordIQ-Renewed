
/// Store notification identifiers
enum NotificationIdentifiers: Identifiable {
    
    case dailyNotification1
    case dailyNotification2
    
    // Implementation of Identifiable
    var id: String {
        switch self {
        case .dailyNotification1:
            return "dailyNotification1"
        case .dailyNotification2:
            return "dailyNotification2"
        }
    }
}

