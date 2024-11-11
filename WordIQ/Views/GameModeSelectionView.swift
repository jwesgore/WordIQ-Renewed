import SwiftUI

/// View for the user to select which game mode they would like to play
struct GameModeSelectionView: View {
    
    @ObservedObject var gameModeSelectionVM: GameModeSelectionViewModel
    
    init() {
        self.gameModeSelectionVM = GameModeSelectionViewModel()
    }

    var body: some View {
        switch gameModeSelectionVM.activeView {
        case .root:
            VStack {
                HStack {
                    Text(SystemNames.Title.title)
                        .font(.custom(RobotoSlabOptions.Weight.bold, size: CGFloat(RobotoSlabOptions.Size.title2)))
                    Spacer()
                    Button(action:{}) {
                        Image(systemName: SFAssets.stats)
                    }
                    .padding(.horizontal, 5)
                    Button(action:{
                        gameModeSelectionVM.DisplaySettings = true
                    }) {
                        Image(systemName: SFAssets.settings)
                    }
                }
                Spacer()
                ZStack {
                    VStack (spacing: 10) {
                        HStack {
                            GameModeButton(gameModeSelectionVM.DailyGameButton, gameMode: .daily)
                            GameModeButton(gameModeSelectionVM.QuickplayGameButton, gameMode: .quickplay)
                        }
                        GameModeButton(gameModeSelectionVM.StandardGameModeButton, gameMode: .standardgame)
                        GameModeButton(gameModeSelectionVM.RushGameModeButton, gameMode: .rushgame)
                        GameModeButton(gameModeSelectionVM.FrenzyGameModeButton, gameMode: .frenzygame)
                        GameModeButton(gameModeSelectionVM.ZenGameModeButton, gameMode: .zengame)
                    }
                    .offset(CGSize(width: gameModeSelectionVM.Offset - 2000, height: 0))
                    
                    GameModeOptionsView(gameModeSelectionVM)
                        .offset(CGSize(width: gameModeSelectionVM.Offset, height: 0))
                }
                Spacer()
            }
            .padding()
            .transition(.blurReplace)
            .sheet(isPresented: $gameModeSelectionVM.DisplaySettings) {
                GameSettingsView()
            }
        case .target:
            ZStack{
                GameView(gameModeSelectionVM.getGameViewModel())
            }
            .transition(.blurReplace)
        case .blank:
            Color.white
        }
    }
}
 
#Preview {
    GameModeSelectionView()
}
