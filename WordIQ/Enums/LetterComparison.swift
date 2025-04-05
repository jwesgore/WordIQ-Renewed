import SwiftUI
import Foundation

/// Enum to support comparison between incoming word and target word
enum LetterComparison: Int, Comparable, Codable {
    case wrong = 1
    case contains = 2
    case correct = 3
    case notSet = 0
        
    /// Implementation of Comparable
    static func < (lhs: LetterComparison, rhs: LetterComparison) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension LetterComparison {
    // MARK: - Properties
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
    
    // MARK: - Functions
    /// Gets a collection of LetterComparisons
    static func getCollection(size: Int, value: LetterComparison) -> [LetterComparison] {
        return [LetterComparison](repeating: value, count: size)
    }
    
    /// Returns the maximum value of both lists
    static func max(_ lhs: [LetterComparison], _ rhs: [LetterComparison]) -> [LetterComparison] {
        guard lhs.count == rhs.count else {
            fatalError("The input arrays must have the same length.")
        }
        return zip(lhs, rhs).map { Swift.max($0.0, $0.1) }
    }
}
