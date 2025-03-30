import SwiftUI

/// Base class for shared functionality between game words
class GameWordBaseViewModel: ObservableObject, Identifiable {
    
    let boardSpacing: CGFloat
    let boardWidth: Int
    let id: UUID
    
    var letters: [GameBoardLetterViewModel] = []
    
    init(boardWidth: Int, boardSpacing: CGFloat, id: UUID = UUID()) {
        self.boardWidth = boardWidth
        self.boardSpacing = boardSpacing
        self.id = id
    }
    
    /// Sets background colors on the letters with a cascade animation
    func setBackgrounds(_ comparisons : [LetterComparison],
                        animationDuration: Double = 0.2,
                        cascadeSpeed: Double = 0.125) {
        for i in 0..<boardWidth {
            self.letters[i].backgroundColor = comparisons[i]
            DispatchQueue.main.asyncAfter(deadline: .now() + (cascadeSpeed * Double(i))) {
                withAnimation(.smooth(duration: animationDuration)) {
                    self.letters[i].showBackgroundColor = true
                }
            }
        }
    }
}
