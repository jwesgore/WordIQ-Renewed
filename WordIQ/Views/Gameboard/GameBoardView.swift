import SwiftUI

/// View of a game board with six game words
struct GameBoardView : View {
    
    var gameBoardWords : [GameBoardWordViewModel]
    var spacing : CGFloat
    
    init(_ gameBoardWords: [GameBoardWordViewModel], spacing : CGFloat = 5) {
        self.gameBoardWords = gameBoardWords
        self.spacing = spacing
    }
    
    var body: some View {
        VStack (spacing: 5) {
            GameWordView(gameBoardWords[0])
            GameWordView(gameBoardWords[1])
            GameWordView(gameBoardWords[2])
            GameWordView(gameBoardWords[3])
            GameWordView(gameBoardWords[4])
            GameWordView(gameBoardWords[5])
        }
    }
}
