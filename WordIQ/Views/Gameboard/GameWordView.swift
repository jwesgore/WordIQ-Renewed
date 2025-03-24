import SwiftUI

/// View of a single row in the GameView representing a single word
struct GameWordView : View {
    
    @ObservedObject var viewModel : GameBoardWordViewModel
    
    var body: some View {
        HStack (spacing: viewModel.boardSpacing) {
            ForEach(viewModel.letters, id: \.self.id) {
                GameLetterView($0)
            }
        }
        .modifier(ShakeEffect(animatableData: viewModel.shakeWord ? 1.5 : 0))
    }
}

extension GameWordView {
    init(_ viewModel: GameBoardWordViewModel) {
        self.viewModel = viewModel
    }
}

#Preview {
    GameWordView(GameBoardWordViewModel(boardWidth: 5, boardSpacing: 5.0))
}
