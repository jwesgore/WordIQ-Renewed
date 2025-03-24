import SwiftUI

/// View for the user to select which game mode they would like to play
struct GameModeSelectionView: View {
    
    @ObservedObject var navigationController: GameSelectionNavigationController
    @ObservedObject var gameModeSelectionVM: GameModeSelectionViewModel
    
    @State var slideForward = false

    var body: some View {
        VStack {
            AppHeaderView(displayStats: $gameModeSelectionVM.DisplayStats, displaySettings: $gameModeSelectionVM.DisplaySettings)
                .padding(.bottom)
            
            ZStack {
                switch navigationController.activeView {
                case .gameModeSelection:
                    VStack (spacing: 14) {
                        HStack {
                            GameModeButton(gameModeSelectionVM.DailyGameButton, gameMode: .dailyGame)
                            GameModeButton(gameModeSelectionVM.QuickplayGameButton, gameMode: .quickplay)
                        }
                        GameModeButton(gameModeSelectionVM.StandardGameModeButton, gameMode: .standardMode)
                        GameModeButton(gameModeSelectionVM.RushGameModeButton, gameMode: .rushMode)
                        GameModeButton(gameModeSelectionVM.FrenzyGameModeButton, gameMode: .frenzyMode)
                        GameModeButton(gameModeSelectionVM.ZenGameModeButton, gameMode: .zenMode)
                        GameModeButton(gameModeSelectionVM.FourWordGameModeButton, gameMode: .quadWordMode)
                        
                        Spacer()
                    }
                    .transition(.dynamicSlide(forward: $slideForward))
                    .onAppear {
                        slideForward.toggle()
                    }
                    
                case .gameModeSelectionOptions:
                    GameModeOptionsView(gameModeSelectionVM)
                        .transition(.dynamicSlide(forward: $slideForward))
                        .onAppear {
                            slideForward.toggle()
                        }
                    
                default:
                    Color.appBackground
                }
            }
        }
        .padding()
        .background(Color.appBackground.ignoresSafeArea())
        .fullScreenCover(isPresented: $gameModeSelectionVM.DisplaySettings) {
            GameSettingsView(isPresented: $gameModeSelectionVM.DisplaySettings)
        }
        .fullScreenCover(isPresented: $gameModeSelectionVM.DisplayStats) {
            StatsView(isPresented: $gameModeSelectionVM.DisplayStats)
        }
    }
}

/// Simple init
extension GameModeSelectionView {
    init(_ gameModeSelectionVM: GameModeSelectionViewModel) {
        self.navigationController = GameSelectionNavigationController.shared
        self.gameModeSelectionVM = gameModeSelectionVM
    }
}
 
#Preview {
    GameModeSelectionView(GameModeSelectionViewModel())
}
