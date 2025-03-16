import SwiftUI

/// View for the user to select which game mode they would like to play
struct GameModeSelectionView: View {
    
    @ObservedObject var gameModeSelectionVM: GameModeSelectionViewModel

    var body: some View {
        VStack {
            // MARK: Header
            HStack {
                Text(SystemNames.Title.title)
                    .font(.custom(RobotoSlabOptions.Weight.bold, fixedSize: CGFloat(RobotoSlabOptions.Size.title2)))
                Spacer()
                Button{
                    gameModeSelectionVM.DisplayStats = true
                } label: {
                    Image(systemName: SFAssets.stats)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: CGFloat(RobotoSlabOptions.Size.title2))
                }
                .padding(.horizontal, 5)
                Button {
                    gameModeSelectionVM.DisplaySettings = true
                } label: {
                    Image(systemName: SFAssets.settings)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: CGFloat(RobotoSlabOptions.Size.title2))
                }
            }
            Spacer()
            
            // MARK: Buttons
            ZStack {
                VStack (spacing: 10) {
                    HStack {
                        GameModeButton(gameModeSelectionVM.DailyGameButton, gameMode: .dailyGame)
                        GameModeButton(gameModeSelectionVM.QuickplayGameButton, gameMode: .quickplay)
                    }
                    GameModeButton(gameModeSelectionVM.StandardGameModeButton, gameMode: .standardMode)
                    GameModeButton(gameModeSelectionVM.RushGameModeButton, gameMode: .rushMode)
                    GameModeButton(gameModeSelectionVM.FrenzyGameModeButton, gameMode: .frenzyMode)
                    GameModeButton(gameModeSelectionVM.ZenGameModeButton, gameMode: .zenMode)
                    
                }
                .offset(CGSize(width: gameModeSelectionVM.Offset - 2000, height: 0))
                
                GameModeOptionsView(gameModeSelectionVM)
                    .offset(CGSize(width: gameModeSelectionVM.Offset, height: 0))
            }
            Spacer()
        }
        .padding()
        .transition(.blurReplace)
        .fullScreenCover(isPresented: $gameModeSelectionVM.DisplaySettings) {
            GameSettingsView(isPresented: $gameModeSelectionVM.DisplaySettings)
        }
        .fullScreenCover(isPresented: $gameModeSelectionVM.DisplayStats) {
            StatsView(isPresented: $gameModeSelectionVM.DisplayStats)
        }
    }
}

extension GameModeSelectionView {
    init(_ gameModeSelectionVM: GameModeSelectionViewModel) {
        self.gameModeSelectionVM = gameModeSelectionVM
    }
}
 
#Preview {
    GameModeSelectionView(GameModeSelectionViewModel(NavigationController()))
}
