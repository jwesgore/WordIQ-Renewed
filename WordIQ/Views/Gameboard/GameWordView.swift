import SwiftUI

/// View of a single row in the GameView representing a single word
struct GameWordView : View {
    
    @ObservedObject var wordVM : GameBoardWordViewModel
    var spacing : CGFloat
    
    init(_ wordVM: GameBoardWordViewModel, spacing : CGFloat = 5) {
        self.wordVM = wordVM
        self.spacing = spacing
    }
    
    var body: some View {
        HStack (spacing: spacing) {
            GameLetterView(wordVM.letters[0])
            GameLetterView(wordVM.letters[1])
            GameLetterView(wordVM.letters[2])
            GameLetterView(wordVM.letters[3])
            GameLetterView(wordVM.letters[4])
        }
        .modifier(ShakeEffect(animatableData: wordVM.Shake ? 1.5 : 0))
    }
}

#Preview {
    GameWordView(GameBoardWordViewModel())
}
