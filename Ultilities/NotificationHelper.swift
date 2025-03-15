import UserNotifications

class NotificationHelper {
    static let shared = NotificationHelper()
    
    private init() {
        
    }
    
    /// Gets the current notification setting status
    func checkNotificationPermission(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
    
    /// Function to request notification permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            } else if granted {
                print("Notification permission granted!")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder!"
        content.body = "This is your notification."
        content.sound = .default
        content.badge = NSNumber(value: 1) // Optional: Show a badge on the app icon

        // Trigger the notification in 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)

        // Create a request with a unique identifier
        let request = UNNotificationRequest(identifier: "TestNotification", content: content, trigger: trigger)

        // Add the request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled!")
            }
        }
    }
}
