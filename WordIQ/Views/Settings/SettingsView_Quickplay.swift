import SwiftUI

/// View for the quickplay settings
struct SettingsView_Quickplay : View {
    
    @ObservedObject var viewModel : SettingsViewModel
    @State var showSettings = true
    
    var body: some View {
        VStack (spacing: 16.0) {
            Text("Quickplay")
                .robotoSlabFont(.title2, .semiBold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            GroupBox {
                Text(SystemNames.GameSettings.gameMode)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .robotoSlabFont(.headline, .regular)
                
                Picker("Game Mode", selection: $viewModel.quickplayMode) {
                    Text(GameMode.standardMode.asStringShort).tag(GameMode.standardMode)
                    Text(GameMode.rushMode.asStringShort).tag(GameMode.rushMode)
                    Text(GameMode.frenzyMode.asStringShort).tag(GameMode.frenzyMode)
                    Text(GameMode.zenMode.asStringShort).tag(GameMode.zenMode)
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 8)
                
                Text(SystemNames.GameSettings.gameDifficulty)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .robotoSlabFont(.headline, .regular)
                
                Picker("Difficulty", selection: $viewModel.quickplayDifficulty) {
                    Text(GameDifficulty.easy.asString).tag(GameDifficulty.easy)
                    Text(GameDifficulty.normal.asString).tag(GameDifficulty.normal)
                    Text(GameDifficulty.hard.asString).tag(GameDifficulty.hard)
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 8)
                
                // Show Quickplay time limit options only if mode had time limit
                if viewModel.showTimeLimitOptions {
                    VStack (spacing: 5) {
                        Text(SystemNames.GameSettings.gameTimeLimit)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .robotoSlabFont(.headline, .regular)
                        
                        Picker("Time", selection: $viewModel.quickplayTimeLimit) {
                            Text(TimeUtility.formatTimeShort(viewModel.quickplayTimeLimitOptions.0)).tag(viewModel.quickplayTimeLimitOptions.0)
                            Text(TimeUtility.formatTimeShort(viewModel.quickplayTimeLimitOptions.1)).tag(viewModel.quickplayTimeLimitOptions.1)
                            Text(TimeUtility.formatTimeShort(viewModel.quickplayTimeLimitOptions.2)).tag(viewModel.quickplayTimeLimitOptions.2)
                        }
                        .pickerStyle(.segmented)
                    }
                }
            }
            .backgroundStyle(Color.appGroupBox)
        }
    }
}
