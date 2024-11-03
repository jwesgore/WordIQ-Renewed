import SwiftUI

/// Enum to support comparison between incoming word and target word
enum LetterComparison: Comparable {
    case wrong
    case contains
    case correct
    
    var rank: Int {
        switch self {
        case .wrong: 1
        case .contains: 2
        case .correct: 3
        }
    }
    
    var color: Color {
        switch self {
        case .wrong: .gray
        case .contains: .yellow
        case .correct: .green
        }
    }
    
    /// Implementation of comparable
    static func < (lhs: LetterComparison, rhs: LetterComparison) -> Bool {
        return lhs.rank < rhs.rank
    }
}
