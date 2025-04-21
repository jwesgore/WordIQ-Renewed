import Foundation
import Combine

/// View Model to facilitate setting game settings
class SettingsViewModel: ObservableObject {
    
    let notificationHelper = NotificationHelper()
    
    // MARK: Gameplay Settings
    @Published var colorBlind: Bool {
        didSet {
            UserDefaultsClient.shared.setting_colorBlindMode = colorBlind
        }
    }
    @Published var showHints: Bool {
        didSet {
            UserDefaultsClient.shared.setting_showHints = showHints
        }
    }
    @Published var soundEffects: Bool {
        didSet {
            UserDefaultsClient.shared.setting_soundEffects = soundEffects
        }
    }
    @Published var hapticFeedback: Bool {
        didSet {
            UserDefaultsClient.shared.setting_hapticFeedback = hapticFeedback
        }
    }
    
    // MARK: Notification Settings
    @Published var notificationsOn: Bool {
        didSet {
            if notificationsOn {
                checkEnableDailyNotifications1()
                checkEnableDailyNotifications2()
            } else {
                notificationHelper.dailyNotificationsDisable()
            }
            UserDefaultsClient.shared.setting_notificationsOn = notificationsOn
        }
    }
    @Published var notificationsDaily1: Bool {
        didSet {
            UserDefaultsClient.shared.setting_notificationsDaily1 = notificationsDaily1
            checkEnableDailyNotifications1()
        }
    }
    @Published var notificationsDaily1Time: Date {
        didSet {
            let components = ValueConverter.dateToDateComponents(notificationsDaily1Time, components: [.hour, .minute])
            UserDefaultsClient.shared.setting_notificationsDaily1Time = components
            
            notificationHelper.removeNotificationRequest(NotificationIdentifiers.dailyNotification1.id)
            notificationHelper.dailyNotificationsEnable1()
        }
    }
    @Published var notificationsDaily2: Bool {
        didSet {
            UserDefaultsClient.shared.setting_notificationsDaily2 = notificationsDaily2
            checkEnableDailyNotifications2()
        }
    }
    @Published var notificationsDaily2Time: Date {
        didSet {
            let components = ValueConverter.dateToDateComponents(notificationsDaily2Time, components: [.hour, .minute])
            UserDefaultsClient.shared.setting_notificationsDaily2Time = components
            
            notificationHelper.removeNotificationRequest(NotificationIdentifiers.dailyNotification2.id)
            notificationHelper.dailyNotificationsEnable2()
        }
    }
    
    // MARK: Quickplay Settings
    @Published var quickplayMode: GameMode {
        didSet {
            UserDefaultsClient.shared.quickplaySetting_mode = quickplayMode
        }
    }
    @Published var quickplayDifficulty: GameDifficulty {
        didSet {
            UserDefaultsClient.shared.quickplaySetting_difficulty = quickplayDifficulty
        }
    }
    @Published var quickplayTimeLimit: Int {
        didSet {
            UserDefaultsClient.shared.quickplaySetting_timeLimit = quickplayTimeLimit
        }
    }
    
    var quickplayTimeLimitOptions: (Int, Int, Int) {
        return GameTimeLimit.getTimesFromGameMode(quickplayMode)
    }
    var showTimeLimitOptions: Bool {
        return [GameMode.rushMode, GameMode.frenzyMode].contains(quickplayMode)
    }
    
    init() {
        self.colorBlind = UserDefaultsClient.shared.setting_colorBlindMode
        self.showHints = UserDefaultsClient.shared.setting_showHints
        self.soundEffects = UserDefaultsClient.shared.setting_soundEffects
        self.hapticFeedback = UserDefaultsClient.shared.setting_hapticFeedback
        self.notificationsOn = UserDefaultsClient.shared.setting_notificationsOn
        
        self.notificationsDaily1 = UserDefaultsClient.shared.setting_notificationsDaily1
        let dateComponents1 = UserDefaultsClient.shared.setting_notificationsDaily1Time
        if let dateTime1 = ValueConverter.dateComponentsToDate(dateComponents1) {
            self.notificationsDaily1Time = dateTime1
        } else {
            self.notificationsDaily1Time = Date()
        }
        
        self.notificationsDaily2 = UserDefaultsClient.shared.setting_notificationsDaily2
        let dateComponents2 = UserDefaultsClient.shared.setting_notificationsDaily2Time
        if let dateTime2 = ValueConverter.dateComponentsToDate(dateComponents2) {
            self.notificationsDaily2Time = dateTime2
        } else {
            self.notificationsDaily2Time = Date()
        }
        
        self.quickplayMode = UserDefaultsClient.shared.quickplaySetting_mode
        self.quickplayDifficulty = UserDefaultsClient.shared.quickplaySetting_difficulty
        self.quickplayTimeLimit = UserDefaultsClient.shared.quickplaySetting_timeLimit
    }
    
    private func checkEnableDailyNotifications1() {
        if notificationsDaily1 {
            notificationHelper.dailyNotificationsEnable1()
        } else {
            notificationHelper.removeNotificationRequest(NotificationIdentifiers.dailyNotification1.id)
        }
    }
    
    private func checkEnableDailyNotifications2() {
        if notificationsDaily2 {
            notificationHelper.dailyNotificationsEnable2()
        } else {
            notificationHelper.removeNotificationRequest(NotificationIdentifiers.dailyNotification2.id)
        }
    }
}
