import SwiftUI

struct FourWordGameBoardView : View {
    
    @ObservedObject var viewModel: MultiGameBoardViewModel
    @ObservedObject var board1: GameBoardViewModel
    @ObservedObject var board2: GameBoardViewModel
    @ObservedObject var board3: GameBoardViewModel
    @ObservedObject var board4: GameBoardViewModel
    
    var body: some View {
        
        VStack (spacing: viewModel.boardMargin) {
            HStack (spacing: viewModel.boardMargin) {
                GameBoardView(board1)
                GameBoardView(board2)
            }
            
            HStack (spacing: viewModel.boardMargin) {
                GameBoardView(board3)
                GameBoardView(board4)
            }
        }
    }
}

extension FourWordGameBoardView {
    init(_ viewModel: MultiGameBoardViewModel) {
        let boardIds = viewModel.getBoardIds()
        
        self.viewModel = viewModel
        
        self.board1 = viewModel.gameBoards[boardIds[0]]!
        self.board2 = viewModel.gameBoards[boardIds[1]]!
        self.board3 = viewModel.gameBoards[boardIds[2]]!
        self.board4 = viewModel.gameBoards[boardIds[3]]!
    }
}

//#Preview {
//    FourWordGameBoardView(MultiGameBoardViewModel(boardHeight: 9, boardWidth: 5, boardCount: 4, boardSpacing: 1.0, boardMargin: 10.0, targetWords: <#[UUID : DatabaseWordModel]?#>))
//}
