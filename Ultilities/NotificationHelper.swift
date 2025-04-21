import UserNotifications

/// Class to assist with more easily handling notifications
class NotificationHelper {
    
    /// Gets the current notification setting status
    func checkNotificationPermission() async -> UNAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                continuation.resume(returning: settings.authorizationStatus)
            }
        }
    }
    
    /// Helper function to simplify disabling daily notifications
    func dailyNotificationsDisable() {
        removeNotificationRequest(NotificationIdentifiers.dailyNotification1.id)
        removeNotificationRequest(NotificationIdentifiers.dailyNotification2.id)
    }

    /// Enables all daily notifications
    func dailyNotificationsEnable() {
        dailyNotificationsEnable1()
        dailyNotificationsEnable2()
    }
    
    /// Enables first daily notification
    func dailyNotificationsEnable1() {
        let dailyModel1 = NotificationModel(title: "WordIQ",
                                            body: "A new daily puzzle is ready to play!",
                                            id: NotificationIdentifiers.dailyNotification1.id,
                                            badge: 0,
                                            sound: .default)
        
        scheduleNotificationDateMatching(dailyModel1, dateComponent: UserDefaultsClient.shared.setting_notificationsDaily1Time)
    }
    
    /// Enabled second daily notification
    func dailyNotificationsEnable2() {
        let dailyModel2 = NotificationModel(title: "WordIQ",
                                            body: "Don't lose that streak! Have you played today's daily?",
                                            id: NotificationIdentifiers.dailyNotification1.id,
                                            badge: 0,
                                            sound: .default)
        
        scheduleNotificationDateMatching(dailyModel2, dateComponent: UserDefaultsClient.shared.setting_notificationsDaily2Time)
    }
    
    /// Removes notification matching the given identifier
    func removeNotificationRequest(_ notification: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification])
    }
    
    /// Function to request notification permission
    func requestNotificationPermission() async {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                continuation.resume()
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
