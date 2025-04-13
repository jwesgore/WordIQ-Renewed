import SwiftUI

/// All possible game modes
enum GameMode: Int, Codable, Identifiable, Equatable {

    case standardMode = 0
    case rushMode = 1
    case frenzyMode = 2
    case zenMode = 3
    case dailyGame = 4
    case quickplay = 5
    case quadWordMode = 6
    case twentyQuestions = 7

    var id: Int { self.rawValue }
    
    /// Get GameMode from id
    static func fromId(_ id: Int) -> GameMode? {
        switch id {
        case 0: return .standardMode
        case 1: return .rushMode
        case 2: return .frenzyMode
        case 3: return .zenMode
        case 4: return .dailyGame
        case 5: return .quickplay
        case 6: return .quadWordMode
        case 7: return .twentyQuestions
        default: return nil
        }
    }
}

extension GameMode {
    var chartColor: Color {
        switch self {
        case .standardMode: return .blue
        case .rushMode: return .green
        case .frenzyMode: return .orange
        case .zenMode: return .purple
        case .dailyGame: return .red
        case .quadWordMode: return ValueConverter.colorFromHex("#006400")
        default: return .yellow
        }
    }
}

/// String values for enum
extension GameMode {
    /// Get GameMode as string
    var asStringShort: String {
        switch self {
        case .standardMode: return "Standard"
        case .rushMode: return "Rush"
        case .frenzyMode: return "Frenzy"
        case .zenMode: return "Zen"
        case .dailyGame: return "Daily"
        case .quickplay: return "Quickplay"
        case .quadWordMode: return "Quad"
        case .twentyQuestions: return "Twenty Guesses"
        }
    }
    
    var asStringLong: String {
        switch self {
        case .standardMode: return "Standard Mode"
        case .rushMode: return "Rush Mode"
        case .frenzyMode: return "Frenzy Mode"
        case .zenMode: return "Zen Mode"
        default: return ""
        }
    }
    
    /// Get text caption for GameMode
    var caption: String {
        switch self {
        case .standardMode: return "Guess the word"
        case .rushMode: return "Test your speed"
        case .frenzyMode: return "Test your endurance"
        case .zenMode: return "Take it easy"
        case .dailyGame: return "New Daily Available!"
        case .quadWordMode: return "Four words at once"
        case .twentyQuestions: return "Twenty guesses, five words"
        default: return ""
        }
    }
    
    /// Get text description for GameMode
    var description: String {
        switch self {
        case .standardMode: return "The classic game you know and love. Six guesses to get the word."
        case .rushMode: return "Make as many guesses as you want, but you only have so much time."
        case .frenzyMode: return "Only six guesses and a time limit. How many words can you get?"
        case .zenMode: return "No time limit, no guess limit. Just play to have fun."
        default: return ""
        }
    }
}
