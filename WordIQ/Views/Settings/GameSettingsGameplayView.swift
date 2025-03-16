import SwiftUI

struct GameSettingsGameplayView : View {
    
    @ObservedObject var viewModel : GameSettingsViewModel
    @State var showSettings = true
    
    var body: some View {
        VStack (spacing: StatsViewHelper.vStackSpacing) {
            ExpandAndCollapseHeaderView(SystemNames.GameSettings.generalSettings, isExpanded: $showSettings)
                .padding(.vertical, StatsViewHelper.baseHeaderPadding)
                .padding(.bottom, showSettings ? StatsViewHelper.additionalHeaderPadding : 0)
            
            if showSettings {
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
}
