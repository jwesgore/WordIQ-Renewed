import SwiftUI

struct GameSettingsGameplayView : View {
    
    @ObservedObject var viewModel : GameSettingsViewModel
    
    var body: some View {
        VStack (spacing: 5) {
            GameSettingsHeaderView(SystemNames.GameSettings.generalSettings)
            
            GroupBox {
                GameSettingsToggle(SystemNames.GameSettings.colorBlindMode, isActive: $viewModel.colorBlind)
                Divider()
                GameSettingsToggle(SystemNames.GameSettings.showHints, isActive: $viewModel.showHints)
                Divider()
                GameSettingsToggle(SystemNames.GameSettings.soundEffects, isActive: $viewModel.soundEffects)
                Divider()
                GameSettingsToggle(SystemNames.GameSettings.hapticFeedback, isActive: $viewModel.hapticFeedback)
            }
            .backgroundStyle(Color.appGroupBox)
        }
    }
}
