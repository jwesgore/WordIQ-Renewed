import SwiftUI

/// View Model for a game over screen
class FourWordGameOverViewModel : ObservableObject {
    
    // MARK: Constants
    let databaseHelper = GameDatabaseHelper()
    let functionButtonDimensions : (CGFloat, CGFloat) = (50, 400)
    
    private let extraPlayAgainAction : () -> Void
    private let extraGameOverAction : () -> Void
    
    // MARK: Stats Info Models
    @Published var firstRowStat = InfoItemModel()
    @Published var secondRowStat = InfoItemModel()
    @Published var thirdRowStat = InfoItemModel()
    @Published var fourthRowStat = InfoItemModel()
    
    // MARK: Button View Models
    lazy var backButton: TopDownButtonViewModel = {
        TopDownButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1) {
            self.extraGameOverAction()
            AppNavigationController.shared.exitFromFourWordGame()
        }
    }()
    lazy var playAgainButton: TopDownButtonViewModel = {
        TopDownButtonViewModel(height: functionButtonDimensions.0, width: functionButtonDimensions.1) {
            self.extraPlayAgainAction()
            AppNavigationController.shared.playAgainFourWordGame()
        }
    }()
    
    var gameOverData: FourWordGameOverDataModel
    
    /// Initializer
    init(_ gameOverData: FourWordGameOverDataModel,
         extraPlayAgainAction: @escaping () -> Void = {},
         extraGameOverAction: @escaping () -> Void = {}) {
        self.gameOverData = gameOverData
        self.extraPlayAgainAction = extraPlayAgainAction
        self.extraGameOverAction = extraGameOverAction
    }
}
