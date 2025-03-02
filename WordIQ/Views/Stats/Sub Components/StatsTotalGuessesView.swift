import SwiftUI

/// View Container for General Stats of total guesses
struct StatsTotalGuessesView: View {
    
    var totalGuesses: Int
    var totalValidGuesses: Int
    var totalInvalidGuesses: Int
    
    var ratioText: String = ""
    
    init(totalGuesses: Int, totalValidGuesses: Int, totalInvalidGuesses: Int) {
        self.totalGuesses = totalGuesses
        self.totalValidGuesses = totalValidGuesses
        self.totalInvalidGuesses = totalInvalidGuesses
        
        if totalValidGuesses >= totalInvalidGuesses && totalInvalidGuesses != 0 {
            let ratio = Double(totalValidGuesses) / Double(totalInvalidGuesses)
            ratioText = " That's a ratio of \(String(format: "%.1f", ratio)) : 1 valid guesses to invalid guesses!"
        } else if totalInvalidGuesses >= totalValidGuesses && totalValidGuesses != 0 {
            let ratio = Double(totalInvalidGuesses) / Double(totalValidGuesses)
            ratioText = " That's a ratio of \(String(format: "%.1f", ratio)) : 1 invalid guesses to valid guesses!"
        }
    }
    
    var body: some View {
        GroupBox {
            HStack {
                Text("You have made a total of \(totalGuesses) guesses, of which \(totalValidGuesses) were considered valid and \(totalInvalidGuesses) were considered invalid.\(ratioText)")
                    .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.subheading)))
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
    }
}
