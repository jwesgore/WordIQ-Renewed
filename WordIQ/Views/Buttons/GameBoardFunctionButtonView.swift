import SwiftUI

/// Struct used for back and pause buttons
struct GameBoardFunctionButtonView : View {
    var image: SFAssets
    var viewModel: TopDownButtonViewModel
    
    init (_ viewModel: TopDownButtonViewModel, image: SFAssets) {
        self.viewModel = viewModel
        self.image = image
        
        self.viewModel.cornerRadius = 10.0
    }
    
    var body: some View {
        TopDownButtonView (viewModel) {
            Image(systemName: image.rawValue)
                .resizable()
                .scaledToFit()
                .padding(5)
        }
    }
}
