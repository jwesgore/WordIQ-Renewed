import SwiftUI

/// View for the user to select which game mode they would like to play
struct GameModeSelectionView: View {
    
    @ObservedObject var gameModelSelectionVM: GameModeSelectionViewModel

    var body: some View {
        VStack {
            HStack {
                Text(SystemNames.Title.title)
                    .font(.custom(RobotoSlabOptions.Weight.bold, size: CGFloat(RobotoSlabOptions.Size.title2)))
                Spacer()
                Button(action:{}) {
                    Image(systemName: SFAssets.stats)
                }
                .padding(.horizontal, 5)
                Button(action:{}) {
                    Image(systemName: SFAssets.settings)
                }
            }
            Spacer()
            ZStack {
                VStack (spacing: 10) {
                    HStack {
                        GameModeButton(gameModelSelectionVM.DailyGameButton, gameMode: .daily)
                        GameModeButton(gameModelSelectionVM.QuickplayGameButton, gameMode: .quickplay)
                    }
                    GameModeButton(gameModelSelectionVM.StandardGameModeButton, gameMode: .standardgame)
                    GameModeButton(gameModelSelectionVM.RushGameModeButton, gameMode: .rushgame)
                    GameModeButton(gameModelSelectionVM.FrenzyGameModeButton, gameMode: .frenzygame)
                    GameModeButton(gameModelSelectionVM.ZenGameModeButton, gameMode: .zengame)
                }
                .offset(CGSize(width: gameModelSelectionVM.Offset - 2000, height: 0))
                VStack (spacing: 10) {
                    VStack {
                        Text("Test")
                    }
                    Spacer()
                    VStack {
                        GameSelectionDifficultyButtonView(gameModelSelectionVM.EasyDifficultyButton, difficulty: .easy)
                        GameSelectionDifficultyButtonView(gameModelSelectionVM.NormalDifficultyButton, difficulty: .normal)
                        GameSelectionDifficultyButtonView(gameModelSelectionVM.HardDifficultyButton, difficulty: .hard)
                    }
                    if gameModelSelectionVM.TimeLimitOptions != (0,0,0) {
                        HStack {
                            GameSelectionTimeButtonView(gameModelSelectionVM.TimeSelection1Button, timeLimit: gameModelSelectionVM.TimeLimitOptions.0)
                            GameSelectionTimeButtonView(gameModelSelectionVM.TimeSelection2Button, timeLimit: gameModelSelectionVM.TimeLimitOptions.1)
                            GameSelectionTimeButtonView(gameModelSelectionVM.TimeSelection3Button, timeLimit: gameModelSelectionVM.TimeLimitOptions.2)
                        }
                    }
                    Spacer()
                    VStack {
                        Text("Test")
                    }
                }
                .offset(CGSize(width: gameModelSelectionVM.Offset, height: 0))
            }
            Spacer()
        }
        .padding()
    }
}
 
#Preview {
    GameModeSelectionView(gameModelSelectionVM: GameModeSelectionViewModel())
}
