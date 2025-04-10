import SwiftUI

/// View for the Game Settings
struct GameSettingsView : View {

    @Environment(\.modelContext) private var modelContext
    @State private var databaseHelper: GameDatabaseHelper?
    
    @ObservedObject var gameSettingsVM: GameSettingsViewModel
    @Binding var isPresented: Bool
    @State var clearDataAlertIsPresented: Bool = false
    
    var body: some View {
        VStack {
            // MARK: Top Row Header and Done Button
            HeaderWithDoneButtonView(title: SystemNames.GameSettings.settings, isPresented: $isPresented)
                .padding(.horizontal)
                .padding(.vertical, 5)
        
            ScrollView {
                VStack {
                    // MARK: Gameplay Settings block
                    GameSettingsGameplayView(viewModel: gameSettingsVM)
                        .padding(.bottom, 5)
                    
                    // MARK: Notification Settings block
                    GameSettingsNotificationsView(viewModel: gameSettingsVM)
                        .padding(.bottom, 5)
                    
                    // MARK: Quickplay Settings block
                    GameSettingsQuickplayView(viewModel: gameSettingsVM)
                        .padding(.bottom, 5)
                    
                    // MARK: Clear Data Button
                    Button {
                        clearDataAlertIsPresented = true
                    } label: {
                        Text("Erase All Data")
                            .foregroundStyle(.red)
                            .robotoSlabFont(.title3, .regular)
                    }
                    .padding(.vertical, 20)
                    
                }
                .padding([.horizontal, .bottom])
            }
        }
        .robotoSlabFont(.headline, .semiBold)
        .ignoresSafeArea(edges: .bottom)
        .background(Color.appBackground)
        .onChange(of: gameSettingsVM.quickplayMode){
            gameSettingsVM.quickplayTimeLimit = gameSettingsVM.quickplayTimeLimitOptions.1
        }
        .alert(isPresented: $clearDataAlertIsPresented) {
            Alert(
                title: Text("Confirm Game Data Deletion"),
                message: Text("Are you sure you want to erase all game data? This action cannot be undone."),
                primaryButton: .destructive(Text("Erase")) {
                    databaseHelper = GameDatabaseHelper(context: modelContext)
                    databaseHelper?.deleteAllData()
                    
                    UserDefaultsHelper.shared.resetData()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

extension GameSettingsView {
    init(isPresented: Binding<Bool>) {
        self.gameSettingsVM = GameSettingsViewModel()
        self._isPresented = isPresented
    }
}

#Preview {
    GameSettingsView(isPresented: .constant(true))
}
