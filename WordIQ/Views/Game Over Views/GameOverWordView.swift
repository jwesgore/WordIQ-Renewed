import SwiftUI

/// A view for displaying the target word on a game over screen.
///
/// This view lays out each letter of the target word using a dynamically calculated edge length,
/// ensuring the overall word fits within the maximum width.
struct GameOverWordView: View {
    
    // MARK: - Properties
    
    /// The view model supplying the letters and layout spacing.
    @ObservedObject var viewModel: GameOverWordViewModel
    
    /// The spacing between each letter.
    var spacing: CGFloat = 2.0
    
    /// The maximum width for the displayed word.
    let maxWidth: CGFloat = 250
    
    // MARK: - Body
    
    var body: some View {
        // Compute the total spacing between letters, and the number of letters.
        let letterCount = CGFloat(viewModel.letters.count)
        let totalSpacing = (letterCount - 1) * spacing
        
        GeometryReader { geometry in
            // Compute the ideal edge length for each letter given the available width.
            let edgeLength = (geometry.size.width - totalSpacing) / letterCount
            
            HStack(spacing: spacing) {
                ForEach(viewModel.letters, id: \.self.id) { letter in
                    GameBoardLetterView(letter, edgeSize: edgeLength)
                }
            }
        }
        .aspectRatio(letterCount, contentMode: .fit)
        .frame(maxWidth: maxWidth)
    }
}

// MARK: - Initializer Extension

extension GameOverWordView {
    /// Convenience initializer that uses the viewModel’s board spacing to configure the view.
    /// - Parameter viewModel: The GameOverWordViewModel which supplies the necessary data.
    init(_ viewModel: GameOverWordViewModel) {
        self.viewModel = viewModel
        self.spacing = viewModel.boardSpacing
    }
}
