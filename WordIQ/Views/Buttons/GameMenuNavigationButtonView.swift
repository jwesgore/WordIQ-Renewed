import SwiftUI

struct GameMenuNavigationButtonView: View {
    
    var image: SFAssets
    var viewModel: TopDownRadioButtonViewModel
    
    init (_ viewModel: TopDownRadioButtonViewModel, image: SFAssets) {
        self.viewModel = viewModel
        self.image = image
        
        self.viewModel.cornerRadius = 8.0
    }
    
    var body: some View {
        TopDownRadioButtonView (viewModel) {
            Image(systemName: image.rawValue)
                .resizable()
                .scaledToFit()
                .padding(5)
        }
    }
}
