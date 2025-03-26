import SwiftUI

/// View of a single row in the GameView representing a single word
struct GameWordView : View {
    
    @ObservedObject var viewModel : GameBoardWordViewModel
    var edgeLength: CGFloat
    
    var body: some View {
        HStack (spacing: viewModel.boardSpacing) {
            ForEach(viewModel.letters, id: \.self.id) {
                GameLetterView($0, edgeSize: edgeLength)
            }
        }
        .modifier(ShakeEffect(animatableData: viewModel.shakeWord ? 1.5 : 0))
    }
}

extension GameWordView {
    init(_ viewModel: GameBoardWordViewModel, edgeLength: CGFloat) {
        self.viewModel = viewModel
        self.edgeLength = edgeLength
    }
}

#Preview {
    GameWordView(GameBoardWordViewModel(boardWidth: 5, boardSpacing: 5.0), edgeLength: 10.0)
}
