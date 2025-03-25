import SwiftUI

/// View of a single game letter
struct GameLetterView : View {
    
    @ObservedObject var viewModel : GameBoardLetterViewModel
    var edgeSize: CGFloat
    
    var body : some View {
        Text(viewModel.letter?.stringValue ?? " ")
            .robotoSlabFont(viewModel.fontSize, viewModel.fontWeight)
            .opacity(viewModel.opacity)
            .frame(width: edgeSize, height: edgeSize)
            .background(viewModel.showBackgroundColor ? viewModel.backgroundColor.color : .LetterComparison.notSet)
            .overlay(
                RoundedRectangle(cornerRadius: viewModel.cornerRadius)
                    .stroke(viewModel.borderColor, lineWidth: viewModel.borderThickness)
            )
            .clipShape(RoundedRectangle(cornerRadius: viewModel.cornerRadius))
            .aspectRatio(1, contentMode: .fit)
    }
}

extension GameLetterView {
    init(_ viewModel: GameBoardLetterViewModel, edgeSize: CGFloat = 10.0) {
        self.viewModel = viewModel
        self.edgeSize = edgeSize
    }
}

//#Preview {
//    GameLetterView(GameBoardLetterViewModel(letter: .A))
//        .frame(width: 50)
//}
