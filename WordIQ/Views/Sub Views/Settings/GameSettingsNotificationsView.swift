import SwiftUI

struct GameSettingsNotificationsView : View {
    
    @ObservedObject var viewModel : GameSettingsViewModel
    
    var body: some View {
        VStack (spacing: 5) {
            GameSettingsHeaderView(SystemNames.GameSettings.notificationSettings)
            GroupBox {
                GameSettingsToggle(SystemNames.GameSettings.notifications, isActive: $viewModel.notificationsOn)
                if viewModel.notificationsOn {
                    Divider()
                    GameSettingsToggleWithDatePickerView(SystemNames.GameSettings.dailyNotification1,
                                                         isActive: $viewModel.notificationsDaily1,
                                                         time: $viewModel.notificationsDaily1Time)
                    
                    Divider()
                    GameSettingsToggleWithDatePickerView(SystemNames.GameSettings.dailyNotification2,
                                                         isActive: $viewModel.notificationsDaily2,
                                                         time: $viewModel.notificationsDaily2Time)
                }
            }
            .backgroundStyle(Color.appGroupBox)
        }
    }
}
