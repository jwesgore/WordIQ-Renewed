import SwiftUI

struct GameSettingsView : View {
    
    @ObservedObject var gameSettingsVM: GameSettingsViewModel
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self.gameSettingsVM = GameSettingsViewModel()
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(SystemNames.GameSettings.settings)
                    .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title1)))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                Button(action: {
                    self.isPresented.toggle()
                }, label: {
                    Text("Done")
                })
            }
            
            VStack {
                Text(SystemNames.GameSettings.gameplaySettings)
                    .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title2)))
                    .frame(maxWidth: .infinity, alignment: .leading)
                GroupBox {
                    GameSettingsToggle(SystemNames.GameSettings.colorBlindMode, isActive: gameSettingsVM.colorBlind)
                    Divider()
                    GameSettingsToggle(SystemNames.GameSettings.showHints, isActive: gameSettingsVM.showHints)
                    Divider()
                    GameSettingsToggle(SystemNames.GameSettings.soundEffects, isActive: gameSettingsVM.soundEffects)
                    Divider()
                    GameSettingsToggle(SystemNames.GameSettings.tapticFeedback, isActive: gameSettingsVM.tapticFeedback)
                }
            }
            .padding(.bottom)
            
            VStack (spacing: 5) {
                Text(SystemNames.GameSettings.quickplaySettings)
                    .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title2)))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 8)
                GroupBox {
                    Text(SystemNames.GameSettings.gameMode)
                        .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.headline)))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Picker("Game Mode", selection: $gameSettingsVM.quickplayMode) {
                        Text(GameMode.standardgame.value).tag(GameMode.standardgame)
                        Text(GameMode.rushgame.value).tag(GameMode.rushgame)
                        Text(GameMode.frenzygame.value).tag(GameMode.frenzygame)
                        Text(GameMode.zengame.value).tag(GameMode.zengame)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 8)
                    
                    Text(SystemNames.GameSettings.gameDifficulty)
                        .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.headline)))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Picker("Difficulty", selection: $gameSettingsVM.quickplayDifficulty) {
                        Text(GameDifficulty.easy.asString).tag(GameDifficulty.easy)
                        Text(GameDifficulty.normal.asString).tag(GameDifficulty.normal)
                        Text(GameDifficulty.hard.asString).tag(GameDifficulty.hard)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 8)
                    
                    if gameSettingsVM.showTimeLimitOptions {
                        VStack (spacing: 5) {
                            Text(SystemNames.GameSettings.gameTimeLimit)
                                .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.headline)))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Picker("Time", selection: $gameSettingsVM.quickplayTimeLimit) {
                                Text(formatTimeShort(gameSettingsVM.quickplayTimeLimitOptions.0)).tag(gameSettingsVM.quickplayTimeLimitOptions.0)
                                Text(formatTimeShort(gameSettingsVM.quickplayTimeLimitOptions.1)).tag(gameSettingsVM.quickplayTimeLimitOptions.1)
                                Text(formatTimeShort(gameSettingsVM.quickplayTimeLimitOptions.2)).tag(gameSettingsVM.quickplayTimeLimitOptions.2)
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                }
                Spacer()
            }
        }
        .padding()
    }
    
    func formatTimeShort(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

private struct GameSettingsToggle : View {
    
    var label: String
    @State var isActive: Bool
    
    init(_ label: String, isActive: Bool) {
        self.label = label
        self.isActive = isActive
    }
    
    var body: some View {
        Toggle(label, isOn: $isActive)
            .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.title3)))
            .tint(.gray)
    }
}

#Preview {
    GameSettingsView(isPresented: .constant(true))
}
