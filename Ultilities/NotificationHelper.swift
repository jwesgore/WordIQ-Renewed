import UserNotifications

/// Class to assist with more easily handling notifications
class NotificationHelper {
    
    /// Gets the current notification setting status
    func checkNotificationPermission(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
    
    /// Removes notification matching the given identifier
    func removeNotificationRequest(_ notification: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification])
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
    
    /// Function to request notification
    func scheduleNotificationDateMatching(_ notificationModel: NotificationModel, dateComponent: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = notificationModel.title
        content.body = notificationModel.body
        content.sound = notificationModel.sound
        content.badge = notificationModel.badge
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: notificationModel.repeats)
        
        // Create a request with a unique identifier
        let request = UNNotificationRequest(identifier: notificationModel.id, content: content, trigger: trigger)

        // Add the request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled!")
            }
        }
    }
    
    /// Removes the old notification and re adds it with new values
    func updateScheduledNotificationDateMatching(_ notificationModel: NotificationModel, dateComponent: DateComponents) {
        // Remove the old notification
        self.removeNotificationRequest(notificationModel.id)
        
        // Add updated notification
        self.scheduleNotificationDateMatching(notificationModel, dateComponent: dateComponent)
    }
}
