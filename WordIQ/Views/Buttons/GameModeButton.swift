import SwiftUI

struct GameModeButton: View {
    
    @ObservedObject var threeDButtonVM : ThreeDButtonViewModel
    let gameMode : GameMode
    
    init(_ threeDButtonVM: ThreeDButtonViewModel, gameMode: GameMode) {
        self.threeDButtonVM = threeDButtonVM
        self.gameMode = gameMode
    }
    
    var body: some View {
        ThreeDButtonView(threeDButtonVM) {
            VStack {
                Text(gameMode.value)
                    .font(.custom(RobotoSlabOptions.Weight.bold, size: CGFloat(RobotoSlabOptions.Size.title2)))
                Text(gameMode.caption)
                    .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.caption)))
                    .opacity(0.6)
            }
        }
    }
}

//#Preview {
//    GameModeButton(threeDButtonVM: ThreeDButtonViewModel(height: 100, width: 300, action: {}), gameMode: .standardgame)
//}
