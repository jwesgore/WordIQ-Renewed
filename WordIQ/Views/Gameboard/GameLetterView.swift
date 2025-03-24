import SwiftUI

/// View of a single game letter
struct GameLetterView : View {
    
    @ObservedObject var viewModel : GameBoardLetterViewModel
    
    var body : some View {
        GeometryReader { geometry in
            let edgeSize = min(geometry.size.width, geometry.size.height)
            
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
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

extension GameLetterView {
    init(_ viewModel: GameBoardLetterViewModel) {
        self.viewModel = viewModel
    }
}

#Preview {
    GameLetterView(GameBoardLetterViewModel(letter: .A))
        .frame(width: 50)
}
