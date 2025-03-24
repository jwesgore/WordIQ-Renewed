import SwiftUI

/// View Model for a game over screen
class FourWordGameOverViewModel : ObservableObject {
    
    @Published var gameOverData : FourWordGameOverDataModel
    
    /// Initializer
    init(_ gameOverModel: FourWordGameOverDataModel) {
        gameOverData = gameOverModel
    }
}
