import SwiftUI

/// View of a game board with six game words
struct GameBoardView : View {
    
    @ObservedObject var viewModel: GameBoardViewModel
    
    var body: some View {
        let aspectRatio = aspectRatio(viewModel: viewModel)
        
        GeometryReader { geometry in
            let edgeLength = edgeLength(geometry: geometry, viewModel: viewModel)
            
            VStack (spacing: viewModel.boardSpacing) {
                ForEach(viewModel.wordViewModels, id: \.self.id) {
                    GameWordView($0, edgeLength: edgeLength)
                }
            }
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
    }
    
    private func aspectRatio(viewModel: GameBoardViewModel) -> Double {
        let boardHeight = Double(viewModel.boardHeight)
        let boardWidth = Double(viewModel.boardWidth)
        return boardWidth / boardHeight
    }

    private func edgeLength(geometry: GeometryProxy, viewModel: GameBoardViewModel) -> CGFloat {
        
        let boardHeight = CGFloat(viewModel.boardHeight)
        let boardWidth = CGFloat(viewModel.boardWidth)
        
        let height = geometry.size.height - (viewModel.boardSpacing * (boardHeight - 1.0))
        let width = geometry.size.width - (viewModel.boardSpacing * (boardWidth - 1.0))
        
        return min(height / boardHeight, width / boardWidth )
    }
}



extension GameBoardView {
    init(_ viewModel: GameBoardViewModel) {
        self.viewModel = viewModel
    }
}

#Preview {
    GameBoardView(GameBoardViewModel(boardHeight: 6, boardWidth: 5, boardSpacing: 2.0))
}
