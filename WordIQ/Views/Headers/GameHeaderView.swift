import SwiftUI

struct GameHeaderView : View {
    
    let title : String
    var viewModel: GameHeaderViewModel

    var body: some View {
        HStack (spacing: 0) {
            GameBoardFunctionButtonView(viewModel.exitGameButton, image: .backArrow)

            Spacer()
            VStack {
                Text(title)
                    .robotoSlabFont(.title3, .bold)
                       
                ClockView(clockVM: viewModel.clockViewModel)
                    .robotoSlabFont(.title2, .regular)
                            
            }
            Spacer()
            
            GameBoardFunctionButtonView(viewModel.pauseGameButton , image: .pause)
        }
    }
}

extension GameHeaderView {
    init (_ viewModel: any SingleBoardGame) {
        self.title = viewModel.gameOptionsModel.gameMode.asStringShort
        self.viewModel = viewModel.gameHeaderViewModel
    }
    
    init (_ viewModel: any MultiBoardGame) {
        self.title = viewModel.gameOptionsModel.gameMode.asStringShort
        self.viewModel = viewModel.gameHeaderViewModel
    }
}
