import SwiftUI

/// Enum to support comparison between incoming word and target word
enum LetterComparison: Comparable {
    case wrong, contains, correct, notSet
    
    var rank: Int {
        switch self {
        case .notSet: 0
        case .wrong: 1
        case .contains: 2
        case .correct: 3
        }
    }
    
    var color: Color {
        switch self {
        case .notSet: .LetterComparison.notSet
        case .wrong: .LetterComparison.wrong
        case .contains: .LetterComparison.contains
        case .correct:
            UserDefaultsHelper.shared.setting_colorBlindMode ?
                .LetterComparison.correctColorBlind : .LetterComparison.correct
        }
    }
    
    /// Implementation of comparable
    static func < (lhs: LetterComparison, rhs: LetterComparison) -> Bool {
        return lhs.rank < rhs.rank
    }
}
