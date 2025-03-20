import SwiftUI

/// View of a game board with six game words
struct GameBoardView : View {
    
    @ObservedObject var viewModel: GameBoardViewModel
    
    var body: some View {
        
        VStack (spacing: viewModel.boardSpacing) {
            ForEach(viewModel.wordViewModels, id: \.self.id) {
                GameWordView($0)
            }
        }
    }
}

extension GameBoardView {
    init(_ viewModel: GameBoardViewModel) {
        self.viewModel = viewModel
    }
}
