import SwiftUI

/// View of a single game letter
struct GameLetterView : View {
    
    @ObservedObject var letterVM : GameBoardLetterViewModel
    
    init(_ letterVM: GameBoardLetterViewModel) {
        self.letterVM = letterVM
    }
    
    var body : some View {

        Text(letterVM.letter?.stringValue ?? " ")
            .font(.custom(RobotoSlabOptions.Weight.bold, size: CGFloat(RobotoSlabOptions.Size.title1)))
            .frame(maxWidth:letterVM.width, maxHeight: letterVM.height)
            .aspectRatio(1.0, contentMode: .fit)
            .background(letterVM.backgroundColor)
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