import SwiftUI

struct AppHeaderView : View {
    
    @ObservedObject var viewModel: GameModeSelectionViewModel
    
    var body : some View {
        HStack {
            Text(SystemNames.Title.title)
                .robotoSlabFont(.title2, .bold)
            Spacer()
            
            GameMenuNavigationButtonView(viewModel.mainMenuRadioButton, image: .home)
            GameMenuNavigationButtonView(viewModel.statsRadioButton, image: .stats)
            GameMenuNavigationButtonView(viewModel.settingsRadioButton, image: .settings)
            
        }
    }
}
