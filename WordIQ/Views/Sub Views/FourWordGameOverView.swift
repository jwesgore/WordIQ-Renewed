import SwiftUI

/// View that manages the end of a game
struct FourWordGameOverView : View {
    
    @ObservedObject var viewModel : FourWordGameOverViewModel
    @State var gameMode : GameMode
    
    var body : some View {
        VStack (spacing: 20) {
            Spacer()
            
            Text(viewModel.gameOverData.gameResult.gameOverString)
                .robotoSlabFont(.title, .bold)
            

            TopDownButtonView(viewModel.playAgainButton) {
                Text(SystemNames.Navigation.playAgain)
                    .robotoSlabFont(.title3, .regular)
            }
            
            TopDownButtonView(viewModel.backButton) {
                Text(SystemNames.Navigation.mainMenu)
                    .robotoSlabFont(.title3, .regular)
            }
        }
        .padding()
    }
}

extension FourWordGameOverView {
    init (_ viewModel: FourWordGameOverViewModel) {
        self.viewModel = viewModel
        self.gameMode = viewModel.gameOverData.gameMode
    }
}
