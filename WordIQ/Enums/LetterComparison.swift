import SwiftUI

/// Enum to support comparison between incoming word and target word
enum LetterComparison: Comparable, Codable {
    case wrong, contains, correct, notSet
        
    /// Implementation of comparable
    static func < (lhs: LetterComparison, rhs: LetterComparison) -> Bool {
        return lhs.rank < rhs.rank
    }
}

/// Helper properties
extension LetterComparison {
    
    /// Get rank of comparison
    var rank: Int {
        switch self {
        case .notSet: 0
        case .wrong: 1
        case .contains: 2
        case .correct: 3
        }
    }
    
    /// Get Color of enum
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
}
