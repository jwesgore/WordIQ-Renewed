import SwiftUI

/// A View representing the game board for Twenty Questions mode.
///
/// This View displays the number of guesses left and active/inactive circles,
/// alongside the main game board for interactions.
struct TwentyQuestionsGameBoardView: View {
    
    /// The ViewModel that manages the state of the Twenty Questions game.
    @ObservedObject var viewModel: TwentyQuestionsGameBoardViewModel
    
    var body: some View {
        VStack(spacing: 5.0) {
            HStack {
                // Display the number of guesses left
                Text("Guesses Left: \(viewModel.numberOfQuestionsLeft)")
                    .robotoSlabFont(.headline, .semiBold)
                
                Spacer()
                
                // Display the game circles
                ForEach(0..<viewModel.circleStates.count, id: \.self) { index in
                    GameBoard_Circle(isActive: $viewModel.circleStates[index])
                }
            }
            
            // Main game board
            GameBoardView(viewModel)
        }
    }
}

extension TwentyQuestionsGameBoardView {
    /// Custom initializer for `TwentyQuestionsGameBoardView`.
    /// - Parameter viewModel: The ViewModel managing the game logic and state.
    init(_ viewModel: TwentyQuestionsGameBoardViewModel) {
        self.viewModel = viewModel
    }
}

/// A View representing an individual game board circle.
///
/// Circles display their active/inactive state visually and allow for
/// scalable designs.
struct GameBoard_Circle: View {
    
    /// The diameter of the circle.
    var diameter: CGFloat = 20
    
    /// A binding that determines whether the circle is active or inactive.
    @Binding var isActive: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 1)
            .fill(isActive ? Color.GameBoard.letterBorderActive : Color.GameBoard.letterBorderInactive)
            .background(isActive ? LetterComparison.correct.color : Color.clear)
            .clipShape(Circle())
            .frame(maxWidth: diameter)
    }
}
