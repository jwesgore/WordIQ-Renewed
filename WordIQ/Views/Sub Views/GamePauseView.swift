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
                .robotoSlabFont(.title, .bold)
            
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
                    .robotoSlabFont(.title3, .regular)
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
                .robotoSlabFont(.headline, .regular)
                .foregroundStyle(.secondary)
            Text(value)
                .robotoSlabFont(.title2, .semiBold)
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    GamePauseView(
        SingleWordGameViewModel(gameOptions:
            SingleWordGameModeOptionsModel(gameMode: .standardMode, gameDifficulty: .easy, timeLimit: 0)))
}
