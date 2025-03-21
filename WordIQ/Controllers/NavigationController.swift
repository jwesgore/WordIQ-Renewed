import SwiftUI

class NavigationController: ObservableObject {
    
    static let shared = NavigationController()
    
    @Published private(set) var activeView : SystemView
    @Published private(set) var previousView : SystemView
    @Published var activeTransition : any Transition
    
    init(_ startView: SystemView = .splashScreen) {
        self.activeView = startView
        self.previousView = startView
        self.activeTransition = .blurReplace
    }
    
    func getTransition(_ start: SystemView, _ target: SystemView) -> any Transition {
        switch (start, target) {
        case (.gameModeSelection, .gameModeSelectionOptions):
            return .slide
        case (.gameModeSelectionOptions, .gameModeSelection):
            return .slide
        default:
            return .blurReplace
        }
    }
    
    /// Transition to a view immediately
    func goToView(_ view: SystemView) {
        self.activeView = view
    }
    
    /// Transition to a view with animation fading to a blank view
    func goToViewWithAnimation(_ view: SystemView,
                               delay: Double = 0.0,
                               animationLength: Double = 0.5,
                               pauseLength: Double = 0.0) {
        
        self.previousView = self.activeView
        self.activeTransition = self.getTransition(self.activeView, view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            
 
            
            // Fade to an empty view
            withAnimation(.linear(duration: animationLength)) {
                self.activeView = .empty
            }
            
            // Fade back into the target view
            DispatchQueue.main.asyncAfter(deadline: .now() + animationLength + pauseLength) {
                withAnimation {
                    self.activeView = view
                }
            }
        }
    }
    
    /// Performs the necessary checks for notification permissions as well as setting up notifications for the first time
    func notificationFirstLaunch() async {
        let notificationHelper = NotificationHelper()
        
        // If notifications are not determined, ask for permission
        if await notificationHelper.checkNotificationPermission() == .notDetermined {
            await notificationHelper.requestNotificationPermission()
            
            // If first time setup is authorized, set up notification reminders
            if await notificationHelper.checkNotificationPermission() == .authorized {
                notificationHelper.dailyNotificationsEnable()
            }
        }
    }
    
}

protocol NavigationControllerView {
    
}
