import SwiftUI

struct AppStartingView: View {
    
    @ObservedObject var navigationController : NavigationController
    @ObservedObject var gameModeSelectionVM : GameModeSelectionViewModel
    
    init() {
        let navigationControllerLocal = NavigationController()
        self.navigationController = navigationControllerLocal
        self.gameModeSelectionVM = GameModeSelectionViewModel(navigationControllerLocal)
    }
    
    var body: some View {
        ZStack {
            switch navigationController.activeView {
            case .splashScreen:
                SplashScreenView()
                    .transition(.blurReplace)
                    .onAppear {
                        Task {
                            await notificationFirstLaunch()
                            
                            navigationController.goToViewWithAnimation(.gameModeSelection, delay: 2.5, pauseLength: 0.5)
                        }
                    }
            case .gameModeSelection:
                GameModeSelectionView(gameModeSelectionVM)
                    .transition(.blurReplace)
            case .game:
                GameView(gameModeSelectionVM.getGameViewModel())
                    .transition(.blurReplace)
            default:
                Color.appBackground
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
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

#Preview {
    AppStartingView()
}
