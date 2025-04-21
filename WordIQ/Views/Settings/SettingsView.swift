import SwiftUI

/// View for the Game Settings
struct SettingsView : View {

    @Environment(\.modelContext) private var modelContext
    @State private var databaseHelper: GameDatabaseClient?
    
    @ObservedObject var viewModel: SettingsViewModel
    @State var clearDataAlertIsPresented: Bool = false
    
    var body: some View {
        
        ScrollView (showsIndicators: false) {
            VStack (spacing: 16.0) {
                // MARK: Gameplay Settings block
                SettingsView_Toggle(SystemNames.GameSettings.colorBlindMode, isActive: $viewModel.colorBlind)
                Divider()
                SettingsView_Toggle(SystemNames.GameSettings.showHints, isActive: $viewModel.showHints)
                Divider()
                SettingsView_Toggle(SystemNames.GameSettings.soundEffects, isActive: $viewModel.soundEffects)
                Divider()
                SettingsView_Toggle(SystemNames.GameSettings.hapticFeedback, isActive: $viewModel.hapticFeedback)
                Divider()
                
                // MARK: Notification Settings block
                SettingsView_Toggle(SystemNames.GameSettings.notifications, isActive: $viewModel.notificationsOn)
                if viewModel.notificationsOn {
                    GroupBox {
                        SettingsView_Toggle_DatePicker(SystemNames.GameSettings.dailyNotification1,
                                                             isActive: $viewModel.notificationsDaily1,
                                                             time: $viewModel.notificationsDaily1Time)
                        
                        Divider()
                        SettingsView_Toggle_DatePicker(SystemNames.GameSettings.dailyNotification2,
                                                             isActive: $viewModel.notificationsDaily2,
                                                             time: $viewModel.notificationsDaily2Time)
                    }
                    .backgroundStyle(Color.appGroupBox)
                }
     
                // MARK: Quickplay Settings block
                SettingsView_Quickplay(viewModel: viewModel)
                    .padding(.bottom, 4)
                
                // MARK: Clear Data Button
                Button {
                    clearDataAlertIsPresented = true
                } label: {
                    Text("Erase All Data")
                        .foregroundStyle(.red)
                        .robotoSlabFont(.title2, .regular)
                }
                .padding(.bottom, 32)
                
            }
            .padding(.bottom)
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color.appBackground)
        .onChange(of: viewModel.quickplayMode){
            viewModel.quickplayTimeLimit = viewModel.quickplayTimeLimitOptions.1
        }
        .alert(isPresented: $clearDataAlertIsPresented) {
            Alert(
                title: Text("Confirm Game Data Deletion"),
                message: Text("Are you sure you want to erase all game data? This action cannot be undone."),
                primaryButton: .destructive(Text("Erase")) {
                    databaseHelper = GameDatabaseClient(context: modelContext)
                    databaseHelper?.deleteAllData()
                    
                    UserDefaultsClient.shared.resetData()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

extension SettingsView {
    init() {
        self.viewModel = SettingsViewModel()
    }
}

#Preview {
    SettingsView()
}
