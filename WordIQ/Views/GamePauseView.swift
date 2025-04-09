import SwiftUI

/// View for game pause menu
struct GamePauseView : View {
    
    var clock : ClockViewModel
    var options : GameOptionsBase
    var viewModel : GamePauseViewModel
    
    var body: some View {
        VStack (spacing: 20) {
            
            Text(SystemNames.GamePause.title)
                .robotoSlabFont(.title, .bold)
            
            HStack {
                Spacer()
                
                GamePauseInfoView(title: "Time", value: TimeUtility.formatTimeShort(clock.timeElapsed))
                
                Spacer()
                
                GamePauseInfoView(title: "Test", value: "Test")
                
                Spacer()
                
                GamePauseInfoView(title: SystemNames.GameSettings.gameDifficulty, value: options.gameDifficulty.asString)
                
                Spacer()
            }
            
            // MARK: Buttons
            ThreeDButtonView(viewModel.ResumeGameButton) {
                Text(SystemNames.GamePause.resumeGame)
                    .robotoSlabFont(.title3, .regular)
            }
            
        }
        .padding()
        .background(Color.appBackground)
    }
}

extension GamePauseView {
    init (_ viewModel: SingleBoardGameViewModel) {
        self.clock = viewModel.clockViewModel
        self.options = viewModel.gameOptionsModel
        self.viewModel = GamePauseViewModel()
        self.viewModel.ResumeGameButton.action = viewModel.resumeGame
        self.viewModel.EndGameButton.action = viewModel.exitGame
    }
    
    init (_ viewModel: FourWordGameViewModel) {
        self.clock = viewModel.clockViewModel
        self.options = viewModel.gameOptionsModel
        self.viewModel = GamePauseViewModel()
        self.viewModel.ResumeGameButton.action = viewModel.resumeGame
        self.viewModel.EndGameButton.action = viewModel.exitGame
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

//#Preview {
//    GamePauseView(
//        SingleWordGameViewModel(gameOptions:
//            SingleWordGameModeOptionsModel(gameMode: .standardMode, gameDifficulty: .easy, timeLimit: 0)))
//}
