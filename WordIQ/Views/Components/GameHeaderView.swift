import SwiftUI

struct GameHeaderView : View {
    
    let title : String
    
    var exitGame : () -> Void
    var pauseGame : () -> Void
    
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
            Text(title)
                .font(.custom(RobotoSlabOptions.Weight.bold, fixedSize: CGFloat(RobotoSlabOptions.Size.title3)))
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
    init (_ title : String, exitGame: @escaping () -> Void, pauseGame: @escaping () -> Void) {
        self.title = title
        self.exitGame = exitGame
        self.pauseGame = pauseGame
    }
}
