import SwiftUI

/// View that manages the end of a game
struct FourWordGameOverView : View {
    
    @ObservedObject var viewModel : FourWordGameOverViewModel
    var gameOverData : FourWordGameOverDataModel
    
    var body : some View {
        VStack (spacing: 20) {
            Spacer()
            
            Text(gameOverData.gameResult.gameOverString)
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
    init (_ gameOverData: FourWordGameOverDataModel) {
        self.viewModel = MultiWordGameNavigationController.shared().multiWordGameOverViewModel
        self.gameOverData = gameOverData
    }
}
