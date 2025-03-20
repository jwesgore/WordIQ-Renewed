import SwiftUI

/// View for the user to select which game mode they would like to play
struct GameModeSelectionView: View {
    
    @ObservedObject var gameModeSelectionVM: GameModeSelectionViewModel

    var body: some View {
        VStack {
            
            AppHeaderView(displayStats: $gameModeSelectionVM.DisplayStats, displaySettings: $gameModeSelectionVM.DisplaySettings)
                .padding()
            
            ZStack {
                VStack (spacing: 14) {
                    
                    HStack {
                        GameModeButton(gameModeSelectionVM.DailyGameButton, gameMode: .dailyGame)
                        GameModeButton(gameModeSelectionVM.QuickplayGameButton, gameMode: .quickplay)
                    }
                    GameModeButton(gameModeSelectionVM.StandardGameModeButton, gameMode: .standardMode)
                    GameModeButton(gameModeSelectionVM.RushGameModeButton, gameMode: .rushMode)
                    GameModeButton(gameModeSelectionVM.FrenzyGameModeButton, gameMode: .frenzyMode)
                    GameModeButton(gameModeSelectionVM.ZenGameModeButton, gameMode: .zenMode)
                    
                    Spacer()
                }
                .offset(CGSize(width: gameModeSelectionVM.Offset - 2000, height: 0))
                
                GameModeOptionsView(gameModeSelectionVM)
                    .offset(CGSize(width: gameModeSelectionVM.Offset, height: 0))
            }
            .padding()
            
            
            
        }
        .transition(.blurReplace)
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
        self.gameModeSelectionVM = gameModeSelectionVM
    }
}
 
#Preview {
    GameModeSelectionView(GameModeSelectionViewModel(NavigationController()))
}
