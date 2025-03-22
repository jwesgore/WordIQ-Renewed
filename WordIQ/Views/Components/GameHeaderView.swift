import SwiftUI

struct GameHeaderView : View {
    
    let title : String
    
    var exitGame : () -> Void
    var pauseGame : () -> Void
    var clockViewModel: ClockViewModel
    
    var body: some View {
        HStack (spacing: 0) {
            Button {
                exitGame()
            } label: {
                Image(systemName: SFAssets.backArrow)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: RobotoSlabOptions.Size.title2.rawValue, maxHeight: RobotoSlabOptions.Size.title2.rawValue)
            }
            
            Spacer()
            VStack {
                Text(title)
                    .robotoSlabFont(.title3, .bold)
                       
                ClockView(clockVM: clockViewModel)
                    .robotoSlabFont(.title2, .regular)
                            
            }
            Spacer()
            
            Button {
                pauseGame()
            } label: {
                Image(systemName: SFAssets.pause)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: RobotoSlabOptions.Size.title2.rawValue, maxHeight: RobotoSlabOptions.Size.title2.rawValue)
            }
            
        }
    }
}

extension GameHeaderView {
    init (_ title : String, exitGame: @escaping () -> Void, pauseGame: @escaping () -> Void, clockViewModel: ClockViewModel) {
        self.title = title
        self.exitGame = exitGame
        self.pauseGame = pauseGame
        self.clockViewModel = clockViewModel
    }
    
    init (_ viewModel: SingleWordGameViewModel) {
        self.title = viewModel.gameOptions.gameMode.asStringShort
        self.exitGame = viewModel.exitGame
        self.pauseGame = viewModel.pauseGame
        self.clockViewModel = viewModel.clock
    }
}
