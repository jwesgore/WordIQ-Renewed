import SwiftUI

/// View for displaying a target word on a game over view
struct GameOverWordView : View {
    
    @ObservedObject var viewModel: GameOverWordViewModel
    var spacing: CGFloat = 2.0
    let maxWidth: CGFloat = 250
    
    var body: some View {
        let totalSpacingRoom = CGFloat(viewModel.letters.count - 1) * spacing
        let letterCount = CGFloat(viewModel.letters.count)
        GeometryReader { geometry in
            let edgeLength = (geometry.size.width - totalSpacingRoom) / letterCount
            
            HStack (spacing: spacing) {
                ForEach(viewModel.letters, id: \.self.id) { letter in
                    GameBoardLetterView(letter, edgeSize: edgeLength)
                }
            }
        }
        .aspectRatio(letterCount, contentMode: .fit)
        .frame(maxWidth: maxWidth)
    }
}

extension GameOverWordView {
    init (_ viewModel: GameOverWordViewModel) {
        self.viewModel = viewModel
        self.spacing = viewModel.boardSpacing
    }
}
