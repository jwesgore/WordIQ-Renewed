import SwiftUI

/// View of a single game letter
struct GameLetterView : View {
    
    @ObservedObject var letterVM : GameBoardLetterViewModel
    
    init(_ letterVM: GameBoardLetterViewModel) {
        self.letterVM = letterVM
    }
    
    var body : some View {

        Text(letterVM.letter?.stringValue ?? " ")
            .robotoSlabFont(.title1, .bold)
            .opacity(letterVM.opacity)
            .frame(maxWidth:letterVM.width, maxHeight: letterVM.height)
            .aspectRatio(1.0, contentMode: .fit)
            .background(letterVM.showBackgroundColor ? letterVM.backgroundColor.color : .LetterComparison.notSet)
            .overlay(
                RoundedRectangle(cornerRadius: letterVM.cornerRadius)
                    .stroke(letterVM.borderColor, lineWidth: letterVM.borderThickness)
            )
            .clipShape(RoundedRectangle(cornerRadius: letterVM.cornerRadius))
    }
}

#Preview {
    GameLetterView(GameBoardLetterViewModel(letter: .A))
}
