import SwiftUI

/// View for game pause menu
struct GamePauseView : View {
    
    var options: GameOptionsBase
    @ObservedObject var viewModel: GameHeaderViewModel
    
    var body: some View {
        VStack (spacing: 20) {
            
            Text(SystemNames.GamePause.title)
                .robotoSlabFont(.title, .bold)
            
            HStack {
                Spacer()
                
                GamePauseInfoView(title: "Time", value: TimeUtility.formatTimeShort(viewModel.clockViewModel.timeElapsed))
                
                Spacer()
                
                GamePauseInfoView(title: "Test", value: "Test")
                
                Spacer()
                
                GamePauseInfoView(title: SystemNames.GameSettings.gameDifficulty, value: options.gameDifficulty.asString)
                
                Spacer()
            }
            
            // MARK: Buttons
            TopDownButtonView(viewModel.resumeGameButton) {
                Text(SystemNames.GamePause.resumeGame)
                    .robotoSlabFont(.title3, .regular)
            }
            
        }
        .padding()
        .background(Color.appBackground)
    }
}

extension GamePauseView {
    init (_ viewModel: SingleBoardGameViewModel<GameBoardViewModel>) {
        self.options = viewModel.gameOptionsModel
        self.viewModel = viewModel.gameHeaderViewModel
    }
    
    init (_ viewModel: FourWordGameViewModel) {
        self.options = viewModel.gameOptionsModel
        self.viewModel = viewModel.gameHeaderViewModel
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
