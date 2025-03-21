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
                    .frame(maxWidth: CGFloat(RobotoSlabOptions.Size.title2), maxHeight: CGFloat(RobotoSlabOptions.Size.title2))
            }
            
            Spacer()
            VStack {
                Text(title)
                    .font(.custom(RobotoSlabOptions.Weight.bold, fixedSize: CGFloat(RobotoSlabOptions.Size.title3)))
                       
                ClockView(clockVM: clockViewModel)
                    .font(.custom(RobotoSlabOptions.Weight.regular, fixedSize: CGFloat(RobotoSlabOptions.Size.title2)))
                            
            }
            Spacer()
            
            Button {
                pauseGame()
            } label: {
                Image(systemName: SFAssets.pause)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: CGFloat(RobotoSlabOptions.Size.title2), maxHeight: CGFloat(RobotoSlabOptions.Size.title2))
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
