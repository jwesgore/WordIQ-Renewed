import UserNotifications

struct NotificationModel {
    let title: String
    let body: String
    let id: String
    
    let badge: NSNumber?
    let repeats: Bool = false
    let sound: UNNotificationSound?
}
