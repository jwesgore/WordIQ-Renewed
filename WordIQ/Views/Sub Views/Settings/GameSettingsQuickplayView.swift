import SwiftUI

struct GameSettingsQuickplayView : View {
    
    @ObservedObject var viewModel : GameSettingsViewModel
    
    var body: some View {
        VStack (spacing: 5) {
            GameSettingsHeaderView(SystemNames.GameSettings.quickplaySettings)
            
            GroupBox {
                Text(SystemNames.GameSettings.gameMode)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Picker("Game Mode", selection: $viewModel.quickplayMode) {
                    Text(GameMode.standardgame.value).tag(GameMode.standardgame)
                    Text(GameMode.rushgame.value).tag(GameMode.rushgame)
                    Text(GameMode.frenzygame.value).tag(GameMode.frenzygame)
                    Text(GameMode.zengame.value).tag(GameMode.zengame)
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 8)
                
                Text(SystemNames.GameSettings.gameDifficulty)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
