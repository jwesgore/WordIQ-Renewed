import SwiftUI

/// View Model for a game over screen
class FourWordGameOverViewModel : ObservableObject {
    
    // MARK: Constants
    let databaseHelper = GameDatabaseHelper()
    let functionButtonDimensions : (CGFloat, CGFloat) = (50, 400)
    
    // MARK: Stats Info Models
    @Published var firstRowStat = InfoItemModel()
    @Published var secondRowStat = InfoItemModel()
    @Published var thirdRowStat = InfoItemModel()
    @Published var fourthRowStat = InfoItemModel()
    
    // MARK: Button View Models
    var backButton : TopDownButtonViewModel
    var playAgainButton : TopDownButtonViewModel
    
    /// Initializer
    init() {
        self.backButton = TopDownButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1) {
            GameSelectionNavigationController.shared.exitFromGame()
        }
        self.playAgainButton = TopDownButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1) {
            MultiWordGameNavigationController.shared().goToGameView()
        }
    }
}
