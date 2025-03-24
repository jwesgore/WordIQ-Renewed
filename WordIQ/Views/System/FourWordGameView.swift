import SwiftUI

struct FourWordGameView : View {
    
    @ObservedObject var viewModel : FourWordGameViewModel
    
    var body: some View {

        VStack (spacing: 0) {
            
            GameHeaderView(viewModel)

            Spacer()
            
            FourWordGameBoardView(viewModel.gameBoardViewModel)
            
            Spacer()
            
            KeyboardView(viewModel.keyboardViewModel)
        }
    }
}

extension FourWordGameView {
    init (_ viewModel : FourWordGameViewModel) {
        self.viewModel = viewModel
    }
}



#Preview {
    FourWordGameView(FourWordGameViewModel(gameOptions: FourWordGameModeOptionsModel()))
}
