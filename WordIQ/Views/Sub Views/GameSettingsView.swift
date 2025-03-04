import SwiftUI

struct GameSettingsView : View {

    @Environment(\.managedObjectContext) private var viewContext
    @State private var databaseHelper: GameDatabaseHelper?
    
    @ObservedObject var gameSettingsVM: GameSettingsViewModel
    @Binding var isPresented: Bool
    @State var clearDataAlertIsPresented: Bool = false
    
    init(isPresented: Binding<Bool>) {
        self.gameSettingsVM = GameSettingsViewModel()
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack {
            // MARK: Top Row Header and Done Button
            HStack {
                Text(SystemNames.GameSettings.settings)
                    .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title1)))
                    .frame(maxWidth: .infinity, alignment: .leading)
              
                Button(action: {
                    self.isPresented.toggle()
                }, label: {
                    Text("Done")
                        .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.headline)))
                })
            }
        
            VStack {
                // MARK: Gameplay Settings block
                VStack {
                    GroupBox {
                        GameSettingsToggle(SystemNames.GameSettings.colorBlindMode, isActive: $gameSettingsVM.colorBlind)
                        Divider()
                        GameSettingsToggle(SystemNames.GameSettings.showHints, isActive: $gameSettingsVM.showHints)
                        Divider()
                        GameSettingsToggle(SystemNames.GameSettings.soundEffects, isActive: $gameSettingsVM.soundEffects)
                        Divider()
                        GameSettingsToggle(SystemNames.GameSettings.hapticFeedback, isActive: $gameSettingsVM.tapticFeedback)
                    }
                    .backgroundStyle(Color.appGroupBox)
                }
                .padding(.bottom, 5)
                
                // MARK: Quickplay Settings block
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
                        
                        // Show Quickplay time limit options only if mode had time limit
                        if gameSettingsVM.showTimeLimitOptions {
                            VStack (spacing: 5) {
                                Text(SystemNames.GameSettings.gameTimeLimit)
                                    .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.headline)))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Picker("Time", selection: $gameSettingsVM.quickplayTimeLimit) {
                                    Text(TimeUtility.formatTimeShort(gameSettingsVM.quickplayTimeLimitOptions.0)).tag(gameSettingsVM.quickplayTimeLimitOptions.0)
                                    Text(TimeUtility.formatTimeShort(gameSettingsVM.quickplayTimeLimitOptions.1)).tag(gameSettingsVM.quickplayTimeLimitOptions.1)
                                    Text(TimeUtility.formatTimeShort(gameSettingsVM.quickplayTimeLimitOptions.2)).tag(gameSettingsVM.quickplayTimeLimitOptions.2)
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                    }
                    .backgroundStyle(Color.appGroupBox)
                }
                
                // MARK: Clear Data Button
                Spacer()
                Button(
                    action: {
                        clearDataAlertIsPresented = true
                    },
                    label: {
                        Text("Erase All Data")
                            .foregroundStyle(.red)
                            .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.title3)))
                    }
                )
            }
        }
        .padding()
        .background(Color.appBackground)
        .onChange(of: gameSettingsVM.quickplayMode){
            gameSettingsVM.quickplayTimeLimit = gameSettingsVM.quickplayTimeLimitOptions.1
        }
        .alert(isPresented: $clearDataAlertIsPresented) {
            Alert(
                title: Text("Confirm Game Data Deletion"),
                message: Text("Are you sure you want to erase all game data? This action cannot be undone."),
                primaryButton: .destructive(Text("Erase")) {
                    databaseHelper = GameDatabaseHelper(context: viewContext)
                    databaseHelper?.deleteAllData()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

private struct GameSettingsToggle : View {
    
    var label: String
    @Binding var isActive: Bool
    
    init(_ label: String, isActive: Binding<Bool>) {
        self.label = label
        self._isActive = isActive
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
