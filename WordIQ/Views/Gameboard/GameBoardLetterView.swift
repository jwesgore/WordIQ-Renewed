import SwiftUI

/// View for a single board square
struct GameBoardLetterView : View {
    
    @ObservedObject var viewModel : GameBoardLetterViewModel
    
    var edgeSize: CGFloat
    var fontWeight: RobotoSlabOptions.Weight = .semiBold
    var fontSizeMultiplier: Double = 0.5
    
    var body : some View {
        Text(viewModel.letter?.stringValue ?? " ")
            .robotoSlabFont(edgeSize * fontSizeMultiplier, fontWeight)
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

extension GameBoardLetterView {
    init(_ viewModel: GameBoardLetterViewModel, edgeSize: CGFloat = 10.0, fontSizeMultiplier: Double = 0.5) {
        self.viewModel = viewModel
        self.edgeSize = edgeSize
        self.fontSizeMultiplier = fontSizeMultiplier
    }
}

#Preview {
    GameBoardLetterView(GameBoardLetterViewModel(letter: .A))
        .frame(width: 50)
}
