import SwiftUI

struct GamePauseView : View {
    
    @ObservedObject var gameViewModel : SingleWordGameViewModel
    var gamePauseViewModel : GamePauseViewModel
    
    init (_ gameViewModel: SingleWordGameViewModel) {
        self.gameViewModel = gameViewModel
        self.gamePauseViewModel = GamePauseViewModel()
        self.gamePauseViewModel.ResumeGameButton.action = gameViewModel.resumeGame
        self.gamePauseViewModel.EndGameButton.action = gameViewModel.exitGame
    }
    
    var body: some View {
        VStack (spacing: 20) {
            
            Text(SystemNames.GamePause.title)
                .font(.custom(RobotoSlabOptions.Weight.bold, fixedSize: CGFloat(RobotoSlabOptions.Size.title)))
            
            HStack {
                Spacer()
                
                GamePauseInfoView(title: "Time", value: TimeUtility.formatTimeShort(gameViewModel.clock.timeElapsed))
                
                Spacer()
                
                GamePauseInfoView(title: "Test", value: "Test")
                
                Spacer()
                
                GamePauseInfoView(title: SystemNames.GameSettings.gameDifficulty, value: gameViewModel.gameOptions.gameDifficulty.asString)
                
                Spacer()
            }
            
            // MARK: Buttons
            ThreeDButtonView(gamePauseViewModel.ResumeGameButton) {
                Text(SystemNames.GamePause.resumeGame)
                    .font(.custom(RobotoSlabOptions.Weight.regular, fixedSize: CGFloat(RobotoSlabOptions.Size.title3)))
            }
            
        }
        .padding()
        .background(Color.appBackground)
    }
}

struct GamePauseInfoView: View {
    
    var title: String
    var value: String
    
    var body: some View {
        VStack{
            Text(title)
                .font(.custom(RobotoSlabOptions.Weight.regular, fixedSize: CGFloat(RobotoSlabOptions.Size.headline)))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.custom(RobotoSlabOptions.Weight.semiBold, fixedSize: CGFloat(RobotoSlabOptions.Size.title2)))
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    GamePauseView(
        SingleWordGameViewModel(gameOptions:
            GameModeOptionsModel(gameMode: .standardMode, gameDifficulty: .easy, timeLimit: 0)))
}
